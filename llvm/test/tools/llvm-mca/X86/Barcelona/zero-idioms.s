# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=x86-64 -timeline -register-file-stats -iterations=1 < %s | FileCheck %s

subl  %eax, %eax
subq  %rax, %rax
xorl  %eax, %eax
xorq  %rax, %rax

pcmpgtb   %mm2, %mm2
pcmpgtd   %mm2, %mm2
# pcmpgtq   %mm2, %mm2 # invalid operand for instruction
pcmpgtw   %mm2, %mm2

pcmpgtb   %xmm2, %xmm2
pcmpgtd   %xmm2, %xmm2
pcmpgtq   %xmm2, %xmm2
pcmpgtw   %xmm2, %xmm2

psubb   %mm2, %mm2
psubd   %mm2, %mm2
psubq   %mm2, %mm2
psubw   %mm2, %mm2
psubb   %xmm2, %xmm2
psubd   %xmm2, %xmm2
psubq   %xmm2, %xmm2
psubw   %xmm2, %xmm2

psubsb   %mm2, %mm2
psubsw   %mm2, %mm2
psubsb   %xmm2, %xmm2
psubsw   %xmm2, %xmm2

psubusb   %mm2, %mm2
psubusw   %mm2, %mm2
psubusb   %xmm2, %xmm2
psubusw   %xmm2, %xmm2

andnps  %xmm0, %xmm0
andnpd  %xmm1, %xmm1

pandn   %mm2, %mm2
pandn   %xmm2, %xmm2

xorps  %xmm0, %xmm0
xorpd  %xmm1, %xmm1

pxor   %mm2, %mm2
pxor   %xmm2, %xmm2

# CHECK:      Iterations:        1
# CHECK-NEXT: Instructions:      35
# CHECK-NEXT: Total Cycles:      39
# CHECK-NEXT: Total uOps:        35

# CHECK:      Dispatch Width:    4
# CHECK-NEXT: uOps Per Cycle:    0.90
# CHECK-NEXT: IPC:               0.90
# CHECK-NEXT: Block RThroughput: 11.0

# CHECK:      Instruction Info:
# CHECK-NEXT: [1]: #uOps
# CHECK-NEXT: [2]: Latency
# CHECK-NEXT: [3]: RThroughput
# CHECK-NEXT: [4]: MayLoad
# CHECK-NEXT: [5]: MayStore
# CHECK-NEXT: [6]: HasSideEffects (U)

# CHECK:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# CHECK-NEXT:  1      0     0.25                        subl	%eax, %eax
# CHECK-NEXT:  1      0     0.25                        subq	%rax, %rax
# CHECK-NEXT:  1      0     0.25                        xorl	%eax, %eax
# CHECK-NEXT:  1      0     0.25                        xorq	%rax, %rax
# CHECK-NEXT:  1      3     1.00                        pcmpgtb	%mm2, %mm2
# CHECK-NEXT:  1      3     1.00                        pcmpgtd	%mm2, %mm2
# CHECK-NEXT:  1      3     1.00                        pcmpgtw	%mm2, %mm2
# CHECK-NEXT:  1      0     0.25                        pcmpgtb	%xmm2, %xmm2
# CHECK-NEXT:  1      0     0.25                        pcmpgtd	%xmm2, %xmm2
# CHECK-NEXT:  1      0     0.25                        pcmpgtq	%xmm2, %xmm2
# CHECK-NEXT:  1      0     0.25                        pcmpgtw	%xmm2, %xmm2
# CHECK-NEXT:  1      3     1.00                        psubb	%mm2, %mm2
# CHECK-NEXT:  1      3     1.00                        psubd	%mm2, %mm2
# CHECK-NEXT:  1      3     1.00                        psubq	%mm2, %mm2
# CHECK-NEXT:  1      3     1.00                        psubw	%mm2, %mm2
# CHECK-NEXT:  1      0     0.25                        psubb	%xmm2, %xmm2
# CHECK-NEXT:  1      0     0.25                        psubd	%xmm2, %xmm2
# CHECK-NEXT:  1      0     0.25                        psubq	%xmm2, %xmm2
# CHECK-NEXT:  1      0     0.25                        psubw	%xmm2, %xmm2
# CHECK-NEXT:  1      3     1.00                        psubsb	%mm2, %mm2
# CHECK-NEXT:  1      3     1.00                        psubsw	%mm2, %mm2
# CHECK-NEXT:  1      1     0.50                        psubsb	%xmm2, %xmm2
# CHECK-NEXT:  1      1     0.50                        psubsw	%xmm2, %xmm2
# CHECK-NEXT:  1      3     1.00                        psubusb	%mm2, %mm2
# CHECK-NEXT:  1      3     1.00                        psubusw	%mm2, %mm2
# CHECK-NEXT:  1      1     0.50                        psubusb	%xmm2, %xmm2
# CHECK-NEXT:  1      1     0.50                        psubusw	%xmm2, %xmm2
# CHECK-NEXT:  1      1     1.00                        andnps	%xmm0, %xmm0
# CHECK-NEXT:  1      1     1.00                        andnpd	%xmm1, %xmm1
# CHECK-NEXT:  1      1     0.33                        pandn	%mm2, %mm2
# CHECK-NEXT:  1      1     0.33                        pandn	%xmm2, %xmm2
# CHECK-NEXT:  1      0     0.25                        xorps	%xmm0, %xmm0
# CHECK-NEXT:  1      0     0.25                        xorpd	%xmm1, %xmm1
# CHECK-NEXT:  1      1     0.33                        pxor	%mm2, %mm2
# CHECK-NEXT:  1      0     0.25                        pxor	%xmm2, %xmm2

# CHECK:      Register File statistics:
# CHECK-NEXT: Total number of mappings created:    39
# CHECK-NEXT: Max number of mappings used:         30

# CHECK:      Resources:
# CHECK-NEXT: [0]   - SBDivider
# CHECK-NEXT: [1]   - SBFPDivider
# CHECK-NEXT: [2]   - SBPort0
# CHECK-NEXT: [3]   - SBPort1
# CHECK-NEXT: [4]   - SBPort4
# CHECK-NEXT: [5]   - SBPort5
# CHECK-NEXT: [6.0] - SBPort23
# CHECK-NEXT: [6.1] - SBPort23

# CHECK:      Resource pressure per iteration:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6.0]  [6.1]
# CHECK-NEXT:  -      -     2.00   12.00   -     6.00    -      -

# CHECK:      Resource pressure by instruction:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6.0]  [6.1]  Instructions:
# CHECK-NEXT:  -      -      -      -      -      -      -      -     subl	%eax, %eax
# CHECK-NEXT:  -      -      -      -      -      -      -      -     subq	%rax, %rax
# CHECK-NEXT:  -      -      -      -      -      -      -      -     xorl	%eax, %eax
# CHECK-NEXT:  -      -      -      -      -      -      -      -     xorq	%rax, %rax
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     pcmpgtb	%mm2, %mm2
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     pcmpgtd	%mm2, %mm2
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     pcmpgtw	%mm2, %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     pcmpgtb	%xmm2, %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     pcmpgtd	%xmm2, %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     pcmpgtq	%xmm2, %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     pcmpgtw	%xmm2, %xmm2
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     psubb	%mm2, %mm2
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     psubd	%mm2, %mm2
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     psubq	%mm2, %mm2
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     psubw	%mm2, %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     psubb	%xmm2, %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     psubd	%xmm2, %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     psubq	%xmm2, %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     psubw	%xmm2, %xmm2
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     psubsb	%mm2, %mm2
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     psubsw	%mm2, %mm2
# CHECK-NEXT:  -      -      -      -      -     1.00    -      -     psubsb	%xmm2, %xmm2
# CHECK-NEXT:  -      -      -      -      -     1.00    -      -     psubsw	%xmm2, %xmm2
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     psubusb	%mm2, %mm2
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     psubusw	%mm2, %mm2
# CHECK-NEXT:  -      -      -      -      -     1.00    -      -     psubusb	%xmm2, %xmm2
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     psubusw	%xmm2, %xmm2
# CHECK-NEXT:  -      -      -      -      -     1.00    -      -     andnps	%xmm0, %xmm0
# CHECK-NEXT:  -      -      -      -      -     1.00    -      -     andnpd	%xmm1, %xmm1
# CHECK-NEXT:  -      -     1.00    -      -      -      -      -     pandn	%mm2, %mm2
# CHECK-NEXT:  -      -     1.00    -      -      -      -      -     pandn	%xmm2, %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     xorps	%xmm0, %xmm0
# CHECK-NEXT:  -      -      -      -      -      -      -      -     xorpd	%xmm1, %xmm1
# CHECK-NEXT:  -      -      -      -      -     1.00    -      -     pxor	%mm2, %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     pxor	%xmm2, %xmm2

# CHECK:      Timeline view:
# CHECK-NEXT:                     0123456789          012345678
# CHECK-NEXT: Index     0123456789          0123456789

# CHECK:      [0,0]     DR   .    .    .    .    .    .    .  .   subl	%eax, %eax
# CHECK-NEXT: [0,1]     DR   .    .    .    .    .    .    .  .   subq	%rax, %rax
# CHECK-NEXT: [0,2]     DR   .    .    .    .    .    .    .  .   xorl	%eax, %eax
# CHECK-NEXT: [0,3]     DR   .    .    .    .    .    .    .  .   xorq	%rax, %rax
# CHECK-NEXT: [0,4]     .DeeeER   .    .    .    .    .    .  .   pcmpgtb	%mm2, %mm2
# CHECK-NEXT: [0,5]     .D===eeeER.    .    .    .    .    .  .   pcmpgtd	%mm2, %mm2
# CHECK-NEXT: [0,6]     .D======eeeER  .    .    .    .    .  .   pcmpgtw	%mm2, %mm2
# CHECK-NEXT: [0,7]     .D----------R  .    .    .    .    .  .   pcmpgtb	%xmm2, %xmm2
# CHECK-NEXT: [0,8]     . D---------R  .    .    .    .    .  .   pcmpgtd	%xmm2, %xmm2
# CHECK-NEXT: [0,9]     . D---------R  .    .    .    .    .  .   pcmpgtq	%xmm2, %xmm2
# CHECK-NEXT: [0,10]    . D---------R  .    .    .    .    .  .   pcmpgtw	%xmm2, %xmm2
# CHECK-NEXT: [0,11]    . D========eeeER    .    .    .    .  .   psubb	%mm2, %mm2
# CHECK-NEXT: [0,12]    .  D==========eeeER .    .    .    .  .   psubd	%mm2, %mm2
# CHECK-NEXT: [0,13]    .  D=============eeeER   .    .    .  .   psubq	%mm2, %mm2
# CHECK-NEXT: [0,14]    .  D================eeeER.    .    .  .   psubw	%mm2, %mm2
# CHECK-NEXT: [0,15]    .  D--------------------R.    .    .  .   psubb	%xmm2, %xmm2
# CHECK-NEXT: [0,16]    .   D-------------------R.    .    .  .   psubd	%xmm2, %xmm2
# CHECK-NEXT: [0,17]    .   D-------------------R.    .    .  .   psubq	%xmm2, %xmm2
# CHECK-NEXT: [0,18]    .   D-------------------R.    .    .  .   psubw	%xmm2, %xmm2
# CHECK-NEXT: [0,19]    .   D==================eeeER  .    .  .   psubsb	%mm2, %mm2
# CHECK-NEXT: [0,20]    .    D====================eeeER    .  .   psubsw	%mm2, %mm2
# CHECK-NEXT: [0,21]    .    DeE----------------------R    .  .   psubsb	%xmm2, %xmm2
# CHECK-NEXT: [0,22]    .    D=eE---------------------R    .  .   psubsw	%xmm2, %xmm2
# CHECK-NEXT: [0,23]    .    D=======================eeeER .  .   psubusb	%mm2, %mm2
# CHECK-NEXT: [0,24]    .    .D=========================eeeER .   psubusw	%mm2, %mm2
# CHECK-NEXT: [0,25]    .    .D=eE--------------------------R .   psubusb	%xmm2, %xmm2
# CHECK-NEXT: [0,26]    .    .D==eE-------------------------R .   psubusw	%xmm2, %xmm2
# CHECK-NEXT: [0,27]    .    .D==eE-------------------------R .   andnps	%xmm0, %xmm0
# CHECK-NEXT: [0,28]    .    . D==eE------------------------R .   andnpd	%xmm1, %xmm1
# CHECK-NEXT: [0,29]    .    . D===========================eER.   pandn	%mm2, %mm2
# CHECK-NEXT: [0,30]    .    . D==eE-------------------------R.   pandn	%xmm2, %xmm2
# CHECK-NEXT: [0,31]    .    . D==E--------------------------R.   xorps	%xmm0, %xmm0
# CHECK-NEXT: [0,32]    .    .  D==E-------------------------R.   xorpd	%xmm1, %xmm1
# CHECK-NEXT: [0,33]    .    .  D===========================eER   pxor	%mm2, %mm2
# CHECK-NEXT: [0,34]    .    .  D==E--------------------------R   pxor	%xmm2, %xmm2

# CHECK:      Average Wait times (based on the timeline view):
# CHECK-NEXT: [0]: Executions
# CHECK-NEXT: [1]: Average time spent waiting in a scheduler's queue
# CHECK-NEXT: [2]: Average time spent waiting in a scheduler's queue while ready
# CHECK-NEXT: [3]: Average time elapsed from WB until retire stage

# CHECK:            [0]    [1]    [2]    [3]
# CHECK-NEXT: 0.     1     0.0    0.0    0.0       subl	%eax, %eax
# CHECK-NEXT: 1.     1     0.0    0.0    0.0       subq	%rax, %rax
# CHECK-NEXT: 2.     1     0.0    0.0    0.0       xorl	%eax, %eax
# CHECK-NEXT: 3.     1     0.0    0.0    0.0       xorq	%rax, %rax
# CHECK-NEXT: 4.     1     1.0    1.0    0.0       pcmpgtb	%mm2, %mm2
# CHECK-NEXT: 5.     1     4.0    0.0    0.0       pcmpgtd	%mm2, %mm2
# CHECK-NEXT: 6.     1     7.0    0.0    0.0       pcmpgtw	%mm2, %mm2
# CHECK-NEXT: 7.     1     0.0    0.0    10.0      pcmpgtb	%xmm2, %xmm2
# CHECK-NEXT: 8.     1     0.0    0.0    9.0       pcmpgtd	%xmm2, %xmm2
# CHECK-NEXT: 9.     1     0.0    0.0    9.0       pcmpgtq	%xmm2, %xmm2
# CHECK-NEXT: 10.    1     0.0    0.0    9.0       pcmpgtw	%xmm2, %xmm2
# CHECK-NEXT: 11.    1     9.0    0.0    0.0       psubb	%mm2, %mm2
# CHECK-NEXT: 12.    1     11.0   0.0    0.0       psubd	%mm2, %mm2
# CHECK-NEXT: 13.    1     14.0   0.0    0.0       psubq	%mm2, %mm2
# CHECK-NEXT: 14.    1     17.0   0.0    0.0       psubw	%mm2, %mm2
# CHECK-NEXT: 15.    1     0.0    0.0    20.0      psubb	%xmm2, %xmm2
# CHECK-NEXT: 16.    1     0.0    0.0    19.0      psubd	%xmm2, %xmm2
# CHECK-NEXT: 17.    1     0.0    0.0    19.0      psubq	%xmm2, %xmm2
# CHECK-NEXT: 18.    1     0.0    0.0    19.0      psubw	%xmm2, %xmm2
# CHECK-NEXT: 19.    1     19.0   0.0    0.0       psubsb	%mm2, %mm2
# CHECK-NEXT: 20.    1     21.0   0.0    0.0       psubsw	%mm2, %mm2
# CHECK-NEXT: 21.    1     1.0    1.0    22.0      psubsb	%xmm2, %xmm2
# CHECK-NEXT: 22.    1     2.0    0.0    21.0      psubsw	%xmm2, %xmm2
# CHECK-NEXT: 23.    1     24.0   0.0    0.0       psubusb	%mm2, %mm2
# CHECK-NEXT: 24.    1     26.0   0.0    0.0       psubusw	%mm2, %mm2
# CHECK-NEXT: 25.    1     2.0    0.0    26.0      psubusb	%xmm2, %xmm2
# CHECK-NEXT: 26.    1     3.0    0.0    25.0      psubusw	%xmm2, %xmm2
# CHECK-NEXT: 27.    1     3.0    3.0    25.0      andnps	%xmm0, %xmm0
# CHECK-NEXT: 28.    1     3.0    3.0    24.0      andnpd	%xmm1, %xmm1
# CHECK-NEXT: 29.    1     28.0   0.0    0.0       pandn	%mm2, %mm2
# CHECK-NEXT: 30.    1     3.0    0.0    25.0      pandn	%xmm2, %xmm2
# CHECK-NEXT: 31.    1     3.0    0.0    26.0      xorps	%xmm0, %xmm0
# CHECK-NEXT: 32.    1     3.0    0.0    25.0      xorpd	%xmm1, %xmm1
# CHECK-NEXT: 33.    1     28.0   0.0    0.0       pxor	%mm2, %mm2
# CHECK-NEXT: 34.    1     3.0    0.0    26.0      pxor	%xmm2, %xmm2
# CHECK-NEXT:        1     6.7    0.2    10.3      <total>
