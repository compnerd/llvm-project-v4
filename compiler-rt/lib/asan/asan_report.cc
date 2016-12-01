//===-- asan_report.cc ----------------------------------------------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file is a part of AddressSanitizer, an address sanity checker.
//
// This file contains error reporting code.
//===----------------------------------------------------------------------===//

#include "asan_errors.h"
#include "asan_flags.h"
#include "asan_descriptions.h"
#include "asan_internal.h"
#include "asan_mapping.h"
#include "asan_report.h"
#include "asan_scariness_score.h"
#include "asan_stack.h"
#include "asan_thread.h"
#include "sanitizer_common/sanitizer_common.h"
#include "sanitizer_common/sanitizer_flags.h"
#include "sanitizer_common/sanitizer_report_decorator.h"
#include "sanitizer_common/sanitizer_stackdepot.h"
#include "sanitizer_common/sanitizer_symbolizer.h"

namespace __asan {

// -------------------- User-specified callbacks ----------------- {{{1
static void (*error_report_callback)(const char*);
static char *error_message_buffer = nullptr;
static uptr error_message_buffer_pos = 0;
static BlockingMutex error_message_buf_mutex(LINKER_INITIALIZED);
static const unsigned kAsanBuggyPcPoolSize = 25;
static __sanitizer::atomic_uintptr_t AsanBuggyPcPool[kAsanBuggyPcPoolSize];

void AppendToErrorMessageBuffer(const char *buffer) {
  BlockingMutexLock l(&error_message_buf_mutex);
  if (!error_message_buffer) {
    error_message_buffer =
      (char*)MmapOrDieQuietly(kErrorMessageBufferSize, __func__);
    error_message_buffer_pos = 0;
  }
  uptr length = internal_strlen(buffer);
  RAW_CHECK(kErrorMessageBufferSize >= error_message_buffer_pos);
  uptr remaining = kErrorMessageBufferSize - error_message_buffer_pos;
  internal_strncpy(error_message_buffer + error_message_buffer_pos,
                   buffer, remaining);
  error_message_buffer[kErrorMessageBufferSize - 1] = '\0';
  // FIXME: reallocate the buffer instead of truncating the message.
  error_message_buffer_pos += Min(remaining, length);
}

// ---------------------- Helper functions ----------------------- {{{1

void PrintMemoryByte(InternalScopedString *str, const char *before, u8 byte,
                     bool in_shadow, const char *after) {
  Decorator d;
  str->append("%s%s%x%x%s%s", before,
              in_shadow ? d.ShadowByte(byte) : d.MemoryByte(),
              byte >> 4, byte & 15,
              in_shadow ? d.EndShadowByte() : d.EndMemoryByte(), after);
}

static void PrintZoneForPointer(uptr ptr, uptr zone_ptr,
                                const char *zone_name) {
  if (zone_ptr) {
    if (zone_name) {
      Printf("malloc_zone_from_ptr(%p) = %p, which is %s\n",
                 ptr, zone_ptr, zone_name);
    } else {
      Printf("malloc_zone_from_ptr(%p) = %p, which doesn't have a name\n",
                 ptr, zone_ptr);
    }
  } else {
    Printf("malloc_zone_from_ptr(%p) = 0\n", ptr);
  }
}

// ---------------------- Address Descriptions ------------------- {{{1

bool ParseFrameDescription(const char *frame_descr,
                           InternalMmapVector<StackVarDescr> *vars) {
  CHECK(frame_descr);
  char *p;
  // This string is created by the compiler and has the following form:
  // "n alloc_1 alloc_2 ... alloc_n"
  // where alloc_i looks like "offset size len ObjectName".
  uptr n_objects = (uptr)internal_simple_strtoll(frame_descr, &p, 10);
  if (n_objects == 0)
    return false;

  for (uptr i = 0; i < n_objects; i++) {
    uptr beg  = (uptr)internal_simple_strtoll(p, &p, 10);
    uptr size = (uptr)internal_simple_strtoll(p, &p, 10);
    uptr len  = (uptr)internal_simple_strtoll(p, &p, 10);
    if (beg == 0 || size == 0 || *p != ' ') {
      return false;
    }
    p++;
    StackVarDescr var = {beg, size, p, len};
    vars->push_back(var);
    p += len;
  }

  return true;
}

// -------------------- Different kinds of reports ----------------- {{{1

// Use ScopedInErrorReport to run common actions just before and
// immediately after printing error report.
class ScopedInErrorReport {
 public:
  explicit ScopedInErrorReport(bool fatal = false) {
    halt_on_error_ = fatal || flags()->halt_on_error;

    if (lock_.TryLock()) {
      StartReporting();
      return;
    }

    // ASan found two bugs in different threads simultaneously.

    u32 current_tid = GetCurrentTidOrInvalid();
    if (reporting_thread_tid_ == current_tid ||
        reporting_thread_tid_ == kInvalidTid) {
      // This is either asynch signal or nested error during error reporting.
      // Fail simple to avoid deadlocks in Report().

      // Can't use Report() here because of potential deadlocks
      // in nested signal handlers.
      const char msg[] = "AddressSanitizer: nested bug in the same thread, "
                         "aborting.\n";
      WriteToFile(kStderrFd, msg, sizeof(msg));

      internal__exit(common_flags()->exitcode);
    }

    if (halt_on_error_) {
      // Do not print more than one report, otherwise they will mix up.
      // Error reporting functions shouldn't return at this situation, as
      // they are effectively no-returns.

      Report("AddressSanitizer: while reporting a bug found another one. "
             "Ignoring.\n");

      // Sleep long enough to make sure that the thread which started
      // to print an error report will finish doing it.
      SleepForSeconds(Max(100, flags()->sleep_before_dying + 1));

      // If we're still not dead for some reason, use raw _exit() instead of
      // Die() to bypass any additional checks.
      internal__exit(common_flags()->exitcode);
    } else {
      // The other thread will eventually finish reporting
      // so it's safe to wait
      lock_.Lock();
    }

    StartReporting();
  }

  ~ScopedInErrorReport() {
    ASAN_ON_ERROR();
    if (current_error_.IsValid()) current_error_.Print();

    // Make sure the current thread is announced.
    DescribeThread(GetCurrentThread());
    // We may want to grab this lock again when printing stats.
    asanThreadRegistry().Unlock();
    // Print memory stats.
    if (flags()->print_stats)
      __asan_print_accumulated_stats();

    if (common_flags()->print_cmdline)
      PrintCmdline();

    // Copy the message buffer so that we could start logging without holding a
    // lock that gets aquired during printing.
    InternalScopedBuffer<char> buffer_copy(kErrorMessageBufferSize);
    {
      BlockingMutexLock l(&error_message_buf_mutex);
      internal_memcpy(buffer_copy.data(),
                      error_message_buffer, kErrorMessageBufferSize);
    }

    LogFullErrorReport(buffer_copy.data());

    if (error_report_callback) {
      error_report_callback(buffer_copy.data());
    }

    // In halt_on_error = false mode, reset the current error object (before
    // unlocking).
    if (!halt_on_error_)
      internal_memset(&current_error_, 0, sizeof(current_error_));

    CommonSanitizerReportMutex.Unlock();
    reporting_thread_tid_ = kInvalidTid;
    lock_.Unlock();
    if (halt_on_error_) {
      Report("ABORTING\n");
      Die();
    }
  }

  void ReportError(const ErrorDescription &description) {
    // Can only report one error per ScopedInErrorReport.
    CHECK_EQ(current_error_.kind, kErrorKindInvalid);
    current_error_ = description;
  }

  static ErrorDescription &CurrentError() {
    return current_error_;
  }

 private:
  void StartReporting() {
    // Make sure the registry and sanitizer report mutexes are locked while
    // we're printing an error report.
    // We can lock them only here to avoid self-deadlock in case of
    // recursive reports.
    asanThreadRegistry().Lock();
    CommonSanitizerReportMutex.Lock();
    reporting_thread_tid_ = GetCurrentTidOrInvalid();
    Printf("===================================================="
           "=============\n");
  }

  static StaticSpinMutex lock_;
  static u32 reporting_thread_tid_;
  // Error currently being reported. This enables the destructor to interact
  // with the debugger and point it to an error description.
  static ErrorDescription current_error_;
  bool halt_on_error_;
};

StaticSpinMutex ScopedInErrorReport::lock_;
u32 ScopedInErrorReport::reporting_thread_tid_ = kInvalidTid;
ErrorDescription ScopedInErrorReport::current_error_;

void ReportStackOverflow(const SignalContext &sig) {
  ScopedInErrorReport in_report(/*fatal*/ true);
  ErrorStackOverflow error(GetCurrentTidOrInvalid(), sig);
  in_report.ReportError(error);
}

void ReportDeadlySignal(int signo, const SignalContext &sig) {
  ScopedInErrorReport in_report(/*fatal*/ true);
  ErrorDeadlySignal error(GetCurrentTidOrInvalid(), sig, signo);
  in_report.ReportError(error);
}

void ReportDoubleFree(uptr addr, BufferedStackTrace *free_stack) {
  ScopedInErrorReport in_report;
  ErrorDoubleFree error(GetCurrentTidOrInvalid(), free_stack, addr);
  in_report.ReportError(error);
}

void ReportNewDeleteSizeMismatch(uptr addr, uptr delete_size,
                                 BufferedStackTrace *free_stack) {
  ScopedInErrorReport in_report;
  ErrorNewDeleteSizeMismatch error(GetCurrentTidOrInvalid(), free_stack, addr,
                                   delete_size);
  in_report.ReportError(error);
}

void ReportFreeNotMalloced(uptr addr, BufferedStackTrace *free_stack) {
  ScopedInErrorReport in_report;
  ErrorFreeNotMalloced error(GetCurrentTidOrInvalid(), free_stack, addr);
  in_report.ReportError(error);
}

void ReportAllocTypeMismatch(uptr addr, BufferedStackTrace *free_stack,
                             AllocType alloc_type,
                             AllocType dealloc_type) {
  ScopedInErrorReport in_report;
  ErrorAllocTypeMismatch error(GetCurrentTidOrInvalid(), free_stack, addr,
                               alloc_type, dealloc_type);
  in_report.ReportError(error);
}

void ReportMallocUsableSizeNotOwned(uptr addr, BufferedStackTrace *stack) {
  ScopedInErrorReport in_report;
  ErrorMallocUsableSizeNotOwned error(GetCurrentTidOrInvalid(), stack, addr);
  in_report.ReportError(error);
}

void ReportSanitizerGetAllocatedSizeNotOwned(uptr addr,
                                             BufferedStackTrace *stack) {
  ScopedInErrorReport in_report;
  ErrorSanitizerGetAllocatedSizeNotOwned error(GetCurrentTidOrInvalid(), stack,
                                               addr);
  in_report.ReportError(error);
}

void ReportStringFunctionMemoryRangesOverlap(const char *function,
                                             const char *offset1, uptr length1,
                                             const char *offset2, uptr length2,
                                             BufferedStackTrace *stack) {
  ScopedInErrorReport in_report;
  ErrorStringFunctionMemoryRangesOverlap error(
      GetCurrentTidOrInvalid(), stack, (uptr)offset1, length1, (uptr)offset2,
      length2, function);
  in_report.ReportError(error);
}

void ReportStringFunctionSizeOverflow(uptr offset, uptr size,
                                      BufferedStackTrace *stack) {
  ScopedInErrorReport in_report;
  ErrorStringFunctionSizeOverflow error(GetCurrentTidOrInvalid(), stack, offset,
                                        size);
  in_report.ReportError(error);
}

void ReportBadParamsToAnnotateContiguousContainer(uptr beg, uptr end,
                                                  uptr old_mid, uptr new_mid,
                                                  BufferedStackTrace *stack) {
  ScopedInErrorReport in_report;
  ErrorBadParamsToAnnotateContiguousContainer error(
      GetCurrentTidOrInvalid(), stack, beg, end, old_mid, new_mid);
  in_report.ReportError(error);
}

void ReportODRViolation(const __asan_global *g1, u32 stack_id1,
                        const __asan_global *g2, u32 stack_id2) {
  ScopedInErrorReport in_report;
  ErrorODRViolation error(GetCurrentTidOrInvalid(), g1, stack_id1, g2,
                          stack_id2);
  in_report.ReportError(error);
}

// ----------------------- CheckForInvalidPointerPair ----------- {{{1
static NOINLINE void ReportInvalidPointerPair(uptr pc, uptr bp, uptr sp,
                                              uptr a1, uptr a2) {
  ScopedInErrorReport in_report;
  ErrorInvalidPointerPair error(GetCurrentTidOrInvalid(), pc, bp, sp, a1, a2);
  in_report.ReportError(error);
}

static INLINE void CheckForInvalidPointerPair(void *p1, void *p2) {
  if (!flags()->detect_invalid_pointer_pairs) return;
  uptr a1 = reinterpret_cast<uptr>(p1);
  uptr a2 = reinterpret_cast<uptr>(p2);
  AsanChunkView chunk1 = FindHeapChunkByAddress(a1);
  AsanChunkView chunk2 = FindHeapChunkByAddress(a2);
  bool valid1 = chunk1.IsAllocated();
  bool valid2 = chunk2.IsAllocated();
  if (!valid1 || !valid2 || !chunk1.Eq(chunk2)) {
    GET_CALLER_PC_BP_SP;
    return ReportInvalidPointerPair(pc, bp, sp, a1, a2);
  }
}
// ----------------------- Mac-specific reports ----------------- {{{1

void ReportMacMzReallocUnknown(uptr addr, uptr zone_ptr, const char *zone_name,
                               BufferedStackTrace *stack) {
  ScopedInErrorReport in_report;
  Printf("mz_realloc(%p) -- attempting to realloc unallocated memory.\n"
             "This is an unrecoverable problem, exiting now.\n",
             addr);
  PrintZoneForPointer(addr, zone_ptr, zone_name);
  stack->Print();
  DescribeAddressIfHeap(addr);
}

// -------------- SuppressErrorReport -------------- {{{1
// Avoid error reports duplicating for ASan recover mode.
static bool SuppressErrorReport(uptr pc) {
  if (!common_flags()->suppress_equal_pcs) return false;
  for (unsigned i = 0; i < kAsanBuggyPcPoolSize; i++) {
    uptr cmp = atomic_load_relaxed(&AsanBuggyPcPool[i]);
    if (cmp == 0 && atomic_compare_exchange_strong(&AsanBuggyPcPool[i], &cmp,
                                                   pc, memory_order_relaxed))
      return false;
    if (cmp == pc) return true;
  }
  Die();
}

void ReportGenericError(uptr pc, uptr bp, uptr sp, uptr addr, bool is_write,
                        uptr access_size, u32 exp, bool fatal) {
  if (!fatal && SuppressErrorReport(pc)) return;
  ENABLE_FRAME_POINTER;

  // Optimization experiments.
  // The experiments can be used to evaluate potential optimizations that remove
  // instrumentation (assess false negatives). Instead of completely removing
  // some instrumentation, compiler can emit special calls into runtime
  // (e.g. __asan_report_exp_load1 instead of __asan_report_load1) and pass
  // mask of experiments (exp).
  // The reaction to a non-zero value of exp is to be defined.
  (void)exp;

  ScopedInErrorReport in_report(fatal);
  ErrorGeneric error(GetCurrentTidOrInvalid(), pc, bp, sp, addr, is_write,
                     access_size);
  in_report.ReportError(error);
}

}  // namespace __asan

// --------------------------- Interface --------------------- {{{1
using namespace __asan;  // NOLINT

void __asan_report_error(uptr pc, uptr bp, uptr sp, uptr addr, int is_write,
                         uptr access_size, u32 exp) {
  ENABLE_FRAME_POINTER;
  bool fatal = flags()->halt_on_error;
  ReportGenericError(pc, bp, sp, addr, is_write, access_size, exp, fatal);
}

void NOINLINE __asan_set_error_report_callback(void (*callback)(const char*)) {
  BlockingMutexLock l(&error_message_buf_mutex);
  error_report_callback = callback;
}

void __asan_describe_address(uptr addr) {
  // Thread registry must be locked while we're describing an address.
  asanThreadRegistry().Lock();
  PrintAddressDescription(addr, 1, "");
  asanThreadRegistry().Unlock();
}

int __asan_report_present() {
  return ScopedInErrorReport::CurrentError().kind != kErrorKindInvalid;
}

uptr __asan_get_report_pc() {
  if (ScopedInErrorReport::CurrentError().kind == kErrorKindGeneric)
    return ScopedInErrorReport::CurrentError().Generic.pc;
  return 0;
}

uptr __asan_get_report_bp() {
  if (ScopedInErrorReport::CurrentError().kind == kErrorKindGeneric)
    return ScopedInErrorReport::CurrentError().Generic.bp;
  return 0;
}

uptr __asan_get_report_sp() {
  if (ScopedInErrorReport::CurrentError().kind == kErrorKindGeneric)
    return ScopedInErrorReport::CurrentError().Generic.sp;
  return 0;
}

uptr __asan_get_report_address() {
  ErrorDescription &err = ScopedInErrorReport::CurrentError();
  if (err.kind == kErrorKindGeneric)
    return err.Generic.addr_description.Address();
  else if (err.kind == kErrorKindDoubleFree)
    return err.DoubleFree.addr_description.addr;
  return 0;
}

int __asan_get_report_access_type() {
  if (ScopedInErrorReport::CurrentError().kind == kErrorKindGeneric)
    return ScopedInErrorReport::CurrentError().Generic.is_write;
  return 0;
}

uptr __asan_get_report_access_size() {
  if (ScopedInErrorReport::CurrentError().kind == kErrorKindGeneric)
    return ScopedInErrorReport::CurrentError().Generic.access_size;
  return 0;
}

const char *__asan_get_report_description() {
  if (ScopedInErrorReport::CurrentError().kind == kErrorKindGeneric)
    return ScopedInErrorReport::CurrentError().Generic.bug_descr;
  return ScopedInErrorReport::CurrentError().Base.scariness.GetDescription();
}

extern "C" {
SANITIZER_INTERFACE_ATTRIBUTE
void __sanitizer_ptr_sub(void *a, void *b) {
  CheckForInvalidPointerPair(a, b);
}
SANITIZER_INTERFACE_ATTRIBUTE
void __sanitizer_ptr_cmp(void *a, void *b) {
  CheckForInvalidPointerPair(a, b);
}
} // extern "C"

#if !SANITIZER_SUPPORTS_WEAK_HOOKS
// Provide default implementation of __asan_on_error that does nothing
// and may be overriden by user.
SANITIZER_INTERFACE_ATTRIBUTE SANITIZER_WEAK_ATTRIBUTE NOINLINE
void __asan_on_error() {}
#endif
