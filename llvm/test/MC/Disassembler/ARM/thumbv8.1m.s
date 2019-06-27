# RUN: not llvm-mc -disassemble -triple=thumbv8.1m.main-none-eabi -show-encoding %s 2> %t | FileCheck %s
# RUN: FileCheck --check-prefix=ERROR < %t %s

[0x52 0xea 0x22 0x9e]
# CHECK: cinc lr, r2, lo  @ encoding: [0x52,0xea,0x22,0x9e]

[0x57 0xea 0x47 0x9e]
# CHECK: cinc lr, r7, pl  @ encoding: [0x57,0xea,0x47,0x9e]

[0x5c 0xea 0x3c 0xae]
# CHECK: cinv lr, r12, hs  @ encoding: [0x5c,0xea,0x3c,0xae]

[0x5a 0xea 0x3a 0xbe]
# CHECK: cneg lr, r10, hs  @ encoding: [0x5a,0xea,0x3a,0xbe]

[0x59 0xea 0x7b 0x89]
# CHECK: csel r9, r9, r11, vc  @ encoding: [0x59,0xea,0x7b,0x89]

[0x5f 0xea 0x1f 0x9e]
# CHECK: cset lr, eq  @ encoding: [0x5f,0xea,0x1f,0x9e]

[0x5f 0xea 0x3f 0xae]
# CHECK: csetm lr, hs  @ encoding: [0x5f,0xea,0x3f,0xae]

[0x5a 0xea 0xd7 0x9e]
# CHECK: csinc lr, r10, r7, le  @ encoding: [0x5a,0xea,0xd7,0x9e]

[0x55 0xea 0x2f 0xae]
# CHECK: csinv lr, r5, zr, hs  @ encoding: [0x55,0xea,0x2f,0xae]

[0x52 0xea 0x42 0xae]
# CHECK: cinv lr, r2, pl  @ encoding: [0x52,0xea,0x42,0xae]

[0x51 0xea 0x7b 0xbe]
# CHECK: csneg lr, r1, r11, vc  @ encoding: [0x51,0xea,0x7b,0xbe]

[0x50,0xea,0x01,0x80]
# CHECK: csel r0, r0, r1, eq @ encoding: [0x50,0xea,0x01,0x80]

[0x51,0xea,0x02,0x8d]
# CHECK: csel sp, r1, r2, eq @ encoding: [0x51,0xea,0x02,0x8d]
# ERROR: [[@LINE-2]]:2: warning: potentially undefined instruction encoding

[0x5d,0xea,0x02,0x80]
# CHECK: csel r0, sp, r2, eq @ encoding: [0x5d,0xea,0x02,0x80]
# ERROR: [[@LINE-2]]:2: warning: potentially undefined instruction encoding

[0x51,0xea,0x0d,0x80]
# ERROR: [[@LINE-1]]:2: warning: invalid instruction encoding

[0x5f,0xea,0x0d,0x83]
# ERROR: [[@LINE-1]]:2: warning: invalid instruction encoding

[0x5d 0xea 0x22 0x9e]
# ERROR: [[@LINE-1]]:2: warning: potentially undefined instruction encoding

[0x5d 0xea 0x47 0x9e]
# ERROR: [[@LINE-1]]:2: warning: potentially undefined instruction encoding

[0x5d 0xea 0x3c 0xae]
# ERROR: [[@LINE-1]]:2: warning: potentially undefined instruction encoding

[0x5d 0xea 0x3a 0xbe]
# ERROR: [[@LINE-1]]:2: warning: potentially undefined instruction encoding

[0x5d 0xea 0x7b 0x89]
# ERROR: [[@LINE-1]]:2: warning: potentially undefined instruction encoding

[0x5d 0xea 0x1f 0x9e]
# ERROR: [[@LINE-1]]:2: warning: potentially undefined instruction encoding

[0x5d 0xea 0x3f 0xae]
# ERROR: [[@LINE-1]]:2: warning: potentially undefined instruction encoding

[0x5d 0xea 0xd7 0x9e]
# ERROR: [[@LINE-1]]:2: warning: potentially undefined instruction encoding

[0x5d 0xea 0x2f 0xae]
# ERROR: [[@LINE-1]]:2: warning: potentially undefined instruction encoding

[0x5d 0xea 0x42 0xae]
# ERROR: [[@LINE-1]]:2: warning: potentially undefined instruction encoding

[0x5d 0xea 0x7b 0xbe]
# ERROR: [[@LINE-1]]:2: warning: potentially undefined instruction encoding

[0x52 0xea 0x22 0x9d]
# ERROR: [[@LINE-1]]:2: warning: potentially undefined instruction encoding

[0x57 0xea 0x47 0x9d]
# ERROR: [[@LINE-1]]:2: warning: potentially undefined instruction encoding

[0x5c 0xea 0x3c 0xad]
# ERROR: [[@LINE-1]]:2: warning: potentially undefined instruction encoding

[0x5a 0xea 0x3a 0xbd]
# ERROR: [[@LINE-1]]:2: warning: potentially undefined instruction encoding

[0x59 0xea 0x7b 0x8d]
# ERROR: [[@LINE-1]]:2: warning: potentially undefined instruction encoding

[0x5f 0xea 0x1f 0x9d]
# ERROR: [[@LINE-1]]:2: warning: potentially undefined instruction encoding

[0x5f 0xea 0x3f 0xad]
# ERROR: [[@LINE-1]]:2: warning: potentially undefined instruction encoding

[0x5a 0xea 0xd7 0x9d]
# ERROR: [[@LINE-1]]:2: warning: potentially undefined instruction encoding

[0x55 0xea 0x2f 0xad]
# ERROR: [[@LINE-1]]:2: warning: potentially undefined instruction encoding

[0x52 0xea 0x42 0xad]
# ERROR: [[@LINE-1]]:2: warning: potentially undefined instruction encoding

[0x51 0xea 0x7b 0xbd]
# ERROR: [[@LINE-1]]:2: warning: potentially undefined instruction encoding
