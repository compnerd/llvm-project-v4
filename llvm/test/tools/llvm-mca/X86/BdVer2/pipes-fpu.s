# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=bdver2 -timeline -timeline-max-iterations=2 < %s | FileCheck %s

# VALU0/VALU1
vpmulld     %xmm0, %xmm1, %xmm2
vpand       %xmm0, %xmm1, %xmm2

# VIMUL/STC
vcvttps2dq  %xmm0, %xmm2
vpclmulqdq  $0, %xmm0, %xmm1, %xmm2

# FPA/FPM
vaddps      %xmm0, %xmm1, %xmm2
vsqrtps     %xmm0, %xmm2

# FPA/FPM YMM
vaddps      %ymm0, %ymm1, %ymm2
vsqrtps     %ymm0, %ymm2

# CHECK:      Iterations:        100
# CHECK-NEXT: Instructions:      800
# CHECK-NEXT: Total Cycles:      1503
# CHECK-NEXT: Total uOps:        1500

# CHECK:      Dispatch Width:    4
# CHECK-NEXT: uOps Per Cycle:    1.00
# CHECK-NEXT: IPC:               0.53
# CHECK-NEXT: Block RThroughput: 15.0

# CHECK:      Instruction Info:
# CHECK-NEXT: [1]: #uOps
# CHECK-NEXT: [2]: Latency
# CHECK-NEXT: [3]: RThroughput
# CHECK-NEXT: [4]: MayLoad
# CHECK-NEXT: [5]: MayStore
# CHECK-NEXT: [6]: HasSideEffects (U)

# CHECK:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# CHECK-NEXT:  1      5     2.00                        vpmulld	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  1      2     1.00                        vpand	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  1      4     1.00                        vcvttps2dq	%xmm0, %xmm2
# CHECK-NEXT:  6      12    7.00                        vpclmulqdq	$0, %xmm0, %xmm1, %xmm2
# CHECK-NEXT:  1      5     1.00                        vaddps	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  1      9     4.50                        vsqrtps	%xmm0, %xmm2
# CHECK-NEXT:  2      5     1.00                        vaddps	%ymm0, %ymm1, %ymm2
# CHECK-NEXT:  2      9     9.00                        vsqrtps	%ymm0, %ymm2

# CHECK:      Resources:
# CHECK-NEXT: [0.0] - PdAGLU01
# CHECK-NEXT: [0.1] - PdAGLU01
# CHECK-NEXT: [1]   - PdBranch
# CHECK-NEXT: [2]   - PdCount
# CHECK-NEXT: [3]   - PdDiv
# CHECK-NEXT: [4]   - PdEX0
# CHECK-NEXT: [5]   - PdEX1
# CHECK-NEXT: [6]   - PdFPCVT
# CHECK-NEXT: [7.0] - PdFPFMA
# CHECK-NEXT: [7.1] - PdFPFMA
# CHECK-NEXT: [8.0] - PdFPMAL
# CHECK-NEXT: [8.1] - PdFPMAL
# CHECK-NEXT: [9]   - PdFPMMA
# CHECK-NEXT: [10]  - PdFPSTO
# CHECK-NEXT: [11]  - PdFPU0
# CHECK-NEXT: [12]  - PdFPU1
# CHECK-NEXT: [13]  - PdFPU2
# CHECK-NEXT: [14]  - PdFPU3
# CHECK-NEXT: [15]  - PdFPXBR
# CHECK-NEXT: [16.0] - PdLoad
# CHECK-NEXT: [16.1] - PdLoad
# CHECK-NEXT: [17]  - PdMul
# CHECK-NEXT: [18]  - PdStore

# CHECK:      Resource pressure per iteration:
# CHECK-NEXT: [0.0]  [0.1]  [1]    [2]    [3]    [4]    [5]    [6]    [7.0]  [7.1]  [8.0]  [8.1]  [9]    [10]   [11]   [12]   [13]   [14]   [15]   [16.0] [16.1] [17]   [18]
# CHECK-NEXT:  -      -      -      -      -      -      -     1.00   15.06  14.94  1.12   1.88   9.00   1.00   6.44   4.56    -      -      -      -      -      -      -

# CHECK:      Resource pressure by instruction:
# CHECK-NEXT: [0.0]  [0.1]  [1]    [2]    [3]    [4]    [5]    [6]    [7.0]  [7.1]  [8.0]  [8.1]  [9]    [10]   [11]   [12]   [13]   [14]   [15]   [16.0] [16.1] [17]   [18]   Instructions:
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -     0.88   0.12   2.00    -     2.00   1.00    -      -      -      -      -      -      -     vpmulld	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -     0.24   1.76    -      -     0.44   0.56    -      -      -      -      -      -      -     vpand	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -     1.00    -      -      -      -      -     1.00   1.00    -      -      -      -      -      -      -      -     vcvttps2dq	%xmm0, %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -     7.00    -     1.00    -      -      -      -      -      -      -      -     vpclmulqdq	$0, %xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     0.52   0.48    -      -      -      -     1.00    -      -      -      -      -      -      -      -     vaddps	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     4.50   4.50    -      -      -      -      -     1.00    -      -      -      -      -      -      -     vsqrtps	%xmm0, %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     1.04   0.96    -      -      -      -     1.00    -      -      -      -      -      -      -      -     vaddps	%ymm0, %ymm1, %ymm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -     9.00   9.00    -      -      -      -      -     2.00    -      -      -      -      -      -      -     vsqrtps	%ymm0, %ymm2

# CHECK:      Timeline view:
# CHECK-NEXT:                     0123456789          012
# CHECK-NEXT: Index     0123456789          0123456789

# CHECK:      [0,0]     DeeeeeER  .    .    .    .    . .   vpmulld	%xmm0, %xmm1, %xmm2
# CHECK-NEXT: [0,1]     D=eeE--R  .    .    .    .    . .   vpand	%xmm0, %xmm1, %xmm2
# CHECK-NEXT: [0,2]     D==eeeeER .    .    .    .    . .   vcvttps2dq	%xmm0, %xmm2
# CHECK-NEXT: [0,3]     .D==eeeeeeeeeeeeER  .    .    . .   vpclmulqdq	$0, %xmm0, %xmm1, %xmm2
# CHECK-NEXT: [0,4]     . D===================eeeeeER . .   vaddps	%xmm0, %xmm1, %xmm2
# CHECK-NEXT: [0,5]     . DeeeeeeeeeE---------------R . .   vsqrtps	%xmm0, %xmm2
# CHECK-NEXT: [0,6]     .  D===================eeeeeER. .   vaddps	%ymm0, %ymm1, %ymm2
# CHECK-NEXT: [0,7]     .  DeeeeeeeeeE---------------R. .   vsqrtps	%ymm0, %ymm2
# CHECK-NEXT: [1,0]     .   D======eeeeeE------------R. .   vpmulld	%xmm0, %xmm1, %xmm2
# CHECK-NEXT: [1,1]     .   DeeE---------------------R. .   vpand	%xmm0, %xmm1, %xmm2
# CHECK-NEXT: [1,2]     .   D=eeeeE-------------------R .   vcvttps2dq	%xmm0, %xmm2
# CHECK-NEXT: [1,3]     .    D=======eeeeeeeeeeeeE----R .   vpclmulqdq	$0, %xmm0, %xmm1, %xmm2
# CHECK-NEXT: [1,4]     .    .D==================eeeeeER.   vaddps	%xmm0, %xmm1, %xmm2
# CHECK-NEXT: [1,5]     .    .D=====eeeeeeeeeE---------R.   vsqrtps	%xmm0, %xmm2
# CHECK-NEXT: [1,6]     .    . D==================eeeeeER   vaddps	%ymm0, %ymm1, %ymm2
# CHECK-NEXT: [1,7]     .    . D=============eeeeeeeeeE-R   vsqrtps	%ymm0, %ymm2

# CHECK:      Average Wait times (based on the timeline view):
# CHECK-NEXT: [0]: Executions
# CHECK-NEXT: [1]: Average time spent waiting in a scheduler's queue
# CHECK-NEXT: [2]: Average time spent waiting in a scheduler's queue while ready
# CHECK-NEXT: [3]: Average time elapsed from WB until retire stage

# CHECK:            [0]    [1]    [2]    [3]
# CHECK-NEXT: 0.     2     4.0    4.0    6.0       vpmulld	%xmm0, %xmm1, %xmm2
# CHECK-NEXT: 1.     2     1.5    1.5    11.5      vpand	%xmm0, %xmm1, %xmm2
# CHECK-NEXT: 2.     2     2.5    2.5    9.5       vcvttps2dq	%xmm0, %xmm2
# CHECK-NEXT: 3.     2     5.5    5.5    2.0       vpclmulqdq	$0, %xmm0, %xmm1, %xmm2
# CHECK-NEXT: 4.     2     19.5   19.5   0.0       vaddps	%xmm0, %xmm1, %xmm2
# CHECK-NEXT: 5.     2     3.5    3.5    12.0      vsqrtps	%xmm0, %xmm2
# CHECK-NEXT: 6.     2     19.5   19.5   0.0       vaddps	%ymm0, %ymm1, %ymm2
# CHECK-NEXT: 7.     2     7.5    7.5    8.0       vsqrtps	%ymm0, %ymm2
# CHECK-NEXT:        2     7.9    7.9    6.1       <total>
