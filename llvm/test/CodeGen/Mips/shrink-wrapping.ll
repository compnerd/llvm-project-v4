; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py

; RUN: llc -mtriple=mips-unknown-linux-gnu -enable-shrink-wrap=true \
; RUN:   -relocation-model=static < %s | \
; RUN:   FileCheck %s -check-prefix=SHRINK-WRAP-STATIC

; RUN: llc -mtriple=mips-unknown-linux-gnu -enable-shrink-wrap=false \
; RUN:   -relocation-model=static < %s | \
; RUN:   FileCheck %s -check-prefix=NO-SHRINK-WRAP-STATIC

; RUN: llc -mtriple=mips-unknown-linux-gnu -enable-shrink-wrap=true \
; RUN:   -relocation-model=pic < %s | \
; RUN:   FileCheck %s -check-prefix=SHRINK-WRAP-PIC

; RUN: llc -mtriple=mips-unknown-linux-gnu -enable-shrink-wrap=false \
; RUN:   -relocation-model=pic < %s | \
; RUN:   FileCheck %s -check-prefix=NO-SHRINK-WRAP-PIC

; RUN: llc -mtriple=mips64-unknown-linux-gnu -enable-shrink-wrap=true \
; RUN:   -relocation-model=static < %s | \
; RUN:   FileCheck %s -check-prefix=SHRINK-WRAP-64-STATIC

; RUN: llc -mtriple=mips64-unknown-linux-gnu -enable-shrink-wrap=false \
; RUN:   -relocation-model=static < %s | \
; RUN:   FileCheck %s -check-prefix=NO-SHRINK-WRAP-64-STATIC

; RUN: llc -mtriple=mips64-unknown-linux-gnu -enable-shrink-wrap=true \
; RUN:   -relocation-model=pic < %s | \
; RUN:   FileCheck %s -check-prefix=SHRINK-WRAP-64-PIC

; RUN: llc -mtriple=mips64-unknown-linux-gnu -enable-shrink-wrap=false \
; RUN:   -relocation-model=pic < %s | \
; RUN:   FileCheck %s -check-prefix=NO-SHRINK-WRAP-64-PIC

declare void @f(i32 signext)

define i32 @foo(i32 signext %a) {
; SHRINK-WRAP-STATIC-LABEL: foo:
; SHRINK-WRAP-STATIC:       # %bb.0: # %entry
; SHRINK-WRAP-STATIC-NEXT:    beqz $4, $BB0_2
; SHRINK-WRAP-STATIC-NEXT:    nop
; SHRINK-WRAP-STATIC-NEXT:  # %bb.1: # %if.end
; SHRINK-WRAP-STATIC-NEXT:    addiu $sp, $sp, -24
; SHRINK-WRAP-STATIC-NEXT:    .cfi_def_cfa_offset 24
; SHRINK-WRAP-STATIC-NEXT:    sw $ra, 20($sp) # 4-byte Folded Spill
; SHRINK-WRAP-STATIC-NEXT:    .cfi_offset 31, -4
; SHRINK-WRAP-STATIC-NEXT:    jal f
; SHRINK-WRAP-STATIC-NEXT:    addiu $4, $4, 1
; SHRINK-WRAP-STATIC-NEXT:    lw $ra, 20($sp) # 4-byte Folded Reload
; SHRINK-WRAP-STATIC-NEXT:    addiu $sp, $sp, 24
; SHRINK-WRAP-STATIC-NEXT:  $BB0_2: # %return
; SHRINK-WRAP-STATIC-NEXT:    jr $ra
; SHRINK-WRAP-STATIC-NEXT:    addiu $2, $zero, 0
;
; NO-SHRINK-WRAP-STATIC-LABEL: foo:
; NO-SHRINK-WRAP-STATIC:       # %bb.0: # %entry
; NO-SHRINK-WRAP-STATIC-NEXT:    addiu $sp, $sp, -24
; NO-SHRINK-WRAP-STATIC-NEXT:    .cfi_def_cfa_offset 24
; NO-SHRINK-WRAP-STATIC-NEXT:    sw $ra, 20($sp) # 4-byte Folded Spill
; NO-SHRINK-WRAP-STATIC-NEXT:    .cfi_offset 31, -4
; NO-SHRINK-WRAP-STATIC-NEXT:    beqz $4, $BB0_2
; NO-SHRINK-WRAP-STATIC-NEXT:    nop
; NO-SHRINK-WRAP-STATIC-NEXT:  # %bb.1: # %if.end
; NO-SHRINK-WRAP-STATIC-NEXT:    jal f
; NO-SHRINK-WRAP-STATIC-NEXT:    addiu $4, $4, 1
; NO-SHRINK-WRAP-STATIC-NEXT:  $BB0_2: # %return
; NO-SHRINK-WRAP-STATIC-NEXT:    addiu $2, $zero, 0
; NO-SHRINK-WRAP-STATIC-NEXT:    lw $ra, 20($sp) # 4-byte Folded Reload
; NO-SHRINK-WRAP-STATIC-NEXT:    jr $ra
; NO-SHRINK-WRAP-STATIC-NEXT:    addiu $sp, $sp, 24
;
; SHRINK-WRAP-PIC-LABEL: foo:
; SHRINK-WRAP-PIC:       # %bb.0: # %entry
; SHRINK-WRAP-PIC-NEXT:    lui $2, %hi(_gp_disp)
; SHRINK-WRAP-PIC-NEXT:    addiu $2, $2, %lo(_gp_disp)
; SHRINK-WRAP-PIC-NEXT:    beqz $4, $BB0_2
; SHRINK-WRAP-PIC-NEXT:    addu $gp, $2, $25
; SHRINK-WRAP-PIC-NEXT:  # %bb.1: # %if.end
; SHRINK-WRAP-PIC-NEXT:    addiu $sp, $sp, -24
; SHRINK-WRAP-PIC-NEXT:    .cfi_def_cfa_offset 24
; SHRINK-WRAP-PIC-NEXT:    sw $ra, 20($sp) # 4-byte Folded Spill
; SHRINK-WRAP-PIC-NEXT:    .cfi_offset 31, -4
; SHRINK-WRAP-PIC-NEXT:    lw $25, %call16(f)($gp)
; SHRINK-WRAP-PIC-NEXT:    jalr $25
; SHRINK-WRAP-PIC-NEXT:    addiu $4, $4, 1
; SHRINK-WRAP-PIC-NEXT:    lw $ra, 20($sp) # 4-byte Folded Reload
; SHRINK-WRAP-PIC-NEXT:    addiu $sp, $sp, 24
; SHRINK-WRAP-PIC-NEXT:  $BB0_2: # %return
; SHRINK-WRAP-PIC-NEXT:    jr $ra
; SHRINK-WRAP-PIC-NEXT:    addiu $2, $zero, 0
;
; NO-SHRINK-WRAP-PIC-LABEL: foo:
; NO-SHRINK-WRAP-PIC:       # %bb.0: # %entry
; NO-SHRINK-WRAP-PIC-NEXT:    lui $2, %hi(_gp_disp)
; NO-SHRINK-WRAP-PIC-NEXT:    addiu $2, $2, %lo(_gp_disp)
; NO-SHRINK-WRAP-PIC-NEXT:    addiu $sp, $sp, -24
; NO-SHRINK-WRAP-PIC-NEXT:    .cfi_def_cfa_offset 24
; NO-SHRINK-WRAP-PIC-NEXT:    sw $ra, 20($sp) # 4-byte Folded Spill
; NO-SHRINK-WRAP-PIC-NEXT:    .cfi_offset 31, -4
; NO-SHRINK-WRAP-PIC-NEXT:    beqz $4, $BB0_2
; NO-SHRINK-WRAP-PIC-NEXT:    addu $gp, $2, $25
; NO-SHRINK-WRAP-PIC-NEXT:  # %bb.1: # %if.end
; NO-SHRINK-WRAP-PIC-NEXT:    lw $25, %call16(f)($gp)
; NO-SHRINK-WRAP-PIC-NEXT:    jalr $25
; NO-SHRINK-WRAP-PIC-NEXT:    addiu $4, $4, 1
; NO-SHRINK-WRAP-PIC-NEXT:  $BB0_2: # %return
; NO-SHRINK-WRAP-PIC-NEXT:    addiu $2, $zero, 0
; NO-SHRINK-WRAP-PIC-NEXT:    lw $ra, 20($sp) # 4-byte Folded Reload
; NO-SHRINK-WRAP-PIC-NEXT:    jr $ra
; NO-SHRINK-WRAP-PIC-NEXT:    addiu $sp, $sp, 24
;
; SHRINK-WRAP-64-STATIC-LABEL: foo:
; SHRINK-WRAP-64-STATIC:       # %bb.0: # %entry
; SHRINK-WRAP-64-STATIC-NEXT:    beqz $4, .LBB0_2
; SHRINK-WRAP-64-STATIC-NEXT:    nop
; SHRINK-WRAP-64-STATIC-NEXT:  # %bb.1: # %if.end
; SHRINK-WRAP-64-STATIC-NEXT:    daddiu $sp, $sp, -16
; SHRINK-WRAP-64-STATIC-NEXT:    .cfi_def_cfa_offset 16
; SHRINK-WRAP-64-STATIC-NEXT:    sd $ra, 8($sp) # 8-byte Folded Spill
; SHRINK-WRAP-64-STATIC-NEXT:    .cfi_offset 31, -8
; SHRINK-WRAP-64-STATIC-NEXT:    jal f
; SHRINK-WRAP-64-STATIC-NEXT:    addiu $4, $4, 1
; SHRINK-WRAP-64-STATIC-NEXT:    ld $ra, 8($sp) # 8-byte Folded Reload
; SHRINK-WRAP-64-STATIC-NEXT:    daddiu $sp, $sp, 16
; SHRINK-WRAP-64-STATIC-NEXT:  .LBB0_2: # %return
; SHRINK-WRAP-64-STATIC-NEXT:    jr $ra
; SHRINK-WRAP-64-STATIC-NEXT:    addiu $2, $zero, 0
;
; NO-SHRINK-WRAP-64-STATIC-LABEL: foo:
; NO-SHRINK-WRAP-64-STATIC:       # %bb.0: # %entry
; NO-SHRINK-WRAP-64-STATIC-NEXT:    daddiu $sp, $sp, -16
; NO-SHRINK-WRAP-64-STATIC-NEXT:    .cfi_def_cfa_offset 16
; NO-SHRINK-WRAP-64-STATIC-NEXT:    sd $ra, 8($sp) # 8-byte Folded Spill
; NO-SHRINK-WRAP-64-STATIC-NEXT:    .cfi_offset 31, -8
; NO-SHRINK-WRAP-64-STATIC-NEXT:    beqz $4, .LBB0_2
; NO-SHRINK-WRAP-64-STATIC-NEXT:    nop
; NO-SHRINK-WRAP-64-STATIC-NEXT:  # %bb.1: # %if.end
; NO-SHRINK-WRAP-64-STATIC-NEXT:    jal f
; NO-SHRINK-WRAP-64-STATIC-NEXT:    addiu $4, $4, 1
; NO-SHRINK-WRAP-64-STATIC-NEXT:  .LBB0_2: # %return
; NO-SHRINK-WRAP-64-STATIC-NEXT:    addiu $2, $zero, 0
; NO-SHRINK-WRAP-64-STATIC-NEXT:    ld $ra, 8($sp) # 8-byte Folded Reload
; NO-SHRINK-WRAP-64-STATIC-NEXT:    jr $ra
; NO-SHRINK-WRAP-64-STATIC-NEXT:    daddiu $sp, $sp, 16
;
; SHRINK-WRAP-64-PIC-LABEL: foo:
; SHRINK-WRAP-64-PIC:       # %bb.0: # %entry
; SHRINK-WRAP-64-PIC-NEXT:    lui $1, %hi(%neg(%gp_rel(foo)))
; SHRINK-WRAP-64-PIC-NEXT:    beqz $4, .LBB0_2
; SHRINK-WRAP-64-PIC-NEXT:    daddu $2, $1, $25
; SHRINK-WRAP-64-PIC-NEXT:  # %bb.1: # %if.end
; SHRINK-WRAP-64-PIC-NEXT:    daddiu $sp, $sp, -16
; SHRINK-WRAP-64-PIC-NEXT:    .cfi_def_cfa_offset 16
; SHRINK-WRAP-64-PIC-NEXT:    sd $ra, 8($sp) # 8-byte Folded Spill
; SHRINK-WRAP-64-PIC-NEXT:    sd $gp, 0($sp) # 8-byte Folded Spill
; SHRINK-WRAP-64-PIC-NEXT:    .cfi_offset 31, -8
; SHRINK-WRAP-64-PIC-NEXT:    .cfi_offset 28, -16
; SHRINK-WRAP-64-PIC-NEXT:    daddiu $gp, $2, %lo(%neg(%gp_rel(foo)))
; SHRINK-WRAP-64-PIC-NEXT:    ld $25, %call16(f)($gp)
; SHRINK-WRAP-64-PIC-NEXT:    jalr $25
; SHRINK-WRAP-64-PIC-NEXT:    addiu $4, $4, 1
; SHRINK-WRAP-64-PIC-NEXT:    ld $gp, 0($sp) # 8-byte Folded Reload
; SHRINK-WRAP-64-PIC-NEXT:    ld $ra, 8($sp) # 8-byte Folded Reload
; SHRINK-WRAP-64-PIC-NEXT:    daddiu $sp, $sp, 16
; SHRINK-WRAP-64-PIC-NEXT:  .LBB0_2: # %return
; SHRINK-WRAP-64-PIC-NEXT:    jr $ra
; SHRINK-WRAP-64-PIC-NEXT:    addiu $2, $zero, 0
;
; NO-SHRINK-WRAP-64-PIC-LABEL: foo:
; NO-SHRINK-WRAP-64-PIC:       # %bb.0: # %entry
; NO-SHRINK-WRAP-64-PIC-NEXT:    daddiu $sp, $sp, -16
; NO-SHRINK-WRAP-64-PIC-NEXT:    .cfi_def_cfa_offset 16
; NO-SHRINK-WRAP-64-PIC-NEXT:    sd $ra, 8($sp) # 8-byte Folded Spill
; NO-SHRINK-WRAP-64-PIC-NEXT:    sd $gp, 0($sp) # 8-byte Folded Spill
; NO-SHRINK-WRAP-64-PIC-NEXT:    .cfi_offset 31, -8
; NO-SHRINK-WRAP-64-PIC-NEXT:    .cfi_offset 28, -16
; NO-SHRINK-WRAP-64-PIC-NEXT:    lui $1, %hi(%neg(%gp_rel(foo)))
; NO-SHRINK-WRAP-64-PIC-NEXT:    beqz $4, .LBB0_2
; NO-SHRINK-WRAP-64-PIC-NEXT:    daddu $2, $1, $25
; NO-SHRINK-WRAP-64-PIC-NEXT:  # %bb.1: # %if.end
; NO-SHRINK-WRAP-64-PIC-NEXT:    daddiu $gp, $2, %lo(%neg(%gp_rel(foo)))
; NO-SHRINK-WRAP-64-PIC-NEXT:    ld $25, %call16(f)($gp)
; NO-SHRINK-WRAP-64-PIC-NEXT:    jalr $25
; NO-SHRINK-WRAP-64-PIC-NEXT:    addiu $4, $4, 1
; NO-SHRINK-WRAP-64-PIC-NEXT:  .LBB0_2: # %return
; NO-SHRINK-WRAP-64-PIC-NEXT:    addiu $2, $zero, 0
; NO-SHRINK-WRAP-64-PIC-NEXT:    ld $gp, 0($sp) # 8-byte Folded Reload
; NO-SHRINK-WRAP-64-PIC-NEXT:    ld $ra, 8($sp) # 8-byte Folded Reload
; NO-SHRINK-WRAP-64-PIC-NEXT:    jr $ra
; NO-SHRINK-WRAP-64-PIC-NEXT:    daddiu $sp, $sp, 16
entry:
  %cmp = icmp eq i32 %a, 0
  br i1 %cmp, label %return, label %if.end

if.end:
  %add = add nsw i32 %a, 1
  tail call void @f(i32 signext %add)
  br label %return

return:
  ret i32 0
}

; Test that long branch expansion works correctly with shrink-wrapping enabled.
define i32 @foo2(i32 signext %a) {
; SHRINK-WRAP-STATIC-LABEL: foo2:
; SHRINK-WRAP-STATIC:       # %bb.0:
; SHRINK-WRAP-STATIC-NEXT:    addiu $1, $zero, 4
; SHRINK-WRAP-STATIC-NEXT:    bne $4, $1, $BB1_2
; SHRINK-WRAP-STATIC-NEXT:    nop
; SHRINK-WRAP-STATIC-NEXT:  # %bb.1:
; SHRINK-WRAP-STATIC-NEXT:    j $BB1_3
; SHRINK-WRAP-STATIC-NEXT:    nop
; SHRINK-WRAP-STATIC-NEXT:  $BB1_2: # %if.then
; SHRINK-WRAP-STATIC-NEXT:    addiu $sp, $sp, -24
; SHRINK-WRAP-STATIC-NEXT:    .cfi_def_cfa_offset 24
; SHRINK-WRAP-STATIC-NEXT:    sw $ra, 20($sp) # 4-byte Folded Spill
; SHRINK-WRAP-STATIC-NEXT:    .cfi_offset 31, -4
; SHRINK-WRAP-STATIC-NEXT:    #APP
;
; NO-SHRINK-WRAP-STATIC-LABEL: foo2:
; NO-SHRINK-WRAP-STATIC:       # %bb.0:
; NO-SHRINK-WRAP-STATIC-NEXT:    addiu $sp, $sp, -24
; NO-SHRINK-WRAP-STATIC-NEXT:    .cfi_def_cfa_offset 24
; NO-SHRINK-WRAP-STATIC-NEXT:    sw $ra, 20($sp) # 4-byte Folded Spill
; NO-SHRINK-WRAP-STATIC-NEXT:    .cfi_offset 31, -4
; NO-SHRINK-WRAP-STATIC-NEXT:    addiu $1, $zero, 4
; NO-SHRINK-WRAP-STATIC-NEXT:    bne $4, $1, $BB1_2
; NO-SHRINK-WRAP-STATIC-NEXT:    nop
; NO-SHRINK-WRAP-STATIC-NEXT:  # %bb.1:
; NO-SHRINK-WRAP-STATIC-NEXT:    j $BB1_3
; NO-SHRINK-WRAP-STATIC-NEXT:    nop
; NO-SHRINK-WRAP-STATIC-NEXT:  $BB1_2: # %if.then
; NO-SHRINK-WRAP-STATIC-NEXT:    #APP
;
; SHRINK-WRAP-PIC-LABEL: foo2:
; SHRINK-WRAP-PIC:       # %bb.0:
; SHRINK-WRAP-PIC-NEXT:    lui $2, %hi(_gp_disp)
; SHRINK-WRAP-PIC-NEXT:    addiu $2, $2, %lo(_gp_disp)
; SHRINK-WRAP-PIC-NEXT:    addiu $1, $zero, 4
; SHRINK-WRAP-PIC-NEXT:    bne $4, $1, $BB1_3
; SHRINK-WRAP-PIC-NEXT:    addu $gp, $2, $25
; SHRINK-WRAP-PIC-NEXT:  # %bb.1:
; SHRINK-WRAP-PIC-NEXT:    addiu $sp, $sp, -8
; SHRINK-WRAP-PIC-NEXT:    sw $ra, 0($sp)
; SHRINK-WRAP-PIC-NEXT:    lui $1, %hi(($BB1_4)-($BB1_2))
; SHRINK-WRAP-PIC-NEXT:    bal $BB1_2
; SHRINK-WRAP-PIC-NEXT:    addiu $1, $1, %lo(($BB1_4)-($BB1_2))
; SHRINK-WRAP-PIC-NEXT:  $BB1_2:
; SHRINK-WRAP-PIC-NEXT:    addu $1, $ra, $1
; SHRINK-WRAP-PIC-NEXT:    lw $ra, 0($sp)
; SHRINK-WRAP-PIC-NEXT:    jr $1
; SHRINK-WRAP-PIC-NEXT:    addiu $sp, $sp, 8
; SHRINK-WRAP-PIC-NEXT:  $BB1_3: # %if.then
; SHRINK-WRAP-PIC-NEXT:    addiu $sp, $sp, -24
; SHRINK-WRAP-PIC-NEXT:    .cfi_def_cfa_offset 24
; SHRINK-WRAP-PIC-NEXT:    sw $ra, 20($sp) # 4-byte Folded Spill
; SHRINK-WRAP-PIC-NEXT:    .cfi_offset 31, -4
; SHRINK-WRAP-PIC-NEXT:    #APP
;
; NO-SHRINK-WRAP-PIC-LABEL: foo2:
; NO-SHRINK-WRAP-PIC:       # %bb.0:
; NO-SHRINK-WRAP-PIC-NEXT:    lui $2, %hi(_gp_disp)
; NO-SHRINK-WRAP-PIC-NEXT:    addiu $2, $2, %lo(_gp_disp)
; NO-SHRINK-WRAP-PIC-NEXT:    addiu $sp, $sp, -24
; NO-SHRINK-WRAP-PIC-NEXT:    .cfi_def_cfa_offset 24
; NO-SHRINK-WRAP-PIC-NEXT:    sw $ra, 20($sp) # 4-byte Folded Spill
; NO-SHRINK-WRAP-PIC-NEXT:    .cfi_offset 31, -4
; NO-SHRINK-WRAP-PIC-NEXT:    addiu $1, $zero, 4
; NO-SHRINK-WRAP-PIC-NEXT:    bne $4, $1, $BB1_3
; NO-SHRINK-WRAP-PIC-NEXT:    addu $gp, $2, $25
; NO-SHRINK-WRAP-PIC-NEXT:  # %bb.1:
; NO-SHRINK-WRAP-PIC-NEXT:    addiu $sp, $sp, -8
; NO-SHRINK-WRAP-PIC-NEXT:    sw $ra, 0($sp)
; NO-SHRINK-WRAP-PIC-NEXT:    lui $1, %hi(($BB1_4)-($BB1_2))
; NO-SHRINK-WRAP-PIC-NEXT:    bal $BB1_2
; NO-SHRINK-WRAP-PIC-NEXT:    addiu $1, $1, %lo(($BB1_4)-($BB1_2))
; NO-SHRINK-WRAP-PIC-NEXT:  $BB1_2:
; NO-SHRINK-WRAP-PIC-NEXT:    addu $1, $ra, $1
; NO-SHRINK-WRAP-PIC-NEXT:    lw $ra, 0($sp)
; NO-SHRINK-WRAP-PIC-NEXT:    jr $1
; NO-SHRINK-WRAP-PIC-NEXT:    addiu $sp, $sp, 8
; NO-SHRINK-WRAP-PIC-NEXT:  $BB1_3: # %if.then
; NO-SHRINK-WRAP-PIC-NEXT:    #APP
;
; SHRINK-WRAP-64-STATIC-LABEL: foo2:
; SHRINK-WRAP-64-STATIC:       # %bb.0:
; SHRINK-WRAP-64-STATIC-NEXT:    addiu $1, $zero, 4
; SHRINK-WRAP-64-STATIC-NEXT:    bne $4, $1, .LBB1_2
; SHRINK-WRAP-64-STATIC-NEXT:    nop
; SHRINK-WRAP-64-STATIC-NEXT:  # %bb.1:
; SHRINK-WRAP-64-STATIC-NEXT:    j .LBB1_3
; SHRINK-WRAP-64-STATIC-NEXT:    nop
; SHRINK-WRAP-64-STATIC-NEXT:  .LBB1_2: # %if.then
; SHRINK-WRAP-64-STATIC-NEXT:    daddiu $sp, $sp, -16
; SHRINK-WRAP-64-STATIC-NEXT:    .cfi_def_cfa_offset 16
; SHRINK-WRAP-64-STATIC-NEXT:    sd $ra, 8($sp) # 8-byte Folded Spill
; SHRINK-WRAP-64-STATIC-NEXT:    .cfi_offset 31, -8
; SHRINK-WRAP-64-STATIC-NEXT:    sll $4, $4, 0
; SHRINK-WRAP-64-STATIC-NEXT:    #APP
;
; NO-SHRINK-WRAP-64-STATIC-LABEL: foo2:
; NO-SHRINK-WRAP-64-STATIC:       # %bb.0:
; NO-SHRINK-WRAP-64-STATIC-NEXT:    daddiu $sp, $sp, -16
; NO-SHRINK-WRAP-64-STATIC-NEXT:    .cfi_def_cfa_offset 16
; NO-SHRINK-WRAP-64-STATIC-NEXT:    sd $ra, 8($sp) # 8-byte Folded Spill
; NO-SHRINK-WRAP-64-STATIC-NEXT:    .cfi_offset 31, -8
; NO-SHRINK-WRAP-64-STATIC-NEXT:    addiu $1, $zero, 4
; NO-SHRINK-WRAP-64-STATIC-NEXT:    bne $4, $1, .LBB1_2
; NO-SHRINK-WRAP-64-STATIC-NEXT:    nop
; NO-SHRINK-WRAP-64-STATIC-NEXT:  # %bb.1:
; NO-SHRINK-WRAP-64-STATIC-NEXT:    j .LBB1_3
; NO-SHRINK-WRAP-64-STATIC-NEXT:    nop
; NO-SHRINK-WRAP-64-STATIC-NEXT:  .LBB1_2: # %if.then
; NO-SHRINK-WRAP-64-STATIC-NEXT:    sll $4, $4, 0
; NO-SHRINK-WRAP-64-STATIC-NEXT:    #APP
;
; SHRINK-WRAP-64-PIC-LABEL: foo2:
; SHRINK-WRAP-64-PIC:       # %bb.0:
; SHRINK-WRAP-64-PIC-NEXT:    lui $1, %hi(%neg(%gp_rel(foo2)))
; SHRINK-WRAP-64-PIC-NEXT:    daddu $2, $1, $25
; SHRINK-WRAP-64-PIC-NEXT:    addiu $1, $zero, 4
; SHRINK-WRAP-64-PIC-NEXT:    bne $4, $1, .LBB1_3
; SHRINK-WRAP-64-PIC-NEXT:    nop
; SHRINK-WRAP-64-PIC-NEXT:  # %bb.1:
; SHRINK-WRAP-64-PIC-NEXT:    daddiu $sp, $sp, -16
; SHRINK-WRAP-64-PIC-NEXT:    sd $ra, 0($sp)
; SHRINK-WRAP-64-PIC-NEXT:    daddiu $1, $zero, %hi(.LBB1_4-.LBB1_2)
; SHRINK-WRAP-64-PIC-NEXT:    dsll $1, $1, 16
; SHRINK-WRAP-64-PIC-NEXT:    bal .LBB1_2
; SHRINK-WRAP-64-PIC-NEXT:    daddiu $1, $1, %lo(.LBB1_4-.LBB1_2)
; SHRINK-WRAP-64-PIC-NEXT:  .LBB1_2:
; SHRINK-WRAP-64-PIC-NEXT:    daddu $1, $ra, $1
; SHRINK-WRAP-64-PIC-NEXT:    ld $ra, 0($sp)
; SHRINK-WRAP-64-PIC-NEXT:    jr $1
; SHRINK-WRAP-64-PIC-NEXT:    daddiu $sp, $sp, 16
; SHRINK-WRAP-64-PIC-NEXT:  .LBB1_3: # %if.then
; SHRINK-WRAP-64-PIC-NEXT:    daddiu $sp, $sp, -16
; SHRINK-WRAP-64-PIC-NEXT:    .cfi_def_cfa_offset 16
; SHRINK-WRAP-64-PIC-NEXT:    sd $ra, 8($sp) # 8-byte Folded Spill
; SHRINK-WRAP-64-PIC-NEXT:    sd $gp, 0($sp) # 8-byte Folded Spill
; SHRINK-WRAP-64-PIC-NEXT:    .cfi_offset 31, -8
; SHRINK-WRAP-64-PIC-NEXT:    .cfi_offset 28, -16
; SHRINK-WRAP-64-PIC-NEXT:    daddiu $gp, $2, %lo(%neg(%gp_rel(foo2)))
; SHRINK-WRAP-64-PIC-NEXT:    sll $4, $4, 0
; SHRINK-WRAP-64-PIC-NEXT:    #APP
;
; NO-SHRINK-WRAP-64-PIC-LABEL: foo2:
; NO-SHRINK-WRAP-64-PIC:       # %bb.0:
; NO-SHRINK-WRAP-64-PIC-NEXT:    daddiu $sp, $sp, -16
; NO-SHRINK-WRAP-64-PIC-NEXT:    .cfi_def_cfa_offset 16
; NO-SHRINK-WRAP-64-PIC-NEXT:    sd $ra, 8($sp) # 8-byte Folded Spill
; NO-SHRINK-WRAP-64-PIC-NEXT:    sd $gp, 0($sp) # 8-byte Folded Spill
; NO-SHRINK-WRAP-64-PIC-NEXT:    .cfi_offset 31, -8
; NO-SHRINK-WRAP-64-PIC-NEXT:    .cfi_offset 28, -16
; NO-SHRINK-WRAP-64-PIC-NEXT:    lui $1, %hi(%neg(%gp_rel(foo2)))
; NO-SHRINK-WRAP-64-PIC-NEXT:    daddu $2, $1, $25
; NO-SHRINK-WRAP-64-PIC-NEXT:    addiu $1, $zero, 4
; NO-SHRINK-WRAP-64-PIC-NEXT:    bne $4, $1, .LBB1_3
; NO-SHRINK-WRAP-64-PIC-NEXT:    nop
; NO-SHRINK-WRAP-64-PIC-NEXT:  # %bb.1:
; NO-SHRINK-WRAP-64-PIC-NEXT:    daddiu $sp, $sp, -16
; NO-SHRINK-WRAP-64-PIC-NEXT:    sd $ra, 0($sp)
; NO-SHRINK-WRAP-64-PIC-NEXT:    daddiu $1, $zero, %hi(.LBB1_4-.LBB1_2)
; NO-SHRINK-WRAP-64-PIC-NEXT:    dsll $1, $1, 16
; NO-SHRINK-WRAP-64-PIC-NEXT:    bal .LBB1_2
; NO-SHRINK-WRAP-64-PIC-NEXT:    daddiu $1, $1, %lo(.LBB1_4-.LBB1_2)
; NO-SHRINK-WRAP-64-PIC-NEXT:  .LBB1_2:
; NO-SHRINK-WRAP-64-PIC-NEXT:    daddu $1, $ra, $1
; NO-SHRINK-WRAP-64-PIC-NEXT:    ld $ra, 0($sp)
; NO-SHRINK-WRAP-64-PIC-NEXT:    jr $1
; NO-SHRINK-WRAP-64-PIC-NEXT:    daddiu $sp, $sp, 16
; NO-SHRINK-WRAP-64-PIC-NEXT:  .LBB1_3: # %if.then
; NO-SHRINK-WRAP-64-PIC-NEXT:    daddiu $gp, $2, %lo(%neg(%gp_rel(foo2)))
; NO-SHRINK-WRAP-64-PIC-NEXT:    sll $4, $4, 0
; NO-SHRINK-WRAP-64-PIC-NEXT:    #APP
  %1 = icmp ne i32 %a, 4
  br i1 %1, label %if.then, label %if.end

if.then:
  call void asm sideeffect ".space 1048576", "~{$1}"()
  call void @f(i32 signext %a)
  br label %if.end

if.end:
  ret i32 0
}
