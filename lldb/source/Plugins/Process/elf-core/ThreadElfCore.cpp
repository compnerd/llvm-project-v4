//===-- ThreadElfCore.cpp --------------------------------------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "lldb/Core/DataExtractor.h"
#include "lldb/Core/Log.h"
#include "lldb/Target/RegisterContext.h"
#include "lldb/Target/StopInfo.h"
#include "lldb/Target/Target.h"
#include "lldb/Target/Unwind.h"

#include "Plugins/Process/Utility/RegisterContextFreeBSD_i386.h"
#include "Plugins/Process/Utility/RegisterContextFreeBSD_mips64.h"
#include "Plugins/Process/Utility/RegisterContextFreeBSD_powerpc.h"
#include "Plugins/Process/Utility/RegisterContextFreeBSD_x86_64.h"
#include "Plugins/Process/Utility/RegisterContextLinux_i386.h"
#include "Plugins/Process/Utility/RegisterContextLinux_s390x.h"
#include "Plugins/Process/Utility/RegisterContextLinux_x86_64.h"
#include "Plugins/Process/Utility/RegisterInfoPOSIX_arm.h"
#include "Plugins/Process/Utility/RegisterInfoPOSIX_arm64.h"
#include "ProcessElfCore.h"
#include "RegisterContextPOSIXCore_arm.h"
#include "RegisterContextPOSIXCore_arm64.h"
#include "RegisterContextPOSIXCore_mips64.h"
#include "RegisterContextPOSIXCore_powerpc.h"
#include "RegisterContextPOSIXCore_s390x.h"
#include "RegisterContextPOSIXCore_x86_64.h"
#include "ThreadElfCore.h"

using namespace lldb;
using namespace lldb_private;

//----------------------------------------------------------------------
// Construct a Thread object with given data
//----------------------------------------------------------------------
ThreadElfCore::ThreadElfCore(Process &process, const ThreadData &td)
    : Thread(process, td.tid), m_thread_name(td.name), m_thread_reg_ctx_sp(),
      m_signo(td.signo), m_gpregset_data(td.gpregset),
      m_fpregset_data(td.fpregset), m_vregset_data(td.vregset) {}

ThreadElfCore::~ThreadElfCore() { DestroyThread(); }

void ThreadElfCore::RefreshStateAfterStop() {
  GetRegisterContext()->InvalidateIfNeeded(false);
}

void ThreadElfCore::ClearStackFrames() {
  Unwind *unwinder = GetUnwinder();
  if (unwinder)
    unwinder->Clear();
  Thread::ClearStackFrames();
}

RegisterContextSP ThreadElfCore::GetRegisterContext() {
  if (m_reg_context_sp.get() == NULL) {
    m_reg_context_sp = CreateRegisterContextForFrame(NULL);
  }
  return m_reg_context_sp;
}

RegisterContextSP
ThreadElfCore::CreateRegisterContextForFrame(StackFrame *frame) {
  RegisterContextSP reg_ctx_sp;
  uint32_t concrete_frame_idx = 0;
  Log *log(GetLogIfAllCategoriesSet(LIBLLDB_LOG_THREAD));

  if (frame)
    concrete_frame_idx = frame->GetConcreteFrameIndex();

  if (concrete_frame_idx == 0) {
    if (m_thread_reg_ctx_sp)
      return m_thread_reg_ctx_sp;

    ProcessElfCore *process = static_cast<ProcessElfCore *>(GetProcess().get());
    ArchSpec arch = process->GetArchitecture();
    RegisterInfoInterface *reg_interface = NULL;

    switch (arch.GetTriple().getOS()) {
    case llvm::Triple::FreeBSD: {
      switch (arch.GetMachine()) {
      case llvm::Triple::aarch64:
        reg_interface = new RegisterInfoPOSIX_arm64(arch);
        break;
      case llvm::Triple::arm:
        reg_interface = new RegisterInfoPOSIX_arm(arch);
        break;
      case llvm::Triple::ppc:
        reg_interface = new RegisterContextFreeBSD_powerpc32(arch);
        break;
      case llvm::Triple::ppc64:
        reg_interface = new RegisterContextFreeBSD_powerpc64(arch);
        break;
      case llvm::Triple::mips64:
        reg_interface = new RegisterContextFreeBSD_mips64(arch);
        break;
      case llvm::Triple::x86:
        reg_interface = new RegisterContextFreeBSD_i386(arch);
        break;
      case llvm::Triple::x86_64:
        reg_interface = new RegisterContextFreeBSD_x86_64(arch);
        break;
      default:
        break;
      }
      break;
    }

    case llvm::Triple::Linux: {
      switch (arch.GetMachine()) {
      case llvm::Triple::arm:
        reg_interface = new RegisterInfoPOSIX_arm(arch);
        break;
      case llvm::Triple::aarch64:
        reg_interface = new RegisterInfoPOSIX_arm64(arch);
        break;
      case llvm::Triple::systemz:
        reg_interface = new RegisterContextLinux_s390x(arch);
        break;
      case llvm::Triple::x86:
        reg_interface = new RegisterContextLinux_i386(arch);
        break;
      case llvm::Triple::x86_64:
        reg_interface = new RegisterContextLinux_x86_64(arch);
        break;
      default:
        break;
      }
      break;
    }

    default:
      break;
    }

    if (!reg_interface) {
      if (log)
        log->Printf("elf-core::%s:: Architecture(%d) or OS(%d) not supported",
                    __FUNCTION__, arch.GetMachine(), arch.GetTriple().getOS());
      assert(false && "Architecture or OS not supported");
    }

    switch (arch.GetMachine()) {
    case llvm::Triple::aarch64:
      m_thread_reg_ctx_sp.reset(new RegisterContextCorePOSIX_arm64(
          *this, reg_interface, m_gpregset_data, m_fpregset_data));
      break;
    case llvm::Triple::arm:
      m_thread_reg_ctx_sp.reset(new RegisterContextCorePOSIX_arm(
          *this, reg_interface, m_gpregset_data, m_fpregset_data));
      break;
    case llvm::Triple::mips64:
      m_thread_reg_ctx_sp.reset(new RegisterContextCorePOSIX_mips64(
          *this, reg_interface, m_gpregset_data, m_fpregset_data));
      break;
    case llvm::Triple::ppc:
    case llvm::Triple::ppc64:
      m_thread_reg_ctx_sp.reset(new RegisterContextCorePOSIX_powerpc(
          *this, reg_interface, m_gpregset_data, m_fpregset_data,
          m_vregset_data));
      break;
    case llvm::Triple::systemz:
      m_thread_reg_ctx_sp.reset(new RegisterContextCorePOSIX_s390x(
          *this, reg_interface, m_gpregset_data, m_fpregset_data));
      break;
    case llvm::Triple::x86:
    case llvm::Triple::x86_64:
      m_thread_reg_ctx_sp.reset(new RegisterContextCorePOSIX_x86_64(
          *this, reg_interface, m_gpregset_data, m_fpregset_data));
      break;
    default:
      break;
    }

    reg_ctx_sp = m_thread_reg_ctx_sp;
  } else if (m_unwinder_ap.get()) {
    reg_ctx_sp = m_unwinder_ap->CreateRegisterContextForFrame(frame);
  }
  return reg_ctx_sp;
}

bool ThreadElfCore::CalculateStopInfo() {
  ProcessSP process_sp(GetProcess());
  if (process_sp) {
    SetStopInfo(StopInfo::CreateStopReasonWithSignal(*this, m_signo));
    return true;
  }
  return false;
}

//----------------------------------------------------------------
// Parse PRSTATUS from NOTE entry
//----------------------------------------------------------------
ELFLinuxPrStatus::ELFLinuxPrStatus() {
  memset(this, 0, sizeof(ELFLinuxPrStatus));
}

Error ELFLinuxPrStatus::Parse(DataExtractor &data, ArchSpec &arch) {
  Error error;
  if (GetSize(arch) > data.GetByteSize()) {
    error.SetErrorStringWithFormat(
        "NT_PRSTATUS size should be %zu, but the remaining bytes are: %" PRIu64,
        GetSize(arch), data.GetByteSize());
    return error;
  }

  // Read field by field to correctly account for endianess
  // of both the core dump and the platform running lldb.
  offset_t offset = 0;
  si_signo = data.GetU32(&offset);
  si_code = data.GetU32(&offset);
  si_errno = data.GetU32(&offset);

  pr_cursig = data.GetU16(&offset);
  offset += 2; // pad

  pr_sigpend = data.GetPointer(&offset);
  pr_sighold = data.GetPointer(&offset);

  pr_pid = data.GetU32(&offset);
  pr_ppid = data.GetU32(&offset);
  pr_pgrp = data.GetU32(&offset);
  pr_sid = data.GetU32(&offset);

  pr_utime.tv_sec = data.GetPointer(&offset);
  pr_utime.tv_usec = data.GetPointer(&offset);

  pr_stime.tv_sec = data.GetPointer(&offset);
  pr_stime.tv_usec = data.GetPointer(&offset);

  pr_cutime.tv_sec = data.GetPointer(&offset);
  pr_cutime.tv_usec = data.GetPointer(&offset);

  pr_cstime.tv_sec = data.GetPointer(&offset);
  pr_cstime.tv_usec = data.GetPointer(&offset);


  return error;
}

//----------------------------------------------------------------
// Parse PRPSINFO from NOTE entry
//----------------------------------------------------------------
ELFLinuxPrPsInfo::ELFLinuxPrPsInfo() {
  memset(this, 0, sizeof(ELFLinuxPrPsInfo));
}

Error ELFLinuxPrPsInfo::Parse(DataExtractor &data, ArchSpec &arch) {
  Error error;
  ByteOrder byteorder = data.GetByteOrder();
  if (GetSize(arch) > data.GetByteSize()) {
    error.SetErrorStringWithFormat(
        "NT_PRPSINFO size should be %zu, but the remaining bytes are: %" PRIu64,
        GetSize(arch), data.GetByteSize());
    return error;
  }
  size_t size = 0;
  offset_t offset = 0;

  pr_state = data.GetU8(&offset);
  pr_sname = data.GetU8(&offset);
  pr_zomb = data.GetU8(&offset);
  pr_nice = data.GetU8(&offset);
  if (data.GetAddressByteSize() == 8) {
    // Word align the next field on 64 bit.
    offset += 4;
  }

  pr_flag = data.GetPointer(&offset);

  // 16 bit on 32 bit platforms, 32 bit on 64 bit platforms
  pr_uid = data.GetMaxU64(&offset, data.GetAddressByteSize() >> 1);
  pr_gid = data.GetMaxU64(&offset, data.GetAddressByteSize() >> 1);

  pr_pid = data.GetU32(&offset);
  pr_ppid = data.GetU32(&offset);
  pr_pgrp = data.GetU32(&offset);
  pr_sid = data.GetU32(&offset);

  size = 16;
  data.ExtractBytes(offset, size, byteorder, pr_fname);
  offset += size;

  size = 80;
  data.ExtractBytes(offset, size, byteorder, pr_psargs);
  offset += size;

  return error;
}

//----------------------------------------------------------------
// Parse SIGINFO from NOTE entry
//----------------------------------------------------------------
ELFLinuxSigInfo::ELFLinuxSigInfo() {
  memset(this, 0, sizeof(ELFLinuxSigInfo));
}

Error ELFLinuxSigInfo::Parse(DataExtractor &data, const ArchSpec &arch) {
  Error error;
  if (GetSize(arch) > data.GetByteSize()) {
    error.SetErrorStringWithFormat(
        "NT_SIGINFO size should be %zu, but the remaining bytes are: %" PRIu64,
        GetSize(arch), data.GetByteSize());
    return error;
  }

  // Parsing from a 32 bit ELF core file, and populating/reusing the structure
  // properly, because the struct is for the 64 bit version
  offset_t offset = 0;
  si_signo = data.GetU32(&offset);
  si_code = data.GetU32(&offset);
  si_errno = data.GetU32(&offset);

  return error;
}
