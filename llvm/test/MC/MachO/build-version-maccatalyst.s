// RUN: llvm-mc -triple x86_64-apple-ios %s | FileCheck %s

.build_version maccatalyst,13,0
// CHECK: .build_version maccatalyst, 13, 0
