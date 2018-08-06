; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=x86_64-pc-linux -stackrealign -stack-alignment=32 < %s | FileCheck %s
; RUN: llc -mtriple=x86_64-pc-linux-gnux32 -stackrealign -stack-alignment=32 < %s | FileCheck -check-prefix=X32ABI %s

; This should run with NaCl as well ( -mtriple=x86_64-pc-nacl ) but currently doesn't due to PR22655

; Make sure the correct register gets set up as the base pointer
; This should be rbx for x64 and 64-bit NaCl and ebx for x32
; NACL-LABEL: base
; NACL: subq $32, %rsp
; NACL: movq %rsp, %rbx

declare i32 @helper() nounwind
define void @base() #0 {
; CHECK-LABEL: base:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rbp
; CHECK-NEXT:    movq %rsp, %rbp
; CHECK-NEXT:    pushq %rbx
; CHECK-NEXT:    andq $-32, %rsp
; CHECK-NEXT:    subq $32, %rsp
; CHECK-NEXT:    movq %rsp, %rbx
; CHECK-NEXT:    callq helper
; CHECK-NEXT:    movq %rsp, %rcx
; CHECK-NEXT:    movl %eax, %eax
; CHECK-NEXT:    leaq 31(,%rax,4), %rax
; CHECK-NEXT:    andq $-32, %rax
; CHECK-NEXT:    movq %rcx, %rdx
; CHECK-NEXT:    subq %rax, %rdx
; CHECK-NEXT:    movq %rdx, %rsp
; CHECK-NEXT:    negq %rax
; CHECK-NEXT:    movl $0, (%rcx,%rax)
; CHECK-NEXT:    leaq -8(%rbp), %rsp
; CHECK-NEXT:    popq %rbx
; CHECK-NEXT:    popq %rbp
; CHECK-NEXT:    retq
;
; X32ABI-LABEL: base:
; X32ABI:       # %bb.0: # %entry
; X32ABI-NEXT:    pushq %rbp
; X32ABI-NEXT:    movl %esp, %ebp
; X32ABI-NEXT:    pushq  %rbx
; X32ABI-NEXT:    andl $-32, %esp
; X32ABI-NEXT:    subl $32, %esp
; X32ABI-NEXT:    movl %esp, %ebx
; X32ABI-NEXT:    callq helper
; X32ABI-NEXT:    # kill: def $eax killed $eax def $rax
; X32ABI-NEXT:    movl %esp, %ecx
; X32ABI-NEXT:    leal 31(,%rax,4), %eax
; X32ABI-NEXT:    andl $-32, %eax
; X32ABI-NEXT:    movl %ecx, %edx
; X32ABI-NEXT:    subl %eax, %edx
; X32ABI-NEXT:    movl %edx, %esp
; X32ABI-NEXT:    negl %eax
; X32ABI-NEXT:    movl $0, (%ecx,%eax)
; X32ABI-NEXT:    leal -8(%ebp), %esp
; X32ABI-NEXT:    popq %rbx
; X32ABI-NEXT:    popq %rbp
; X32ABI-NEXT:    retq
entry:
  %k = call i32 @helper()
  %a = alloca i32, i32 %k, align 4
  store i32 0, i32* %a, align 4
  ret void
}

attributes #0 = { nounwind "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf"}
