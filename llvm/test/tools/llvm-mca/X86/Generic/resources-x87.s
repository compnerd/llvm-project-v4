# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=x86-64 -instruction-tables < %s | FileCheck %s

f2xm1

fabs

fadd %st(0), %st(1)
fadd %st(2)
fadds (%ecx)
faddl (%ecx)
faddp %st(1)
faddp %st(2)
fiadds (%ecx)
fiaddl (%ecx)

fbld (%ecx)
fbstp (%eax)

fchs

fnclex

fcmovb %st(1), %st(0)
fcmovbe %st(1), %st(0)
fcmove %st(1), %st(0)
fcmovnb %st(1), %st(0)
fcmovnbe %st(1), %st(0)
fcmovne %st(1), %st(0)
fcmovnu %st(1), %st(0)
fcmovu %st(1), %st(0)

fcom %st(1)
fcom %st(3)
fcoms (%ecx)
fcoml (%eax)
fcomp %st(1)
fcomp %st(3)
fcomps (%ecx)
fcompl (%eax)
fcompp

fcomi %st(3)
fcompi %st(3)

fcos

fdecstp

fdiv %st(0), %st(1)
fdiv %st(2)
fdivs (%ecx)
fdivl (%eax)
fdivp %st(1)
fdivp %st(2)
fidivs (%ecx)
fidivl (%eax)

fdivr %st(0), %st(1)
fdivr %st(2)
fdivrs (%ecx)
fdivrl (%eax)
fdivrp %st(1)
fdivrp %st(2)
fidivrs (%ecx)
fidivrl (%eax)

ffree %st(0)

ficoms (%ecx)
ficoml (%eax)
ficomps (%ecx)
ficompl (%eax)

filds (%edx)
fildl (%ecx)
fildll (%eax)

fincstp

fninit

fists (%edx)
fistl (%ecx)
fistps (%edx)
fistpl (%ecx)
fistpll (%eax)

fisttps (%edx)
fisttpl (%ecx)
fisttpll (%eax)

fld %st(0)
flds (%edx)
fldl (%ecx)
fldt (%eax)

fldcw (%eax)
fldenv (%eax)

fld1
fldl2e
fldl2t
fldlg2
fldln2
fldpi
fldz

fmul %st(0), %st(1)
fmul %st(2)
fmuls (%ecx)
fmull (%eax)
fmulp %st(1)
fmulp %st(2)
fimuls (%ecx)
fimull (%eax)

fnop

fpatan

fprem
fprem1

fptan

frndint

frstor (%eax)

fnsave (%eax)

fscale

fsin

fsincos

fsqrt

fst %st(0)
fsts (%edx)
fstl (%ecx)
fstp %st(0)
fstpl (%edx)
fstpl (%ecx)
fstpt (%eax)

fnstcw (%eax)
fnstenv (%eax)
fnstsw (%eax)

frstor (%eax)
fsave (%eax)

fsub %st(0), %st(1)
fsub %st(2)
fsubs (%ecx)
fsubl (%eax)
fsubp %st(1)
fsubp %st(2)
fisubs (%ecx)
fisubl (%eax)

fsubr %st(0), %st(1)
fsubr %st(2)
fsubrs (%ecx)
fsubrl (%eax)
fsubrp %st(1)
fsubrp %st(2)
fisubrs (%ecx)
fisubrl (%eax)

ftst

fucom %st(1)
fucom %st(3)
fucomp %st(1)
fucomp %st(3)
fucompp

fucomi %st(3)
fucompi %st(3)

fwait

fxam

fxch %st(1)
fxch %st(3)

fxrstor (%eax)
fxsave (%eax)

fxtract

fyl2x
fyl2xp1

# CHECK:      Instruction Info:
# CHECK-NEXT: [1]: #uOps
# CHECK-NEXT: [2]: Latency
# CHECK-NEXT: [3]: RThroughput
# CHECK-NEXT: [4]: MayLoad
# CHECK-NEXT: [5]: MayStore
# CHECK-NEXT: [6]: HasSideEffects (U)

# CHECK:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# CHECK-NEXT:  1      100   0.33                  U     f2xm1
# CHECK-NEXT:  1      1     1.00                  U     fabs
# CHECK-NEXT:  1      3     1.00                  U     fadd	%st(0), %st(1)
# CHECK-NEXT:  1      3     1.00                  U     fadd	%st(2)
# CHECK-NEXT:  2      10    1.00    *             U     fadds	(%ecx)
# CHECK-NEXT:  2      10    1.00    *             U     faddl	(%ecx)
# CHECK-NEXT:  1      3     1.00                  U     faddp	%st(1)
# CHECK-NEXT:  1      3     1.00                  U     faddp	%st(2)
# CHECK-NEXT:  3      13    2.00    *             U     fiadds	(%ecx)
# CHECK-NEXT:  3      13    2.00    *             U     fiaddl	(%ecx)
# CHECK-NEXT:  1      100   0.33                  U     fbld	(%ecx)
# CHECK-NEXT:  1      100   0.33                  U     fbstp	(%eax)
# CHECK-NEXT:  1      1     1.00                  U     fchs
# CHECK-NEXT:  1      100   0.33                  U     fnclex
# CHECK-NEXT:  3      3     2.00                  U     fcmovb	%st(1), %st(0)
# CHECK-NEXT:  3      3     2.00                  U     fcmovbe	%st(1), %st(0)
# CHECK-NEXT:  3      3     2.00                  U     fcmove	%st(1), %st(0)
# CHECK-NEXT:  3      3     2.00                  U     fcmovnb	%st(1), %st(0)
# CHECK-NEXT:  3      3     2.00                  U     fcmovnbe	%st(1), %st(0)
# CHECK-NEXT:  3      3     2.00                  U     fcmovne	%st(1), %st(0)
# CHECK-NEXT:  3      3     2.00                  U     fcmovnu	%st(1), %st(0)
# CHECK-NEXT:  3      3     2.00                  U     fcmovu	%st(1), %st(0)
# CHECK-NEXT:  1      1     1.00                  U     fcom	%st(1)
# CHECK-NEXT:  1      1     1.00                  U     fcom	%st(3)
# CHECK-NEXT:  2      8     1.00                  U     fcoms	(%ecx)
# CHECK-NEXT:  2      8     1.00                  U     fcoml	(%eax)
# CHECK-NEXT:  1      1     1.00                  U     fcomp	%st(1)
# CHECK-NEXT:  1      1     1.00                  U     fcomp	%st(3)
# CHECK-NEXT:  2      8     1.00                  U     fcomps	(%ecx)
# CHECK-NEXT:  2      8     1.00                  U     fcompl	(%eax)
# CHECK-NEXT:  1      100   0.33                  U     fcompp
# CHECK-NEXT:  3      3     1.00                  U     fcomi	%st(3)
# CHECK-NEXT:  3      3     1.00                  U     fcompi	%st(3)
# CHECK-NEXT:  1      100   0.33                  U     fcos
# CHECK-NEXT:  1      1     1.00                  U     fdecstp
# CHECK-NEXT:  1      14    14.00                 U     fdiv	%st(0), %st(1)
# CHECK-NEXT:  1      14    14.00                 U     fdiv	%st(2)
# CHECK-NEXT:  2      31    1.00    *             U     fdivs	(%ecx)
# CHECK-NEXT:  2      31    1.00    *             U     fdivl	(%eax)
# CHECK-NEXT:  1      14    14.00                 U     fdivp	%st(1)
# CHECK-NEXT:  1      14    14.00                 U     fdivp	%st(2)
# CHECK-NEXT:  3      34    1.00    *             U     fidivs	(%ecx)
# CHECK-NEXT:  3      34    1.00    *             U     fidivl	(%eax)
# CHECK-NEXT:  1      14    14.00                 U     fdivr	%st(0), %st(1)
# CHECK-NEXT:  1      14    14.00                 U     fdivr	%st(2)
# CHECK-NEXT:  2      31    1.00    *             U     fdivrs	(%ecx)
# CHECK-NEXT:  2      31    1.00    *             U     fdivrl	(%eax)
# CHECK-NEXT:  1      14    14.00                 U     fdivrp	%st(1)
# CHECK-NEXT:  1      14    14.00                 U     fdivrp	%st(2)
# CHECK-NEXT:  3      34    1.00    *             U     fidivrs	(%ecx)
# CHECK-NEXT:  3      34    1.00    *             U     fidivrl	(%eax)
# CHECK-NEXT:  1      1     1.00                  U     ffree	%st(0)
# CHECK-NEXT:  3      11    2.00                  U     ficoms	(%ecx)
# CHECK-NEXT:  3      11    2.00                  U     ficoml	(%eax)
# CHECK-NEXT:  3      11    2.00                  U     ficomps	(%ecx)
# CHECK-NEXT:  3      11    2.00                  U     ficompl	(%eax)
# CHECK-NEXT:  2      10    1.00    *             U     filds	(%edx)
# CHECK-NEXT:  2      10    1.00    *             U     fildl	(%ecx)
# CHECK-NEXT:  2      10    1.00    *             U     fildll	(%eax)
# CHECK-NEXT:  1      1     1.00                  U     fincstp
# CHECK-NEXT:  4      5     1.33                  U     fninit
# CHECK-NEXT:  4      9     1.00           *      U     fists	(%edx)
# CHECK-NEXT:  4      9     1.00           *      U     fistl	(%ecx)
# CHECK-NEXT:  4      9     1.00           *      U     fistps	(%edx)
# CHECK-NEXT:  4      9     1.00           *      U     fistpl	(%ecx)
# CHECK-NEXT:  4      9     1.00           *      U     fistpll	(%eax)
# CHECK-NEXT:  3      5     1.00           *      U     fisttps	(%edx)
# CHECK-NEXT:  3      5     1.00           *      U     fisttpl	(%ecx)
# CHECK-NEXT:  3      5     1.00           *      U     fisttpll	(%eax)
# CHECK-NEXT:  1      1     1.00                  U     fld	%st(0)
# CHECK-NEXT:  3      9     1.00    *             U     flds	(%edx)
# CHECK-NEXT:  3      9     1.00    *             U     fldl	(%ecx)
# CHECK-NEXT:  3      9     1.00    *             U     fldt	(%eax)
# CHECK-NEXT:  5      8     2.00    *             U     fldcw	(%eax)
# CHECK-NEXT:  1      100   0.33                  U     fldenv	(%eax)
# CHECK-NEXT:  2      1     1.00                  U     fld1
# CHECK-NEXT:  2      1     1.00                  U     fldl2e
# CHECK-NEXT:  2      1     1.00                  U     fldl2t
# CHECK-NEXT:  2      1     1.00                  U     fldlg2
# CHECK-NEXT:  2      1     1.00                  U     fldln2
# CHECK-NEXT:  2      1     1.00                  U     fldpi
# CHECK-NEXT:  1      1     1.00                  U     fldz
# CHECK-NEXT:  1      5     1.00                  U     fmul	%st(0), %st(1)
# CHECK-NEXT:  1      5     1.00                  U     fmul	%st(2)
# CHECK-NEXT:  2      12    1.00    *             U     fmuls	(%ecx)
# CHECK-NEXT:  2      12    1.00    *             U     fmull	(%eax)
# CHECK-NEXT:  1      5     1.00                  U     fmulp	%st(1)
# CHECK-NEXT:  1      5     1.00                  U     fmulp	%st(2)
# CHECK-NEXT:  3      15    1.00    *             U     fimuls	(%ecx)
# CHECK-NEXT:  3      15    1.00    *             U     fimull	(%eax)
# CHECK-NEXT:  1      1     1.00                  U     fnop
# CHECK-NEXT:  1      100   0.33                  U     fpatan
# CHECK-NEXT:  1      100   0.33                  U     fprem
# CHECK-NEXT:  1      100   0.33                  U     fprem1
# CHECK-NEXT:  1      100   0.33                  U     fptan
# CHECK-NEXT:  1      100   0.33                  U     frndint
# CHECK-NEXT:  1      100   0.33                  U     frstor	(%eax)
# CHECK-NEXT:  1      100   0.33                  U     fnsave	(%eax)
# CHECK-NEXT:  1      100   0.33                  U     fscale
# CHECK-NEXT:  1      100   0.33                  U     fsin
# CHECK-NEXT:  1      100   0.33                  U     fsincos
# CHECK-NEXT:  1      24    24.00                 U     fsqrt
# CHECK-NEXT:  1      1     1.00                  U     fst	%st(0)
# CHECK-NEXT:  3      6     1.00           *      U     fsts	(%edx)
# CHECK-NEXT:  3      6     1.00           *      U     fstl	(%ecx)
# CHECK-NEXT:  1      1     1.00                  U     fstp	%st(0)
# CHECK-NEXT:  3      6     1.00           *      U     fstpl	(%edx)
# CHECK-NEXT:  3      6     1.00           *      U     fstpl	(%ecx)
# CHECK-NEXT:  3      6     1.00           *      U     fstpt	(%eax)
# CHECK-NEXT:  4      7     1.00           *      U     fnstcw	(%eax)
# CHECK-NEXT:  1      100   0.33                  U     fnstenv	(%eax)
# CHECK-NEXT:  4      7     1.00                  U     fnstsw	(%eax)
# CHECK-NEXT:  1      100   0.33                  U     frstor	(%eax)
# CHECK-NEXT:  1      100   0.33                  U     wait
# CHECK-NEXT:  1      100   0.33                  U     fnsave	(%eax)
# CHECK-NEXT:  1      3     1.00                  U     fsub	%st(0), %st(1)
# CHECK-NEXT:  1      3     1.00                  U     fsub	%st(2)
# CHECK-NEXT:  2      10    1.00    *             U     fsubs	(%ecx)
# CHECK-NEXT:  2      10    1.00    *             U     fsubl	(%eax)
# CHECK-NEXT:  1      3     1.00                  U     fsubp	%st(1)
# CHECK-NEXT:  1      3     1.00                  U     fsubp	%st(2)
# CHECK-NEXT:  3      13    2.00    *             U     fisubs	(%ecx)
# CHECK-NEXT:  3      13    2.00    *             U     fisubl	(%eax)
# CHECK-NEXT:  1      3     1.00                  U     fsubr	%st(0), %st(1)
# CHECK-NEXT:  1      3     1.00                  U     fsubr	%st(2)
# CHECK-NEXT:  2      10    1.00    *             U     fsubrs	(%ecx)
# CHECK-NEXT:  2      10    1.00    *             U     fsubrl	(%eax)
# CHECK-NEXT:  1      3     1.00                  U     fsubrp	%st(1)
# CHECK-NEXT:  1      3     1.00                  U     fsubrp	%st(2)
# CHECK-NEXT:  3      13    2.00    *             U     fisubrs	(%ecx)
# CHECK-NEXT:  3      13    2.00    *             U     fisubrl	(%eax)
# CHECK-NEXT:  1      3     1.00                  U     ftst
# CHECK-NEXT:  1      1     1.00                  U     fucom	%st(1)
# CHECK-NEXT:  1      1     1.00                  U     fucom	%st(3)
# CHECK-NEXT:  1      1     1.00                  U     fucomp	%st(1)
# CHECK-NEXT:  1      1     1.00                  U     fucomp	%st(3)
# CHECK-NEXT:  1      3     1.00                  U     fucompp
# CHECK-NEXT:  3      3     1.00                  U     fucomi	%st(3)
# CHECK-NEXT:  3      3     1.00                  U     fucompi	%st(3)
# CHECK-NEXT:  1      100   0.33                  U     wait
# CHECK-NEXT:  1      100   0.33                  U     fxam
# CHECK-NEXT:  1      1     0.33                  U     fxch	%st(1)
# CHECK-NEXT:  1      1     0.33                  U     fxch	%st(3)
# CHECK-NEXT:  5      5     2.00    *      *      U     fxrstor	(%eax)
# CHECK-NEXT:  1      100   0.33    *      *      U     fxsave	(%eax)
# CHECK-NEXT:  1      100   0.33                  U     fxtract
# CHECK-NEXT:  1      100   0.33                  U     fyl2x
# CHECK-NEXT:  1      100   0.33                  U     fyl2xp1

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
# CHECK-NEXT:  -     136.00 52.67  90.67  17.00  54.67  34.00  34.00

# CHECK:      Resource pressure by instruction:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6.0]  [6.1]  Instructions:
# CHECK-NEXT:  -      -     0.33   0.33    -     0.33    -      -     f2xm1
# CHECK-NEXT:  -      -      -      -      -     1.00    -      -     fabs
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     fadd	%st(0), %st(1)
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     fadd	%st(2)
# CHECK-NEXT:  -      -      -     1.00    -      -     0.50   0.50   fadds	(%ecx)
# CHECK-NEXT:  -      -      -     1.00    -      -     0.50   0.50   faddl	(%ecx)
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     faddp	%st(1)
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     faddp	%st(2)
# CHECK-NEXT:  -      -      -     2.00    -      -     0.50   0.50   fiadds	(%ecx)
# CHECK-NEXT:  -      -      -     2.00    -      -     0.50   0.50   fiaddl	(%ecx)
# CHECK-NEXT:  -      -     0.33   0.33    -     0.33    -      -     fbld	(%ecx)
# CHECK-NEXT:  -      -     0.33   0.33    -     0.33    -      -     fbstp	(%eax)
# CHECK-NEXT:  -      -      -      -      -     1.00    -      -     fchs
# CHECK-NEXT:  -      -     0.33   0.33    -     0.33    -      -     fnclex
# CHECK-NEXT:  -      -     0.50    -      -     2.50    -      -     fcmovb	%st(1), %st(0)
# CHECK-NEXT:  -      -     0.50    -      -     2.50    -      -     fcmovbe	%st(1), %st(0)
# CHECK-NEXT:  -      -     0.50    -      -     2.50    -      -     fcmove	%st(1), %st(0)
# CHECK-NEXT:  -      -     0.50    -      -     2.50    -      -     fcmovnb	%st(1), %st(0)
# CHECK-NEXT:  -      -     0.50    -      -     2.50    -      -     fcmovnbe	%st(1), %st(0)
# CHECK-NEXT:  -      -     0.50    -      -     2.50    -      -     fcmovne	%st(1), %st(0)
# CHECK-NEXT:  -      -     0.50    -      -     2.50    -      -     fcmovnu	%st(1), %st(0)
# CHECK-NEXT:  -      -     0.50    -      -     2.50    -      -     fcmovu	%st(1), %st(0)
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     fcom	%st(1)
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     fcom	%st(3)
# CHECK-NEXT:  -      -      -     1.00    -      -     0.50   0.50   fcoms	(%ecx)
# CHECK-NEXT:  -      -      -     1.00    -      -     0.50   0.50   fcoml	(%eax)
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     fcomp	%st(1)
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     fcomp	%st(3)
# CHECK-NEXT:  -      -      -     1.00    -      -     0.50   0.50   fcomps	(%ecx)
# CHECK-NEXT:  -      -      -     1.00    -      -     0.50   0.50   fcompl	(%eax)
# CHECK-NEXT:  -      -     0.33   0.33    -     0.33    -      -     fcompp
# CHECK-NEXT:  -      -     1.00   1.00    -     1.00    -      -     fcomi	%st(3)
# CHECK-NEXT:  -      -     1.00   1.00    -     1.00    -      -     fcompi	%st(3)
# CHECK-NEXT:  -      -     0.33   0.33    -     0.33    -      -     fcos
# CHECK-NEXT:  -      -      -      -      -     1.00    -      -     fdecstp
# CHECK-NEXT:  -     14.00  1.00    -      -      -      -      -     fdiv	%st(0), %st(1)
# CHECK-NEXT:  -     14.00  1.00    -      -      -      -      -     fdiv	%st(2)
# CHECK-NEXT:  -      -     1.00    -      -      -     0.50   0.50   fdivs	(%ecx)
# CHECK-NEXT:  -      -     1.00    -      -      -     0.50   0.50   fdivl	(%eax)
# CHECK-NEXT:  -     14.00  1.00    -      -      -      -      -     fdivp	%st(1)
# CHECK-NEXT:  -     14.00  1.00    -      -      -      -      -     fdivp	%st(2)
# CHECK-NEXT:  -      -     1.00   1.00    -      -     0.50   0.50   fidivs	(%ecx)
# CHECK-NEXT:  -      -     1.00   1.00    -      -     0.50   0.50   fidivl	(%eax)
# CHECK-NEXT:  -     14.00  1.00    -      -      -      -      -     fdivr	%st(0), %st(1)
# CHECK-NEXT:  -     14.00  1.00    -      -      -      -      -     fdivr	%st(2)
# CHECK-NEXT:  -      -     1.00    -      -      -     0.50   0.50   fdivrs	(%ecx)
# CHECK-NEXT:  -      -     1.00    -      -      -     0.50   0.50   fdivrl	(%eax)
# CHECK-NEXT:  -     14.00  1.00    -      -      -      -      -     fdivrp	%st(1)
# CHECK-NEXT:  -     14.00  1.00    -      -      -      -      -     fdivrp	%st(2)
# CHECK-NEXT:  -      -     1.00   1.00    -      -     0.50   0.50   fidivrs	(%ecx)
# CHECK-NEXT:  -      -     1.00   1.00    -      -     0.50   0.50   fidivrl	(%eax)
# CHECK-NEXT:  -      -      -      -      -     1.00    -      -     ffree	%st(0)
# CHECK-NEXT:  -      -      -     2.00    -      -     0.50   0.50   ficoms	(%ecx)
# CHECK-NEXT:  -      -      -     2.00    -      -     0.50   0.50   ficoml	(%eax)
# CHECK-NEXT:  -      -      -     2.00    -      -     0.50   0.50   ficomps	(%ecx)
# CHECK-NEXT:  -      -      -     2.00    -      -     0.50   0.50   ficompl	(%eax)
# CHECK-NEXT:  -      -      -     1.00    -      -     0.50   0.50   filds	(%edx)
# CHECK-NEXT:  -      -      -     1.00    -      -     0.50   0.50   fildl	(%ecx)
# CHECK-NEXT:  -      -      -     1.00    -      -     0.50   0.50   fildll	(%eax)
# CHECK-NEXT:  -      -      -      -      -     1.00    -      -     fincstp
# CHECK-NEXT:  -      -     1.00   1.00    -     2.00    -      -     fninit
# CHECK-NEXT:  -      -      -     1.00   1.00    -     1.00   1.00   fists	(%edx)
# CHECK-NEXT:  -      -      -     1.00   1.00    -     1.00   1.00   fistl	(%ecx)
# CHECK-NEXT:  -      -      -     1.00   1.00    -     1.00   1.00   fistps	(%edx)
# CHECK-NEXT:  -      -      -     1.00   1.00    -     1.00   1.00   fistpl	(%ecx)
# CHECK-NEXT:  -      -      -     1.00   1.00    -     1.00   1.00   fistpll	(%eax)
# CHECK-NEXT:  -      -      -     1.00   1.00    -     0.50   0.50   fisttps	(%edx)
# CHECK-NEXT:  -      -      -     1.00   1.00    -     0.50   0.50   fisttpl	(%ecx)
# CHECK-NEXT:  -      -      -     1.00   1.00    -     0.50   0.50   fisttpll	(%eax)
# CHECK-NEXT:  -      -      -      -      -     1.00    -      -     fld	%st(0)
# CHECK-NEXT:  -      -     0.50   0.50    -     1.00   0.50   0.50   flds	(%edx)
# CHECK-NEXT:  -      -     0.50   0.50    -     1.00   0.50   0.50   fldl	(%ecx)
# CHECK-NEXT:  -      -     0.50   0.50    -     1.00   0.50   0.50   fldt	(%eax)
# CHECK-NEXT:  -      -      -      -     1.00   2.00   1.00   1.00   fldcw	(%eax)
# CHECK-NEXT:  -      -     0.33   0.33    -     0.33    -      -     fldenv	(%eax)
# CHECK-NEXT:  -      -     1.00    -      -     1.00    -      -     fld1
# CHECK-NEXT:  -      -     1.00   1.00    -      -      -      -     fldl2e
# CHECK-NEXT:  -      -     1.00   1.00    -      -      -      -     fldl2t
# CHECK-NEXT:  -      -     1.00   1.00    -      -      -      -     fldlg2
# CHECK-NEXT:  -      -     1.00   1.00    -      -      -      -     fldln2
# CHECK-NEXT:  -      -     1.00   1.00    -      -      -      -     fldpi
# CHECK-NEXT:  -      -      -      -      -     1.00    -      -     fldz
# CHECK-NEXT:  -      -     1.00    -      -      -      -      -     fmul	%st(0), %st(1)
# CHECK-NEXT:  -      -     1.00    -      -      -      -      -     fmul	%st(2)
# CHECK-NEXT:  -      -     1.00    -      -      -     0.50   0.50   fmuls	(%ecx)
# CHECK-NEXT:  -      -     1.00    -      -      -     0.50   0.50   fmull	(%eax)
# CHECK-NEXT:  -      -     1.00    -      -      -      -      -     fmulp	%st(1)
# CHECK-NEXT:  -      -     1.00    -      -      -      -      -     fmulp	%st(2)
# CHECK-NEXT:  -      -     1.00   1.00    -      -     0.50   0.50   fimuls	(%ecx)
# CHECK-NEXT:  -      -     1.00   1.00    -      -     0.50   0.50   fimull	(%eax)
# CHECK-NEXT:  -      -      -      -      -     1.00    -      -     fnop
# CHECK-NEXT:  -      -     0.33   0.33    -     0.33    -      -     fpatan
# CHECK-NEXT:  -      -     0.33   0.33    -     0.33    -      -     fprem
# CHECK-NEXT:  -      -     0.33   0.33    -     0.33    -      -     fprem1
# CHECK-NEXT:  -      -     0.33   0.33    -     0.33    -      -     fptan
# CHECK-NEXT:  -      -     0.33   0.33    -     0.33    -      -     frndint
# CHECK-NEXT:  -      -     0.33   0.33    -     0.33    -      -     frstor	(%eax)
# CHECK-NEXT:  -      -     0.33   0.33    -     0.33    -      -     fnsave	(%eax)
# CHECK-NEXT:  -      -     0.33   0.33    -     0.33    -      -     fscale
# CHECK-NEXT:  -      -     0.33   0.33    -     0.33    -      -     fsin
# CHECK-NEXT:  -      -     0.33   0.33    -     0.33    -      -     fsincos
# CHECK-NEXT:  -     24.00  1.00    -      -      -      -      -     fsqrt
# CHECK-NEXT:  -      -      -      -      -     1.00    -      -     fst	%st(0)
# CHECK-NEXT:  -      -      -      -     1.00    -     1.00   1.00   fsts	(%edx)
# CHECK-NEXT:  -      -      -      -     1.00    -     1.00   1.00   fstl	(%ecx)
# CHECK-NEXT:  -      -      -      -      -     1.00    -      -     fstp	%st(0)
# CHECK-NEXT:  -      -      -      -     1.00    -     1.00   1.00   fstpl	(%edx)
# CHECK-NEXT:  -      -      -      -     1.00    -     1.00   1.00   fstpl	(%ecx)
# CHECK-NEXT:  -      -      -      -     1.00    -     1.00   1.00   fstpt	(%eax)
# CHECK-NEXT:  -      -      -      -     1.00   1.00   1.00   1.00   fnstcw	(%eax)
# CHECK-NEXT:  -      -     0.33   0.33    -     0.33    -      -     fnstenv	(%eax)
# CHECK-NEXT:  -      -     1.00    -     1.00    -     1.00   1.00   fnstsw	(%eax)
# CHECK-NEXT:  -      -     0.33   0.33    -     0.33    -      -     frstor	(%eax)
# CHECK-NEXT:  -      -     0.33   0.33    -     0.33    -      -     wait
# CHECK-NEXT:  -      -     0.33   0.33    -     0.33    -      -     fnsave	(%eax)
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     fsub	%st(0), %st(1)
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     fsub	%st(2)
# CHECK-NEXT:  -      -      -     1.00    -      -     0.50   0.50   fsubs	(%ecx)
# CHECK-NEXT:  -      -      -     1.00    -      -     0.50   0.50   fsubl	(%eax)
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     fsubp	%st(1)
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     fsubp	%st(2)
# CHECK-NEXT:  -      -      -     2.00    -      -     0.50   0.50   fisubs	(%ecx)
# CHECK-NEXT:  -      -      -     2.00    -      -     0.50   0.50   fisubl	(%eax)
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     fsubr	%st(0), %st(1)
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     fsubr	%st(2)
# CHECK-NEXT:  -      -      -     1.00    -      -     0.50   0.50   fsubrs	(%ecx)
# CHECK-NEXT:  -      -      -     1.00    -      -     0.50   0.50   fsubrl	(%eax)
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     fsubrp	%st(1)
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     fsubrp	%st(2)
# CHECK-NEXT:  -      -      -     2.00    -      -     0.50   0.50   fisubrs	(%ecx)
# CHECK-NEXT:  -      -      -     2.00    -      -     0.50   0.50   fisubrl	(%eax)
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     ftst
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     fucom	%st(1)
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     fucom	%st(3)
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     fucomp	%st(1)
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     fucomp	%st(3)
# CHECK-NEXT:  -      -      -     1.00    -      -      -      -     fucompp
# CHECK-NEXT:  -      -     1.00   1.00    -     1.00    -      -     fucomi	%st(3)
# CHECK-NEXT:  -      -     1.00   1.00    -     1.00    -      -     fucompi	%st(3)
# CHECK-NEXT:  -      -     0.33   0.33    -     0.33    -      -     wait
# CHECK-NEXT:  -      -     0.33   0.33    -     0.33    -      -     fxam
# CHECK-NEXT:  -      -     0.33   0.33    -     0.33    -      -     fxch	%st(1)
# CHECK-NEXT:  -      -     0.33   0.33    -     0.33    -      -     fxch	%st(3)
# CHECK-NEXT:  -      -     0.50   0.50   1.00   2.00   0.50   0.50   fxrstor	(%eax)
# CHECK-NEXT:  -      -     0.33   0.33    -     0.33    -      -     fxsave	(%eax)
# CHECK-NEXT:  -      -     0.33   0.33    -     0.33    -      -     fxtract
# CHECK-NEXT:  -      -     0.33   0.33    -     0.33    -      -     fyl2x
# CHECK-NEXT:  -      -     0.33   0.33    -     0.33    -      -     fyl2xp1
