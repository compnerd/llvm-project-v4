; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512f | FileCheck %s --check-prefix=CHECK --check-prefix=X64
; RUN: llc < %s -mtriple=i686-unknown-unknown -mattr=+avx512f | FileCheck %s --check-prefix=CHECK --check-prefix=X86

; Function Attrs: norecurse nounwind readnone
define zeroext i8 @TEST_mm512_test_epi64_mask(<8 x i64> %__A, <8 x i64> %__B) local_unnamed_addr #0 {
; CHECK-LABEL: TEST_mm512_test_epi64_mask:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vptestmq %zmm0, %zmm1, %k0
; CHECK-NEXT:    kmovw %k0, %eax
; CHECK-NEXT:    # kill: def $al killed $al killed $eax
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    ret{{[l|q]}}
entry:
  %and.i.i = and <8 x i64> %__B, %__A
  %0 = icmp ne <8 x i64> %and.i.i, zeroinitializer
  %1 = bitcast <8 x i1> %0 to i8
  ret i8 %1
}

; Similar to the above, but the compare is reversed to have the zeros on the LHS
define zeroext i8 @TEST_mm512_test_epi64_mask_2(<8 x i64> %__A, <8 x i64> %__B) local_unnamed_addr #0 {
; CHECK-LABEL: TEST_mm512_test_epi64_mask_2:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vptestmq %zmm0, %zmm1, %k0
; CHECK-NEXT:    kmovw %k0, %eax
; CHECK-NEXT:    # kill: def $al killed $al killed $eax
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    ret{{[l|q]}}
entry:
  %and.i.i = and <8 x i64> %__B, %__A
  %0 = icmp ne <8 x i64> zeroinitializer, %and.i.i
  %1 = bitcast <8 x i1> %0 to i8
  ret i8 %1
}

; Function Attrs: norecurse nounwind readnone
define zeroext i16 @TEST_mm512_test_epi32_mask(<8 x i64> %__A, <8 x i64> %__B) local_unnamed_addr #0 {
; CHECK-LABEL: TEST_mm512_test_epi32_mask:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vptestmd %zmm0, %zmm1, %k0
; CHECK-NEXT:    kmovw %k0, %eax
; CHECK-NEXT:    # kill: def $ax killed $ax killed $eax
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    ret{{[l|q]}}
entry:
  %and.i.i = and <8 x i64> %__B, %__A
  %0 = bitcast <8 x i64> %and.i.i to <16 x i32>
  %1 = icmp ne <16 x i32> %0, zeroinitializer
  %2 = bitcast <16 x i1> %1 to i16
  ret i16 %2
}

; Function Attrs: norecurse nounwind readnone
define zeroext i8 @TEST_mm512_mask_test_epi64_mask(i8 %__U, <8 x i64> %__A, <8 x i64> %__B) local_unnamed_addr #0 {
; X64-LABEL: TEST_mm512_mask_test_epi64_mask:
; X64:       # %bb.0: # %entry
; X64-NEXT:    vptestmq %zmm0, %zmm1, %k0
; X64-NEXT:    kmovw %k0, %eax
; X64-NEXT:    andb %dil, %al
; X64-NEXT:    # kill: def $al killed $al killed $eax
; X64-NEXT:    vzeroupper
; X64-NEXT:    retq
;
; X86-LABEL: TEST_mm512_mask_test_epi64_mask:
; X86:       # %bb.0: # %entry
; X86-NEXT:    vptestmq %zmm0, %zmm1, %k0
; X86-NEXT:    kmovw %k0, %eax
; X86-NEXT:    andb {{[0-9]+}}(%esp), %al
; X86-NEXT:    # kill: def $al killed $al killed $eax
; X86-NEXT:    vzeroupper
; X86-NEXT:    retl
entry:
  %and.i.i = and <8 x i64> %__B, %__A
  %0 = icmp ne <8 x i64> %and.i.i, zeroinitializer
  %1 = bitcast i8 %__U to <8 x i1>
  %2 = and <8 x i1> %0, %1
  %3 = bitcast <8 x i1> %2 to i8
  ret i8 %3
}

; Function Attrs: norecurse nounwind readnone
define zeroext i16 @TEST_mm512_mask_test_epi32_mask(i16 %__U, <8 x i64> %__A, <8 x i64> %__B) local_unnamed_addr #0 {
; X64-LABEL: TEST_mm512_mask_test_epi32_mask:
; X64:       # %bb.0: # %entry
; X64-NEXT:    vptestmd %zmm0, %zmm1, %k0
; X64-NEXT:    kmovw %k0, %eax
; X64-NEXT:    andl %edi, %eax
; X64-NEXT:    # kill: def $ax killed $ax killed $eax
; X64-NEXT:    vzeroupper
; X64-NEXT:    retq
;
; X86-LABEL: TEST_mm512_mask_test_epi32_mask:
; X86:       # %bb.0: # %entry
; X86-NEXT:    vptestmd %zmm0, %zmm1, %k0
; X86-NEXT:    kmovw %k0, %eax
; X86-NEXT:    andw {{[0-9]+}}(%esp), %ax
; X86-NEXT:    # kill: def $ax killed $ax killed $eax
; X86-NEXT:    vzeroupper
; X86-NEXT:    retl
entry:
  %and.i.i = and <8 x i64> %__B, %__A
  %0 = bitcast <8 x i64> %and.i.i to <16 x i32>
  %1 = icmp ne <16 x i32> %0, zeroinitializer
  %2 = bitcast i16 %__U to <16 x i1>
  %3 = and <16 x i1> %1, %2
  %4 = bitcast <16 x i1> %3 to i16
  ret i16 %4
}

; Function Attrs: norecurse nounwind readnone
define zeroext i8 @TEST_mm512_testn_epi64_mask(<8 x i64> %__A, <8 x i64> %__B) local_unnamed_addr #0 {
; CHECK-LABEL: TEST_mm512_testn_epi64_mask:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vptestnmq %zmm0, %zmm1, %k0
; CHECK-NEXT:    kmovw %k0, %eax
; CHECK-NEXT:    # kill: def $al killed $al killed $eax
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    ret{{[l|q]}}
entry:
  %and.i.i = and <8 x i64> %__B, %__A
  %0 = icmp eq <8 x i64> %and.i.i, zeroinitializer
  %1 = bitcast <8 x i1> %0 to i8
  ret i8 %1
}

; Similar to the above, but the compare is reversed to have the zeros on the LHS
define zeroext i8 @TEST_mm512_testn_epi64_mask_2(<8 x i64> %__A, <8 x i64> %__B) local_unnamed_addr #0 {
; CHECK-LABEL: TEST_mm512_testn_epi64_mask_2:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vptestnmq %zmm0, %zmm1, %k0
; CHECK-NEXT:    kmovw %k0, %eax
; CHECK-NEXT:    # kill: def $al killed $al killed $eax
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    ret{{[l|q]}}
entry:
  %and.i.i = and <8 x i64> %__B, %__A
  %0 = icmp eq <8 x i64> zeroinitializer, %and.i.i
  %1 = bitcast <8 x i1> %0 to i8
  ret i8 %1
}

; Function Attrs: norecurse nounwind readnone
define zeroext i16 @TEST_mm512_testn_epi32_mask(<8 x i64> %__A, <8 x i64> %__B) local_unnamed_addr #0 {
; CHECK-LABEL: TEST_mm512_testn_epi32_mask:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vptestnmd %zmm0, %zmm1, %k0
; CHECK-NEXT:    kmovw %k0, %eax
; CHECK-NEXT:    # kill: def $ax killed $ax killed $eax
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    ret{{[l|q]}}
entry:
  %and.i.i = and <8 x i64> %__B, %__A
  %0 = bitcast <8 x i64> %and.i.i to <16 x i32>
  %1 = icmp eq <16 x i32> %0, zeroinitializer
  %2 = bitcast <16 x i1> %1 to i16
  ret i16 %2
}

; Function Attrs: norecurse nounwind readnone
define zeroext i8 @TEST_mm512_mask_testn_epi64_mask(i8 %__U, <8 x i64> %__A, <8 x i64> %__B) local_unnamed_addr #0 {
; X64-LABEL: TEST_mm512_mask_testn_epi64_mask:
; X64:       # %bb.0: # %entry
; X64-NEXT:    vptestnmq %zmm0, %zmm1, %k0
; X64-NEXT:    kmovw %k0, %eax
; X64-NEXT:    andb %dil, %al
; X64-NEXT:    # kill: def $al killed $al killed $eax
; X64-NEXT:    vzeroupper
; X64-NEXT:    retq
;
; X86-LABEL: TEST_mm512_mask_testn_epi64_mask:
; X86:       # %bb.0: # %entry
; X86-NEXT:    vptestnmq %zmm0, %zmm1, %k0
; X86-NEXT:    kmovw %k0, %eax
; X86-NEXT:    andb {{[0-9]+}}(%esp), %al
; X86-NEXT:    # kill: def $al killed $al killed $eax
; X86-NEXT:    vzeroupper
; X86-NEXT:    retl
entry:
  %and.i.i = and <8 x i64> %__B, %__A
  %0 = icmp eq <8 x i64> %and.i.i, zeroinitializer
  %1 = bitcast i8 %__U to <8 x i1>
  %2 = and <8 x i1> %0, %1
  %3 = bitcast <8 x i1> %2 to i8
  ret i8 %3
}

; Function Attrs: norecurse nounwind readnone
define zeroext i16 @TEST_mm512_mask_testn_epi32_mask(i16 %__U, <8 x i64> %__A, <8 x i64> %__B) local_unnamed_addr #0 {
; X64-LABEL: TEST_mm512_mask_testn_epi32_mask:
; X64:       # %bb.0: # %entry
; X64-NEXT:    vptestnmd %zmm0, %zmm1, %k0
; X64-NEXT:    kmovw %k0, %eax
; X64-NEXT:    andl %edi, %eax
; X64-NEXT:    # kill: def $ax killed $ax killed $eax
; X64-NEXT:    vzeroupper
; X64-NEXT:    retq
;
; X86-LABEL: TEST_mm512_mask_testn_epi32_mask:
; X86:       # %bb.0: # %entry
; X86-NEXT:    vptestnmd %zmm0, %zmm1, %k0
; X86-NEXT:    kmovw %k0, %eax
; X86-NEXT:    andw {{[0-9]+}}(%esp), %ax
; X86-NEXT:    # kill: def $ax killed $ax killed $eax
; X86-NEXT:    vzeroupper
; X86-NEXT:    retl
entry:
  %and.i.i = and <8 x i64> %__B, %__A
  %0 = bitcast <8 x i64> %and.i.i to <16 x i32>
  %1 = icmp eq <16 x i32> %0, zeroinitializer
  %2 = bitcast i16 %__U to <16 x i1>
  %3 = and <16 x i1> %1, %2
  %4 = bitcast <16 x i1> %3 to i16
  ret i16 %4
}

define <2 x i64> @setcc_commute(<2 x i64> %a) {
; CHECK-LABEL: setcc_commute:
; CHECK:       # %bb.0:
; CHECK-NEXT:    # kill: def $xmm0 killed $xmm0 def $zmm0
; CHECK-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; CHECK-NEXT:    vpsubq %xmm0, %xmm1, %xmm1
; CHECK-NEXT:    vptestnmq %zmm0, %zmm0, %k1
; CHECK-NEXT:    vmovdqa64 %zmm0, %zmm1 {%k1}
; CHECK-NEXT:    vmovdqa %xmm1, %xmm0
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    ret{{[l|q]}}
  %1 = sub <2 x i64> zeroinitializer, %a
  %2 = icmp eq <2 x i64> %a, zeroinitializer
  %3 = select <2 x i1> %2, <2 x i64> %a, <2 x i64> %1
  ret <2 x i64> %3
}
