; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -indvars -o - %s | FileCheck %s
target datalayout = "e-p:32:32:32-p1:64:64:64-p2:8:8:8-p3:16:16:16-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:32-n8:16:32:64"

; Derived from ptriv in lftr-reuse.ll
define void @ptriv_as2(i8 addrspace(2)* %base, i32 %n) nounwind {
; CHECK-LABEL: @ptriv_as2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[IDX_TRUNC:%.*]] = trunc i32 [[N:%.*]] to i8
; CHECK-NEXT:    [[ADD_PTR:%.*]] = getelementptr inbounds i8, i8 addrspace(2)* [[BASE:%.*]], i8 [[IDX_TRUNC]]
; CHECK-NEXT:    [[CMP1:%.*]] = icmp ult i8 addrspace(2)* [[BASE]], [[ADD_PTR]]
; CHECK-NEXT:    br i1 [[CMP1]], label [[FOR_BODY_PREHEADER:%.*]], label [[FOR_END:%.*]]
; CHECK:       for.body.preheader:
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[P_02:%.*]] = phi i8 addrspace(2)* [ [[INCDEC_PTR:%.*]], [[FOR_BODY]] ], [ [[BASE]], [[FOR_BODY_PREHEADER]] ]
; CHECK-NEXT:    [[SUB_PTR_LHS_CAST:%.*]] = ptrtoint i8 addrspace(2)* [[P_02]] to i8
; CHECK-NEXT:    [[SUB_PTR_RHS_CAST:%.*]] = ptrtoint i8 addrspace(2)* [[BASE]] to i8
; CHECK-NEXT:    [[SUB_PTR_SUB:%.*]] = sub i8 [[SUB_PTR_LHS_CAST]], [[SUB_PTR_RHS_CAST]]
; CHECK-NEXT:    store i8 [[SUB_PTR_SUB]], i8 addrspace(2)* [[P_02]]
; CHECK-NEXT:    [[INCDEC_PTR]] = getelementptr inbounds i8, i8 addrspace(2)* [[P_02]], i32 1
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp ne i8 addrspace(2)* [[INCDEC_PTR]], [[ADD_PTR]]
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[FOR_BODY]], label [[FOR_END_LOOPEXIT:%.*]]
; CHECK:       for.end.loopexit:
; CHECK-NEXT:    br label [[FOR_END]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  %idx.trunc = trunc i32 %n to i8
  %add.ptr = getelementptr inbounds i8, i8 addrspace(2)* %base, i8 %idx.trunc
  %cmp1 = icmp ult i8 addrspace(2)* %base, %add.ptr
  br i1 %cmp1, label %for.body, label %for.end

; Make sure the added GEP has the right index type

for.body:
  %p.02 = phi i8 addrspace(2)* [ %base, %entry ], [ %incdec.ptr, %for.body ]
  ; cruft to make the IV useful
  %sub.ptr.lhs.cast = ptrtoint i8 addrspace(2)* %p.02 to i8
  %sub.ptr.rhs.cast = ptrtoint i8 addrspace(2)* %base to i8
  %sub.ptr.sub = sub i8 %sub.ptr.lhs.cast, %sub.ptr.rhs.cast
  store i8 %sub.ptr.sub, i8 addrspace(2)* %p.02
  %incdec.ptr = getelementptr inbounds i8, i8 addrspace(2)* %p.02, i32 1
  %cmp = icmp ult i8 addrspace(2)* %incdec.ptr, %add.ptr
  br i1 %cmp, label %for.body, label %for.end

for.end:
  ret void
}

define void @ptriv_as3(i8 addrspace(3)* %base, i32 %n) nounwind {
; CHECK-LABEL: @ptriv_as3(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[IDX_TRUNC:%.*]] = trunc i32 [[N:%.*]] to i16
; CHECK-NEXT:    [[ADD_PTR:%.*]] = getelementptr inbounds i8, i8 addrspace(3)* [[BASE:%.*]], i16 [[IDX_TRUNC]]
; CHECK-NEXT:    [[CMP1:%.*]] = icmp ult i8 addrspace(3)* [[BASE]], [[ADD_PTR]]
; CHECK-NEXT:    br i1 [[CMP1]], label [[FOR_BODY_PREHEADER:%.*]], label [[FOR_END:%.*]]
; CHECK:       for.body.preheader:
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[P_02:%.*]] = phi i8 addrspace(3)* [ [[INCDEC_PTR:%.*]], [[FOR_BODY]] ], [ [[BASE]], [[FOR_BODY_PREHEADER]] ]
; CHECK-NEXT:    [[SUB_PTR_LHS_CAST:%.*]] = ptrtoint i8 addrspace(3)* [[P_02]] to i16
; CHECK-NEXT:    [[SUB_PTR_RHS_CAST:%.*]] = ptrtoint i8 addrspace(3)* [[BASE]] to i16
; CHECK-NEXT:    [[SUB_PTR_SUB:%.*]] = sub i16 [[SUB_PTR_LHS_CAST]], [[SUB_PTR_RHS_CAST]]
; CHECK-NEXT:    [[CONV:%.*]] = trunc i16 [[SUB_PTR_SUB]] to i8
; CHECK-NEXT:    store i8 [[CONV]], i8 addrspace(3)* [[P_02]]
; CHECK-NEXT:    [[INCDEC_PTR]] = getelementptr inbounds i8, i8 addrspace(3)* [[P_02]], i32 1
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp ne i8 addrspace(3)* [[INCDEC_PTR]], [[ADD_PTR]]
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[FOR_BODY]], label [[FOR_END_LOOPEXIT:%.*]]
; CHECK:       for.end.loopexit:
; CHECK-NEXT:    br label [[FOR_END]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  %idx.trunc = trunc i32 %n to i16
  %add.ptr = getelementptr inbounds i8, i8 addrspace(3)* %base, i16 %idx.trunc
  %cmp1 = icmp ult i8 addrspace(3)* %base, %add.ptr
  br i1 %cmp1, label %for.body, label %for.end

; Make sure the added GEP has the right index type

for.body:
  %p.02 = phi i8 addrspace(3)* [ %base, %entry ], [ %incdec.ptr, %for.body ]
  ; cruft to make the IV useful
  %sub.ptr.lhs.cast = ptrtoint i8 addrspace(3)* %p.02 to i16
  %sub.ptr.rhs.cast = ptrtoint i8 addrspace(3)* %base to i16
  %sub.ptr.sub = sub i16 %sub.ptr.lhs.cast, %sub.ptr.rhs.cast
  %conv = trunc i16 %sub.ptr.sub to i8
  store i8 %conv, i8 addrspace(3)* %p.02
  %incdec.ptr = getelementptr inbounds i8, i8 addrspace(3)* %p.02, i32 1
  %cmp = icmp ult i8 addrspace(3)* %incdec.ptr, %add.ptr
  br i1 %cmp, label %for.body, label %for.end

for.end:
  ret void
}

