// RUN: llvm-mc -triple=aarch64 -show-encoding -mattr=+sve < %s \
// RUN:        | FileCheck %s --check-prefixes=CHECK-ENCODING,CHECK-INST
// RUN: not llvm-mc -triple=aarch64 -show-encoding < %s 2>&1 \
// RUN:        | FileCheck %s --check-prefix=CHECK-ERROR
// RUN: llvm-mc -triple=aarch64 -filetype=obj -mattr=+sve < %s \
// RUN:        | llvm-objdump -d -mattr=+sve - | FileCheck %s --check-prefix=CHECK-INST
// RUN: llvm-mc -triple=aarch64 -filetype=obj -mattr=+sve < %s \
// RUN:        | llvm-objdump -d - | FileCheck %s --check-prefix=CHECK-UNKNOWN

not     z31.b, p7/m, z31.b
// CHECK-INST: not	z31.b, p7/m, z31.b
// CHECK-ENCODING: [0xff,0xbf,0x1e,0x04]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: ff bf 1e 04 <unknown>

not     z31.h, p7/m, z31.h
// CHECK-INST: not	z31.h, p7/m, z31.h
// CHECK-ENCODING: [0xff,0xbf,0x5e,0x04]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: ff bf 5e 04 <unknown>

not     z31.s, p7/m, z31.s
// CHECK-INST: not	z31.s, p7/m, z31.s
// CHECK-ENCODING: [0xff,0xbf,0x9e,0x04]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: ff bf 9e 04 <unknown>

not     z31.d, p7/m, z31.d
// CHECK-INST: not	z31.d, p7/m, z31.d
// CHECK-ENCODING: [0xff,0xbf,0xde,0x04]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: ff bf de 04 <unknown>

not     p0.b, p0/z, p0.b
// CHECK-INST: not     p0.b, p0/z, p0.b
// CHECK-ENCODING: [0x00,0x42,0x00,0x25]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: 00 42 00 25 <unknown>

not     p15.b, p15/z, p15.b
// CHECK-INST: not     p15.b, p15/z, p15.b
// CHECK-ENCODING: [0xef,0x7f,0x0f,0x25]
// CHECK-ERROR: instruction requires: sve
// CHECK-UNKNOWN: ef 7f 0f 25 <unknown>
