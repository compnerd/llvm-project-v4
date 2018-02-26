// RUN: llvm-mc -triple x86_64-unknown-unknown -mattr=+shstk --show-encoding %s | FileCheck %s

// CHECK: incsspd %r13d
// CHECK: # encoding: [0xf3,0x41,0x0f,0xae,0xed]
          incsspd %r13d

// CHECK: incsspq %r15
// CHECK: # encoding: [0xf3,0x49,0x0f,0xae,0xef]
          incsspq %r15

// CHECK: rdsspq %r15
// CHECK: # encoding: [0xf3,0x49,0x0f,0x1e,0xcf]
          rdsspq %r15

// CHECK: rdsspd %r13d
// CHECK: # encoding: [0xf3,0x41,0x0f,0x1e,0xcd]
          rdsspd %r13d

// CHECK: saveprevssp
// CHECK: # encoding: [0xf3,0x0f,0x01,0xea]
          saveprevssp

// CHECK: rstorssp 485498096
// CHECK: # encoding: [0xf3,0x0f,0x01,0x2c,0x25,0xf0,0x1c,0xf0,0x1c]
          rstorssp 485498096

// CHECK: rstorssp (%rdx)
// CHECK: # encoding: [0xf3,0x0f,0x01,0x2a]
          rstorssp (%rdx)

// CHECK: rstorssp 64(%rdx)
// CHECK: # encoding: [0xf3,0x0f,0x01,0x6a,0x40]
          rstorssp 64(%rdx)

// CHECK: rstorssp 64(%rdx,%rax)
// CHECK: # encoding: [0xf3,0x0f,0x01,0x6c,0x02,0x40]
          rstorssp 64(%rdx,%rax)

// CHECK: rstorssp 64(%rdx,%rax,4)
// CHECK: # encoding: [0xf3,0x0f,0x01,0x6c,0x82,0x40]
          rstorssp 64(%rdx,%rax,4)

// CHECK: rstorssp -64(%rdx,%rax,4)
// CHECK: # encoding: [0xf3,0x0f,0x01,0x6c,0x82,0xc0]
          rstorssp -64(%rdx,%rax,4)

// CHECK: wrssq %r15, 485498096
// CHECK: # encoding: [0x4c,0x0f,0x38,0xf6,0x3c,0x25,0xf0,0x1c,0xf0,0x1c]
          wrssq %r15, 485498096

// CHECK: wrssq %r15, (%rdx)
// CHECK: # encoding: [0x4c,0x0f,0x38,0xf6,0x3a]
          wrssq %r15, (%rdx)

// CHECK: wrssq %r15, 64(%rdx)
// CHECK: # encoding: [0x4c,0x0f,0x38,0xf6,0x7a,0x40]
          wrssq %r15, 64(%rdx)

// CHECK: wrssq %r15, 64(%rdx,%rax)
// CHECK: # encoding: [0x4c,0x0f,0x38,0xf6,0x7c,0x02,0x40]
          wrssq %r15, 64(%rdx,%rax)

// CHECK: wrssq %r15, 64(%rdx,%rax,4)
// CHECK: # encoding: [0x4c,0x0f,0x38,0xf6,0x7c,0x82,0x40]
          wrssq %r15, 64(%rdx,%rax,4)

// CHECK: wrssq %r15, -64(%rdx,%rax,4)
// CHECK: # encoding: [0x4c,0x0f,0x38,0xf6,0x7c,0x82,0xc0]
          wrssq %r15, -64(%rdx,%rax,4)

// CHECK: wrssd %r13d, 485498096
// CHECK: # encoding: [0x44,0x0f,0x38,0xf6,0x2c,0x25,0xf0,0x1c,0xf0,0x1c]
          wrssd %r13d, 485498096

// CHECK: wrssd %r13d, (%rdx)
// CHECK: # encoding: [0x44,0x0f,0x38,0xf6,0x2a]
          wrssd %r13d, (%rdx)

// CHECK: wrssd %r13d, 64(%rdx)
// CHECK: # encoding: [0x44,0x0f,0x38,0xf6,0x6a,0x40]
          wrssd %r13d, 64(%rdx)

// CHECK: wrssd %r13d, 64(%rdx,%rax)
// CHECK: # encoding: [0x44,0x0f,0x38,0xf6,0x6c,0x02,0x40]
          wrssd %r13d, 64(%rdx,%rax)

// CHECK: wrssd %r13d, 64(%rdx,%rax,4)
// CHECK: # encoding: [0x44,0x0f,0x38,0xf6,0x6c,0x82,0x40]
          wrssd %r13d, 64(%rdx,%rax,4)

// CHECK: wrssd %r13d, -64(%rdx,%rax,4)
// CHECK: # encoding: [0x44,0x0f,0x38,0xf6,0x6c,0x82,0xc0]
          wrssd %r13d, -64(%rdx,%rax,4)

// CHECK: wrussd %r13d, 485498096
// CHECK: # encoding: [0x66,0x44,0x0f,0x38,0xf5,0x2c,0x25,0xf0,0x1c,0xf0,0x1c]
          wrussd %r13d, 485498096

// CHECK: wrussd %r13d, (%rdx)
// CHECK: # encoding: [0x66,0x44,0x0f,0x38,0xf5,0x2a]
          wrussd %r13d, (%rdx)

// CHECK: wrussd %r13d, 64(%rdx)
// CHECK: # encoding: [0x66,0x44,0x0f,0x38,0xf5,0x6a,0x40]
          wrussd %r13d, 64(%rdx)

// CHECK: wrussd %r13d, 64(%rdx,%rax)
// CHECK: # encoding: [0x66,0x44,0x0f,0x38,0xf5,0x6c,0x02,0x40]
          wrussd %r13d, 64(%rdx,%rax)

// CHECK: wrussd %r13d, 64(%rdx,%rax,4)
// CHECK: # encoding: [0x66,0x44,0x0f,0x38,0xf5,0x6c,0x82,0x40]
          wrussd %r13d, 64(%rdx,%rax,4)

// CHECK: wrussd %r13d, -64(%rdx,%rax,4)
// CHECK: # encoding: [0x66,0x44,0x0f,0x38,0xf5,0x6c,0x82,0xc0]
          wrussd %r13d, -64(%rdx,%rax,4)

// CHECK: wrussq %r15, 485498096
// CHECK: # encoding: [0x66,0x4c,0x0f,0x38,0xf5,0x3c,0x25,0xf0,0x1c,0xf0,0x1c]
          wrussq %r15, 485498096

// CHECK: wrussq %r15, (%rdx)
// CHECK: # encoding: [0x66,0x4c,0x0f,0x38,0xf5,0x3a]
          wrussq %r15, (%rdx)

// CHECK: wrussq %r15, 64(%rdx)
// CHECK: # encoding: [0x66,0x4c,0x0f,0x38,0xf5,0x7a,0x40]
          wrussq %r15, 64(%rdx)

// CHECK: wrussq %r15, 64(%rdx,%rax)
// CHECK: # encoding: [0x66,0x4c,0x0f,0x38,0xf5,0x7c,0x02,0x40]
          wrussq %r15, 64(%rdx,%rax)

// CHECK: wrussq %r15, 64(%rdx,%rax,4)
// CHECK: # encoding: [0x66,0x4c,0x0f,0x38,0xf5,0x7c,0x82,0x40]
          wrussq %r15, 64(%rdx,%rax,4)

// CHECK: wrussq %r15, -64(%rdx,%rax,4)
// CHECK: # encoding: [0x66,0x4c,0x0f,0x38,0xf5,0x7c,0x82,0xc0]
          wrussq %r15, -64(%rdx,%rax,4)

// CHECK: clrssbsy 485498096
// CHECK: # encoding: [0xf3,0x0f,0xae,0x34,0x25,0xf0,0x1c,0xf0,0x1c]
          clrssbsy 485498096

// CHECK: clrssbsy (%rdx)
// CHECK: # encoding: [0xf3,0x0f,0xae,0x32]
          clrssbsy (%rdx)

// CHECK: clrssbsy 64(%rdx)
// CHECK: # encoding: [0xf3,0x0f,0xae,0x72,0x40]
          clrssbsy 64(%rdx)

// CHECK: clrssbsy 64(%rdx,%rax)
// CHECK: # encoding: [0xf3,0x0f,0xae,0x74,0x02,0x40]
          clrssbsy 64(%rdx,%rax)

// CHECK: clrssbsy 64(%rdx,%rax,4)
// CHECK: # encoding: [0xf3,0x0f,0xae,0x74,0x82,0x40]
          clrssbsy 64(%rdx,%rax,4)

// CHECK: clrssbsy -64(%rdx,%rax,4)
// CHECK: # encoding: [0xf3,0x0f,0xae,0x74,0x82,0xc0]
          clrssbsy -64(%rdx,%rax,4)

// CHECK: setssbsy
// CHECK: # encoding: [0xf3,0x0f,0x01,0xe8]
          setssbsy
