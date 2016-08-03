// This is a host program for DLL tests.
//
// Just make sure we can compile this.
// The actual compile&run sequence is to be done by the DLL tests.
// RUN: %clang_cl_asan -O0 %s -Fe%t
//
// Get the list of ASan wrappers exported by the main module RTL:
// note: The mangling decoration (i.e. @4 )is removed because calling convention
//       differ from 32-bit and 64-bit.
// RUN: dumpbin /EXPORTS %t | grep -o "__asan_wrap[^ ]*" | sed -e s/@.*// > %t.exported_wrappers1
// FIXME: we should really check the other __asan exports too.
// RUN: dumpbin /EXPORTS %t | grep -o "__sanitizer_[^ ]*" | sed -e s/@.*// > %t.exported_wrappers2
//
// Get the list of ASan wrappers imported by the DLL RTL:
// [BEWARE: be really careful with the sed commands, as this test can be run
//  from different environemnts with different shells and seds]
// RUN: grep INTERCEPT_LIBRARY_FUNCTION %p/../../../../lib/asan/asan_win_dll_thunk.cc | grep -v define | sed -e s/.*(/__asan_wrap_/ | sed -e s/).*// > %t.dll_imports1
// RUN: grep "^INTERFACE_FUNCTION.*sanitizer" %p/../../../../lib/asan/asan_win_dll_thunk.cc | grep -v define | sed -e s/.*(// | sed -e s/).*// > %t.dll_imports2
//
// Add functions interecepted in asan_malloc.win.cc and asan_win.cc.
// RUN: grep '[I]MPORT:' %s | sed -e 's/.*[I]MPORT: //' > %t.dll_imports3
// IMPORT: __asan_wrap_HeapAlloc
// IMPORT: __asan_wrap_HeapFree
// IMPORT: __asan_wrap_HeapReAlloc
// IMPORT: __asan_wrap_HeapSize
// IMPORT: __asan_wrap_CreateThread
// IMPORT: __asan_wrap_RtlRaiseException
//
// The exception handlers differ in 32-bit and 64-bit, so we ignore them:
// RUN: grep '[E]XPORT:' %s | sed -e 's/.*[E]XPORT: //' > %t.exported_wrappers3
// EXPORT: __asan_wrap__except_handler3
// EXPORT: __asan_wrap__except_handler4
// EXPORT: __asan_wrap___C_specific_handler
//
// RUN: cat %t.dll_imports1 %t.dll_imports2 %t.dll_imports3 | sort | uniq > %t.dll_imports-sorted
// RUN: cat %t.exported_wrappers1 %t.exported_wrappers2 %t.exported_wrappers3 | sort | uniq > %t.exported_wrappers-sorted
//
// Now make sure the DLL thunk imports everything:
// RUN: echo
// RUN: echo "=== NOTE === If you see a mismatch below, please update asan_win_dll_thunk.cc"
// RUN: diff %t.dll_imports-sorted %t.exported_wrappers-sorted
// REQUIRES: asan-static-runtime

#include <stdio.h>
#include <windows.h>

int main(int argc, char **argv) {
  if (argc != 2) {
    printf("Usage: %s [client].dll\n", argv[0]);
    return 101;
  }

  const char *dll_name = argv[1];

  HMODULE h = LoadLibrary(dll_name);
  if (!h) {
    printf("Could not load DLL: %s (code: %lu)!\n",
           dll_name, GetLastError());
    return 102;
  }

  typedef int (*test_function)();
  test_function gf = (test_function)GetProcAddress(h, "test_function");
  if (!gf) {
    printf("Could not locate test_function in the DLL!\n");
    FreeLibrary(h);
    return 103;
  }

  int ret = gf();

  FreeLibrary(h);
  return ret;
}
