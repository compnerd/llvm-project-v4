// REQUIRES: shell
// REQUIRES: x86-registered-target

//--- If config file is specified by relative path (workdir/cfg-s2), it is searched for by that path.
//
// RUN: mkdir -p %T/workdir
// RUN: echo "@subdir/cfg-s2" > %T/workdir/cfg-1
// RUN: mkdir -p %T/workdir/subdir
// RUN: echo "-Wundefined-var-template" > %T/workdir/subdir/cfg-s2
//
// RUN: ( cd %T && %clang --config workdir/cfg-1 -c %s -### 2>&1 | FileCheck %s -check-prefix CHECK-REL )
//
// CHECK-REL: Configuration file: {{.*}}/workdir/cfg-1
// CHECK-REL: -Wundefined-var-template


//--- Invocation qqq-clang-g++ tries to find config file qqq-clang-g++.cfg first.
//
// RUN: mkdir -p %T/testdmode
// RUN: [ ! -s %T/testdmode/qqq-clang-g++ ] || rm %T/testdmode/qqq-clang-g++
// RUN: ln -s %clang %T/testdmode/qqq-clang-g++
// RUN: echo "-Wundefined-func-template" > %T/testdmode/qqq-clang-g++.cfg
// RUN: echo "-Werror" > %T/testdmode/qqq.cfg
// RUN: %T/testdmode/qqq-clang-g++ --config-system-dir= --config-user-dir= -c -no-canonical-prefixes %s -### 2>&1 | FileCheck %s -check-prefix FULL-NAME
//
// FULL-NAME: Configuration file: {{.*}}/testdmode/qqq-clang-g++.cfg
// FULL-NAME: -Wundefined-func-template
// FULL-NAME-NOT: -Werror
//
//--- File specified by --config overrides config inferred from clang executable.
//
// RUN: %T/testdmode/qqq-clang-g++ --config-system-dir=%S/Inputs/config --config-user-dir= --config i386-qqq -c -no-canonical-prefixes %s -### 2>&1 | FileCheck %s -check-prefix CHECK-EXPLICIT
//
// CHECK-EXPLICIT: Configuration file: {{.*}}/Inputs/config/i386-qqq.cfg
//
//--- Invocation qqq-clang-g++ tries to find config file qqq.cfg if qqq-clang-g++.cfg is not found.
//
// RUN: rm %T/testdmode/qqq-clang-g++.cfg
// RUN: %T/testdmode/qqq-clang-g++ --config-system-dir= --config-user-dir= -c -no-canonical-prefixes %s -### 2>&1 | FileCheck %s -check-prefix SHORT-NAME
//
// SHORT-NAME: Configuration file: {{.*}}/testdmode/qqq.cfg
// SHORT-NAME: -Werror
// SHORT-NAME-NOT: -Wundefined-func-template


//--- Config files are searched for in binary directory as well.
//
// RUN: mkdir -p %T/testbin
// RUN: [ ! -s %T/testbin/clang ] || rm %T/testbin/clang
// RUN: ln -s %clang %T/testbin/clang
// RUN: echo "-Werror" > %T/testbin/aaa.cfg
// RUN: %T/testbin/clang --config-system-dir= --config-user-dir= --config aaa.cfg -c -no-canonical-prefixes %s -### 2>&1 | FileCheck %s -check-prefix CHECK-BIN
//
// CHECK-BIN: Configuration file: {{.*}}/testbin/aaa.cfg
// CHECK-BIN: -Werror


//--- If command line contains options that change triple (for instance, -m32), clang tries
//    reloading config file.

//--- When reloading config file, x86_64-clang-g++ tries to find config i386-clang-g++.cfg first.
//
// RUN: mkdir -p %T/testreload
// RUN: [ ! -s %T/testreload/x86_64-clang-g++ ] || rm %T/testreload/x86_64-clang-g++
// RUN: ln -s %clang %T/testreload/x86_64-clang-g++
// RUN: echo "-Wundefined-func-template" > %T/testreload/i386-clang-g++.cfg
// RUN: echo "-Werror" > %T/testreload/i386.cfg
// RUN: %T/testreload/x86_64-clang-g++ --config-system-dir= --config-user-dir= -c -m32 -no-canonical-prefixes %s -### 2>&1 | FileCheck %s -check-prefix CHECK-RELOAD
//
// CHECK-RELOAD: Configuration file: {{.*}}/testreload/i386-clang-g++.cfg
// CHECK-RELOAD: -Wundefined-func-template
// CHECK-RELOAD-NOT: -Werror

//--- If config file is specified by --config and its name does not start with architecture, it is used without reloading.
//
// RUN: %T/testreload/x86_64-clang-g++ --config-system-dir=%S/Inputs --config-user-dir= --config config-3 -c -m32 -no-canonical-prefixes %s -### 2>&1 | FileCheck %s -check-prefix CHECK-RELOAD1a
//
// CHECK-RELOAD1a: Configuration file: {{.*}}/Inputs/config-3.cfg
//
// RUN: %T/testreload/x86_64-clang-g++ --config-system-dir=%S/Inputs --config-user-dir= --config config-3 -c -target i386 -no-canonical-prefixes %s -### 2>&1 | FileCheck %s -check-prefix CHECK-RELOAD1b
//
// CHECK-RELOAD1b: Configuration file: {{.*}}/Inputs/config-3.cfg

//--- If config file is specified by --config and its name starts with architecture, it is reloaded.
//
// RUN: %T/testreload/x86_64-clang-g++ --config-system-dir=%S/Inputs/config --config-user-dir= --config x86_64-qqq -c -m32 -no-canonical-prefixes %s -### 2>&1 | FileCheck %s -check-prefix CHECK-RELOAD1c
//
// CHECK-RELOAD1c: Configuration file: {{.*}}/Inputs/config/i386-qqq.cfg

//--- x86_64-clang-g++ tries to find config i386.cfg if i386-clang-g++.cfg is not found.
//
// RUN: rm %T/testreload/i386-clang-g++.cfg
// RUN: %T/testreload/x86_64-clang-g++ --config-system-dir= --config-user-dir= -c -m32 -no-canonical-prefixes %s -### 2>&1 | FileCheck %s -check-prefix CHECK-RELOAD1d
//
// CHECK-RELOAD1d: Configuration file: {{.*}}/testreload/i386.cfg
// CHECK-RELOAD1d: -Werror
// CHECK-RELOAD1d-NOT: -Wundefined-func-template

