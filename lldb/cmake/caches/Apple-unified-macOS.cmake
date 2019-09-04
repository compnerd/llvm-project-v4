set(CMAKE_GENERATOR Ninja CACHE STRING "")
set(CMAKE_BUILD_TYPE RelWithDebInfo CACHE STRING "")

set(CMAKE_OSX_DEPLOYMENT_TARGET 10.11 CACHE STRING "")

set(LLVM_ENABLE_PROJECTS "clang;compiler-rt;libcxx;lldb;cmark;swift" CACHE STRING "")
set(LLVM_EXTERNAL_PROJECTS "cmark;swift" CACHE STRING "")
set(LLVM_TARGETS_TO_BUILD "X86;ARM;AArch64" CACHE STRING "")
set(LLVM_ENABLE_ASSERTIONS ON CACHE BOOL "")
set(LLVM_ENABLE_MODULES OFF CACHE BOOL "")

set(SWIFT_SDKS OSX CACHE STRING "") # IOS;IOS_SIMULATOR;OSX;TVOS;TVOS_SIMULATOR;WATCHOS;WATCHOS_SIMULATOR
set(SWIFT_BUILD_RUNTIME_WITH_HOST_COMPILER ON CACHE BOOL "")

set(LLDB_BUILD_FRAMEWORK ON CACHE BOOL "")
