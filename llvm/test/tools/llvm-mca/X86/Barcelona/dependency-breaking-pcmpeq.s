# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=x86-64 -timeline -timeline-max-iterations=3 -iterations=1500 < %s | FileCheck %s

# All of the vector packed compares from this test are dependency breaking
# instructions. That means, there is no RAW dependency between any of the
# instructions, and the code can be fully parallelized in hardware.

pcmpeqb %mm0, %mm0
pcmpeqd %mm0, %mm0
pcmpeqw %mm0, %mm0

pcmpeqb %xmm0, %xmm0
pcmpeqd %xmm0, %xmm0
pcmpeqq %xmm0, %xmm0
pcmpeqw %xmm0, %xmm0

# CHECK:      Iterations:        1500
# CHECK-NEXT: Instructions:      10500
# CHECK-NEXT: Total Cycles:      13503
# CHECK-NEXT: Total uOps:        10500

# CHECK:      Dispatch Width:    4
# CHECK-NEXT: uOps Per Cycle:    0.78
# CHECK-NEXT: IPC:               0.78
# CHECK-NEXT: Block RThroughput: 3.0

# CHECK:      Instruction Info:
# CHECK-NEXT: [1]: #uOps
# CHECK-NEXT: [2]: Latency
# CHECK-NEXT: [3]: RThroughput
# CHECK-NEXT: [4]: MayLoad
# CHECK-NEXT: [5]: MayStore
# CHECK-NEXT: [6]: HasSideEffects (U)

# CHECK:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# CHECK-NEXT:  1      3     1.00                        pcmpeqb	%mm0, %mm0
# CHECK-NEXT:  1      3     1.00                        pcmpeqd	%mm0, %mm0
# CHECK-NEXT:  1      3     1.00                        pcmpeqw	%mm0, %mm0
# CHECK-NEXT:  1      1     0.50                        pcmpeqb	%xmm0, %xmm0
# CHECK-NEXT:  1      1     0.50                        pcmpeqd	%xmm0, %xmm0
# CHECK-NEXT:  1      1     0.50                        pcmpeqq	%xmm0, %xmm0
# CHECK-NEXT:  1      1     0.50                        pcmpeqw	%xmm0, %xmm0

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
# CHECK-NEXT:  -      -      -     4.01    -     2.99    -      -

# CHECK:      Resource pressure by instruction:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6.0]  [6.1]  Instructions:
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     pcmpeqb	%mm0, %mm0
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     pcmpeqd	%mm0, %mm0
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     pcmpeqw	%mm0, %mm0
# CHECK-NEXT:  -      -      -     0.01    -     0.99    -      -     pcmpeqb	%xmm0, %xmm0
# CHECK-NEXT:  -      -      -     0.01    -     0.99    -      -     pcmpeqd	%xmm0, %xmm0
# CHECK-NEXT:  -      -      -     0.01    -     0.99    -      -     pcmpeqq	%xmm0, %xmm0
# CHECK-NEXT:  -      -      -     0.99    -     0.01    -      -     pcmpeqw	%xmm0, %xmm0

# CHECK:      Timeline view:
# CHECK-NEXT:                     0123456789
# CHECK-NEXT: Index     0123456789          0123456789

# CHECK:      [0,0]     DeeeER    .    .    .    .   .   pcmpeqb	%mm0, %mm0
# CHECK-NEXT: [0,1]     D===eeeER .    .    .    .   .   pcmpeqd	%mm0, %mm0
# CHECK-NEXT: [0,2]     D======eeeER   .    .    .   .   pcmpeqw	%mm0, %mm0
# CHECK-NEXT: [0,3]     DeE--------R   .    .    .   .   pcmpeqb	%xmm0, %xmm0
# CHECK-NEXT: [0,4]     .DeE-------R   .    .    .   .   pcmpeqd	%xmm0, %xmm0
# CHECK-NEXT: [0,5]     .D=eE------R   .    .    .   .   pcmpeqq	%xmm0, %xmm0
# CHECK-NEXT: [0,6]     .D==eE-----R   .    .    .   .   pcmpeqw	%xmm0, %xmm0
# CHECK-NEXT: [1,0]     .D========eeeER.    .    .   .   pcmpeqb	%mm0, %mm0
# CHECK-NEXT: [1,1]     . D==========eeeER  .    .   .   pcmpeqd	%mm0, %mm0
# CHECK-NEXT: [1,2]     . D=============eeeER    .   .   pcmpeqw	%mm0, %mm0
# CHECK-NEXT: [1,3]     . D==eE-------------R    .   .   pcmpeqb	%xmm0, %xmm0
# CHECK-NEXT: [1,4]     . D===eE------------R    .   .   pcmpeqd	%xmm0, %xmm0
# CHECK-NEXT: [1,5]     .  D===eE-----------R    .   .   pcmpeqq	%xmm0, %xmm0
# CHECK-NEXT: [1,6]     .  D====eE----------R    .   .   pcmpeqw	%xmm0, %xmm0
# CHECK-NEXT: [2,0]     .  D===============eeeER .   .   pcmpeqb	%mm0, %mm0
# CHECK-NEXT: [2,1]     .  D==================eeeER  .   pcmpeqd	%mm0, %mm0
# CHECK-NEXT: [2,2]     .   D====================eeeER   pcmpeqw	%mm0, %mm0
# CHECK-NEXT: [2,3]     .   D====eE------------------R   pcmpeqb	%xmm0, %xmm0
# CHECK-NEXT: [2,4]     .   D=====eE-----------------R   pcmpeqd	%xmm0, %xmm0
# CHECK-NEXT: [2,5]     .   D======eE----------------R   pcmpeqq	%xmm0, %xmm0
# CHECK-NEXT: [2,6]     .    D======eE---------------R   pcmpeqw	%xmm0, %xmm0

# CHECK:      Average Wait times (based on the timeline view):
# CHECK-NEXT: [0]: Executions
# CHECK-NEXT: [1]: Average time spent waiting in a scheduler's queue
# CHECK-NEXT: [2]: Average time spent waiting in a scheduler's queue while ready
# CHECK-NEXT: [3]: Average time elapsed from WB until retire stage

# CHECK:            [0]    [1]    [2]    [3]
# CHECK-NEXT: 0.     3     8.7    0.3    0.0       pcmpeqb	%mm0, %mm0
# CHECK-NEXT: 1.     3     11.3   0.0    0.0       pcmpeqd	%mm0, %mm0
# CHECK-NEXT: 2.     3     14.0   0.0    0.0       pcmpeqw	%mm0, %mm0
# CHECK-NEXT: 3.     3     3.0    0.3    13.0      pcmpeqb	%xmm0, %xmm0
# CHECK-NEXT: 4.     3     3.7    0.0    12.0      pcmpeqd	%xmm0, %xmm0
# CHECK-NEXT: 5.     3     4.3    0.0    11.0      pcmpeqq	%xmm0, %xmm0
# CHECK-NEXT: 6.     3     5.0    0.0    10.0      pcmpeqw	%xmm0, %xmm0
# CHECK-NEXT:        3     7.1    0.1    6.6       <total>
