; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32  < %s | FileCheck  %s

%struct.S = type { [40 x i32], i32, i32, i32, [4100 x i32], i32, i32, i32 }
@s = common dso_local global %struct.S zeroinitializer, align 4
@foo = global [6 x i16] [i16 1, i16 2, i16 3, i16 4, i16 5, i16 0], align 2

define dso_local void @multiple_stores() local_unnamed_addr {
; CHECK-LABEL: multiple_stores:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lui a0, %hi(s)
; CHECK-NEXT:    addi a0, a0, %lo(s)
; CHECK-NEXT:    addi a1, zero, 20
; CHECK-NEXT:    sw a1, 164(a0)
; CHECK-NEXT:    addi a1, zero, 10
; CHECK-NEXT:    sw a1, 160(a0)
; CHECK-NEXT:    ret
entry:
  store i32 10, i32* getelementptr inbounds (%struct.S, %struct.S* @s, i32 0, i32 1), align 4
  store i32 20, i32* getelementptr inbounds (%struct.S, %struct.S* @s, i32 0, i32 2), align 4
  ret void
}

define dso_local void @control_flow() local_unnamed_addr #0 {
; CHECK-LABEL: control_flow:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lui a0, %hi(s)
; CHECK-NEXT:    addi a0, a0, %lo(s)
; CHECK-NEXT:    lw a1, 164(a0)
; CHECK-NEXT:    addi a2, zero, 1
; CHECK-NEXT:    blt a1, a2, .LBB1_2
; CHECK-NEXT:  # %bb.1: # %if.then
; CHECK-NEXT:    addi a1, zero, 10
; CHECK-NEXT:    sw a1, 160(a0)
; CHECK-NEXT:  .LBB1_2: # %if.end
; CHECK-NEXT:    ret
entry:
  %0 = load i32, i32* getelementptr inbounds (%struct.S, %struct.S* @s, i32 0, i32 2), align 4
  %cmp = icmp sgt i32 %0, 0
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  store i32 10, i32* getelementptr inbounds (%struct.S, %struct.S* @s, i32 0, i32 1), align 4
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  ret void
}

;TODO: Offset shouln't be separated in this case. We get shorter sequence if it
; is merged in the LUI %hi and the ADDI %lo.
define dso_local i32* @big_offset_one_use() local_unnamed_addr {
; CHECK-LABEL: big_offset_one_use:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lui a0, 4
; CHECK-NEXT:    addi a0, a0, 188
; CHECK-NEXT:    lui a1, %hi(s)
; CHECK-NEXT:    addi a1, a1, %lo(s)
; CHECK-NEXT:    add a0, a1, a0
; CHECK-NEXT:    ret
entry:
  ret i32* getelementptr inbounds (%struct.S, %struct.S* @s, i32 0, i32 5)
}

;TODO: Offset shouln't be separated in this case. We get shorter sequence if it
; is merged in the LUI %hi and the ADDI %lo.
define dso_local i32* @small_offset_one_use() local_unnamed_addr {
; CHECK-LABEL: small_offset_one_use:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lui a0, %hi(s)
; CHECK-NEXT:    addi a0, a0, %lo(s)
; CHECK-NEXT:    addi a0, a0, 160
; CHECK-NEXT:    ret
entry:
  ret i32* getelementptr inbounds (%struct.S, %struct.S* @s, i32 0, i32 1)
}


;TODO: Offset shouln't be separated in this case. We get shorter sequence if it
; is merged in the LUI %hi and the ADDI %lo.
define dso_local i32 @load_half() nounwind {
; CHECK-LABEL: load_half:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    addi sp, sp, -16
; CHECK-NEXT:    sw ra, 12(sp)
; CHECK-NEXT:    lui a0, %hi(foo)
; CHECK-NEXT:    addi a0, a0, %lo(foo)
; CHECK-NEXT:    lhu a0, 8(a0)
; CHECK-NEXT:    addi a1, zero, 140
; CHECK-NEXT:    bne a0, a1, .LBB4_2
; CHECK-NEXT:  # %bb.1: # %if.end
; CHECK-NEXT:    mv a0, zero
; CHECK-NEXT:    lw ra, 12(sp)
; CHECK-NEXT:    addi sp, sp, 16
; CHECK-NEXT:    ret
; CHECK-NEXT:  .LBB4_2: # %if.then
; CHECK-NEXT:    call abort
entry:
  %0 = load i16, i16* getelementptr inbounds ([6 x i16], [6 x i16]* @foo, i32 0, i32 4), align 2
  %cmp = icmp eq i16 %0, 140
  br i1 %cmp, label %if.end, label %if.then

if.then:
  tail call void @abort()
  unreachable

if.end:
  ret i32 0
}

declare void @abort()
