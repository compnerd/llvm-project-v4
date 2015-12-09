// RUN: llvm-mc -triple=arm64 -mattr=+neon,+fullfp16 -show-encoding < %s | FileCheck %s

// Check that the assembler can handle the documented syntax for AArch64

//------------------------------------------------------------------------------
// Instructions with 2 vectors and an element
//------------------------------------------------------------------------------

        mla v0.2s, v1.2s, v2.s[2]
        mla v0.2s, v1.2s, v22.s[2]
        mla v3.4s, v8.4s, v2.s[1]
        mla v3.4s, v8.4s, v22.s[3]

// CHECK: mla	v0.2s, v1.2s, v2.s[2]   // encoding: [0x20,0x08,0x82,0x2f]
// CHECK: mla	v0.2s, v1.2s, v22.s[2]  // encoding: [0x20,0x08,0x96,0x2f]
// CHECK: mla	v3.4s, v8.4s, v2.s[1]   // encoding: [0x03,0x01,0xa2,0x6f]
// CHECK: mla	v3.4s, v8.4s, v22.s[3]  // encoding: [0x03,0x09,0xb6,0x6f]

        mla v0.4h, v1.4h, v2.h[2]
        mla v0.4h, v1.4h, v15.h[2]
        mla v0.8h, v1.8h, v2.h[7]
        mla v0.8h, v1.8h, v14.h[6]

// CHECK: mla	v0.4h, v1.4h, v2.h[2]   // encoding: [0x20,0x00,0x62,0x2f]
// CHECK: mla	v0.4h, v1.4h, v15.h[2]  // encoding: [0x20,0x00,0x6f,0x2f]
// CHECK: mla	v0.8h, v1.8h, v2.h[7]   // encoding: [0x20,0x08,0x72,0x6f]
// CHECK: mla	v0.8h, v1.8h, v14.h[6]  // encoding: [0x20,0x08,0x6e,0x6f]

        mls v0.2s, v1.2s, v2.s[2]
        mls v0.2s, v1.2s, v22.s[2]
        mls v3.4s, v8.4s, v2.s[1]
        mls v3.4s, v8.4s, v22.s[3]

// CHECK: mls	v0.2s, v1.2s, v2.s[2]   // encoding: [0x20,0x48,0x82,0x2f]
// CHECK: mls	v0.2s, v1.2s, v22.s[2]  // encoding: [0x20,0x48,0x96,0x2f]
// CHECK: mls	v3.4s, v8.4s, v2.s[1]   // encoding: [0x03,0x41,0xa2,0x6f]
// CHECK: mls	v3.4s, v8.4s, v22.s[3]  // encoding: [0x03,0x49,0xb6,0x6f]

        mls v0.4h, v1.4h, v2.h[2]
        mls v0.4h, v1.4h, v15.h[2]
        mls v0.8h, v1.8h, v2.h[7]
        mls v0.8h, v1.8h, v14.h[6]

// CHECK: mls	v0.4h, v1.4h, v2.h[2]   // encoding: [0x20,0x40,0x62,0x2f]
// CHECK: mls	v0.4h, v1.4h, v15.h[2]  // encoding: [0x20,0x40,0x6f,0x2f]
// CHECK: mls	v0.8h, v1.8h, v2.h[7]   // encoding: [0x20,0x48,0x72,0x6f]
// CHECK: mls	v0.8h, v1.8h, v14.h[6]  // encoding: [0x20,0x48,0x6e,0x6f]

        fmla v0.4h, v1.4h, v2.h[2]
        fmla v3.8h, v8.8h, v2.h[1]
        fmla v0.2s, v1.2s, v2.s[2]
        fmla v0.2s, v1.2s, v22.s[2]
        fmla v3.4s, v8.4s, v2.s[1]
        fmla v3.4s, v8.4s, v22.s[3]
        fmla v0.2d, v1.2d, v2.d[1]
        fmla v0.2d, v1.2d, v22.d[1]

// CHECK: fmla    v0.4h, v1.4h, v2.h[2]   // encoding: [0x20,0x10,0x22,0x0f]
// CHECK: fmla    v3.8h, v8.8h, v2.h[1]   // encoding: [0x03,0x11,0x12,0x4f]
// CHECK: fmla	v0.2s, v1.2s, v2.s[2]   // encoding: [0x20,0x18,0x82,0x0f]
// CHECK: fmla	v0.2s, v1.2s, v22.s[2]  // encoding: [0x20,0x18,0x96,0x0f]
// CHECK: fmla	v3.4s, v8.4s, v2.s[1]   // encoding: [0x03,0x11,0xa2,0x4f]
// CHECK: fmla	v3.4s, v8.4s, v22.s[3]  // encoding: [0x03,0x19,0xb6,0x4f]
// CHECK: fmla	v0.2d, v1.2d, v2.d[1]   // encoding: [0x20,0x18,0xc2,0x4f]
// CHECK: fmla	v0.2d, v1.2d, v22.d[1]  // encoding: [0x20,0x18,0xd6,0x4f]

        fmls v0.4h, v1.4h, v2.h[2]
        fmls v3.8h, v8.8h, v2.h[1]
        fmls v0.2s, v1.2s, v2.s[2]
        fmls v0.2s, v1.2s, v22.s[2]
        fmls v3.4s, v8.4s, v2.s[1]
        fmls v3.4s, v8.4s, v22.s[3]
        fmls v0.2d, v1.2d, v2.d[1]
        fmls v0.2d, v1.2d, v22.d[1]

// CHECK: fmls    v0.4h, v1.4h, v2.h[2]   // encoding: [0x20,0x50,0x22,0x0f]
// CHECK: fmls    v3.8h, v8.8h, v2.h[1]   // encoding: [0x03,0x51,0x12,0x4f]
// CHECK: fmls	v0.2s, v1.2s, v2.s[2]   // encoding: [0x20,0x58,0x82,0x0f]
// CHECK: fmls	v0.2s, v1.2s, v22.s[2]  // encoding: [0x20,0x58,0x96,0x0f]
// CHECK: fmls	v3.4s, v8.4s, v2.s[1]   // encoding: [0x03,0x51,0xa2,0x4f]
// CHECK: fmls	v3.4s, v8.4s, v22.s[3]  // encoding: [0x03,0x59,0xb6,0x4f]
// CHECK: fmls	v0.2d, v1.2d, v2.d[1]   // encoding: [0x20,0x58,0xc2,0x4f]
// CHECK: fmls	v0.2d, v1.2d, v22.d[1]  // encoding: [0x20,0x58,0xd6,0x4f]

        smlal v0.4s, v1.4h, v2.h[2]
        smlal v0.2d, v1.2s, v2.s[2]
        smlal v0.2d, v1.2s, v22.s[2]
        smlal2 v0.4s, v1.8h, v1.h[2]
        smlal2 v0.2d, v1.4s, v1.s[2]
        smlal2 v0.2d, v1.4s, v22.s[2]

// CHECK: smlal	v0.4s, v1.4h, v2.h[2]   // encoding: [0x20,0x20,0x62,0x0f]
// CHECK: smlal	v0.2d, v1.2s, v2.s[2]   // encoding: [0x20,0x28,0x82,0x0f]
// CHECK: smlal	v0.2d, v1.2s, v22.s[2]  // encoding: [0x20,0x28,0x96,0x0f]
// CHECK: smlal2	v0.4s, v1.8h, v1.h[2]   // encoding: [0x20,0x20,0x61,0x4f]
// CHECK: smlal2	v0.2d, v1.4s, v1.s[2]   // encoding: [0x20,0x28,0x81,0x4f]
// CHECK: smlal2	v0.2d, v1.4s, v22.s[2]  // encoding: [0x20,0x28,0x96,0x4f]

        smlsl v0.4s, v1.4h, v2.h[2]
        smlsl v0.2d, v1.2s, v2.s[2]
        smlsl v0.2d, v1.2s, v22.s[2]
        smlsl2 v0.4s, v1.8h, v1.h[2]
        smlsl2 v0.2d, v1.4s, v1.s[2]
        smlsl2 v0.2d, v1.4s, v22.s[2]

// CHECK: smlsl	v0.4s, v1.4h, v2.h[2]   // encoding: [0x20,0x60,0x62,0x0f]
// CHECK: smlsl	v0.2d, v1.2s, v2.s[2]   // encoding: [0x20,0x68,0x82,0x0f]
// CHECK: smlsl	v0.2d, v1.2s, v22.s[2]  // encoding: [0x20,0x68,0x96,0x0f]
// CHECK: smlsl2	v0.4s, v1.8h, v1.h[2]   // encoding: [0x20,0x60,0x61,0x4f]
// CHECK: smlsl2	v0.2d, v1.4s, v1.s[2]   // encoding: [0x20,0x68,0x81,0x4f]
// CHECK: smlsl2	v0.2d, v1.4s, v22.s[2]  // encoding: [0x20,0x68,0x96,0x4f]

        sqdmlal v0.4s, v1.4h, v2.h[2]
        sqdmlal v0.2d, v1.2s, v2.s[2]
        sqdmlal v0.2d, v1.2s, v22.s[2]
        sqdmlal2 v0.4s, v1.8h, v1.h[2]
        sqdmlal2 v0.2d, v1.4s, v1.s[2]
        sqdmlal2 v0.2d, v1.4s, v22.s[2]

// CHECK: sqdmlal	v0.4s, v1.4h, v2.h[2]   // encoding: [0x20,0x30,0x62,0x0f]
// CHECK: sqdmlal	v0.2d, v1.2s, v2.s[2]   // encoding: [0x20,0x38,0x82,0x0f]
// CHECK: sqdmlal	v0.2d, v1.2s, v22.s[2]  // encoding: [0x20,0x38,0x96,0x0f]
// CHECK: sqdmlal2	v0.4s, v1.8h, v1.h[2] // encoding: [0x20,0x30,0x61,0x4f]
// CHECK: sqdmlal2	v0.2d, v1.4s, v1.s[2] // encoding: [0x20,0x38,0x81,0x4f]
// CHECK: sqdmlal2	v0.2d, v1.4s, v22.s[2] // encoding: [0x20,0x38,0x96,0x4f]

        umlal v0.4s, v1.4h, v2.h[2]
        umlal v0.2d, v1.2s, v2.s[2]
        umlal v0.2d, v1.2s, v22.s[2]
        umlal2 v0.4s, v1.8h, v1.h[2]
        umlal2 v0.2d, v1.4s, v1.s[2]
        umlal2 v0.2d, v1.4s, v22.s[2]

// CHECK: umlal	v0.4s, v1.4h, v2.h[2]   // encoding: [0x20,0x20,0x62,0x2f]
// CHECK: umlal	v0.2d, v1.2s, v2.s[2]   // encoding: [0x20,0x28,0x82,0x2f]
// CHECK: umlal	v0.2d, v1.2s, v22.s[2]  // encoding: [0x20,0x28,0x96,0x2f]
// CHECK: umlal2	v0.4s, v1.8h, v1.h[2]   // encoding: [0x20,0x20,0x61,0x6f]
// CHECK: umlal2	v0.2d, v1.4s, v1.s[2]   // encoding: [0x20,0x28,0x81,0x6f]
// CHECK: umlal2	v0.2d, v1.4s, v22.s[2]  // encoding: [0x20,0x28,0x96,0x6f]

        umlsl v0.4s, v1.4h, v2.h[2]
        umlsl v0.2d, v1.2s, v2.s[2]
        umlsl v0.2d, v1.2s, v22.s[2]
        umlsl2 v0.4s, v1.8h, v1.h[2]
        umlsl2 v0.2d, v1.4s, v1.s[2]
        umlsl2 v0.2d, v1.4s, v22.s[2]

// CHECK: umlsl	v0.4s, v1.4h, v2.h[2]   // encoding: [0x20,0x60,0x62,0x2f]
// CHECK: umlsl	v0.2d, v1.2s, v2.s[2]   // encoding: [0x20,0x68,0x82,0x2f]
// CHECK: umlsl	v0.2d, v1.2s, v22.s[2]  // encoding: [0x20,0x68,0x96,0x2f]
// CHECK: umlsl2	v0.4s, v1.8h, v1.h[2]   // encoding: [0x20,0x60,0x61,0x6f]
// CHECK: umlsl2	v0.2d, v1.4s, v1.s[2]   // encoding: [0x20,0x68,0x81,0x6f]
// CHECK: umlsl2	v0.2d, v1.4s, v22.s[2]  // encoding: [0x20,0x68,0x96,0x6f]

        sqdmlsl v0.4s, v1.4h, v2.h[2]
        sqdmlsl v0.2d, v1.2s, v2.s[2]
        sqdmlsl v0.2d, v1.2s, v22.s[2]
        sqdmlsl2 v0.4s, v1.8h, v1.h[2]
        sqdmlsl2 v0.2d, v1.4s, v1.s[2]
        sqdmlsl2 v0.2d, v1.4s, v22.s[2]

// CHECK: sqdmlsl	v0.4s, v1.4h, v2.h[2]   // encoding: [0x20,0x70,0x62,0x0f]
// CHECK: sqdmlsl	v0.2d, v1.2s, v2.s[2]   // encoding: [0x20,0x78,0x82,0x0f]
// CHECK: sqdmlsl	v0.2d, v1.2s, v22.s[2]  // encoding: [0x20,0x78,0x96,0x0f]
// CHECK: sqdmlsl2	v0.4s, v1.8h, v1.h[2] // encoding: [0x20,0x70,0x61,0x4f]
// CHECK: sqdmlsl2	v0.2d, v1.4s, v1.s[2] // encoding: [0x20,0x78,0x81,0x4f]
// CHECK: sqdmlsl2	v0.2d, v1.4s, v22.s[2] // encoding: [0x20,0x78,0x96,0x4f]

        mul v0.4h, v1.4h, v2.h[2]
        mul v0.8h, v1.8h, v2.h[2]
        mul v0.2s, v1.2s, v2.s[2]
        mul v0.2s, v1.2s, v22.s[2]
        mul v0.4s, v1.4s, v2.s[2]
        mul v0.4s, v1.4s, v22.s[2]

// CHECK: mul	v0.4h, v1.4h, v2.h[2]   // encoding: [0x20,0x80,0x62,0x0f]
// CHECK: mul	v0.8h, v1.8h, v2.h[2]   // encoding: [0x20,0x80,0x62,0x4f]
// CHECK: mul	v0.2s, v1.2s, v2.s[2]   // encoding: [0x20,0x88,0x82,0x0f]
// CHECK: mul	v0.2s, v1.2s, v22.s[2]  // encoding: [0x20,0x88,0x96,0x0f]
// CHECK: mul	v0.4s, v1.4s, v2.s[2]   // encoding: [0x20,0x88,0x82,0x4f]
// CHECK: mul	v0.4s, v1.4s, v22.s[2]  // encoding: [0x20,0x88,0x96,0x4f]

        fmul v0.4h, v1.4h, v2.h[2]
        fmul v0.8h, v1.8h, v2.h[2]
        fmul v0.2s, v1.2s, v2.s[2]
        fmul v0.2s, v1.2s, v22.s[2]
        fmul v0.4s, v1.4s, v2.s[2]
        fmul v0.4s, v1.4s, v22.s[2]
        fmul v0.2d, v1.2d, v2.d[1]
        fmul v0.2d, v1.2d, v22.d[1]

// CHECK: fmul    v0.4h, v1.4h, v2.h[2]   // encoding: [0x20,0x90,0x22,0x0f]
// CHECK: fmul    v0.8h, v1.8h, v2.h[2]   // encoding: [0x20,0x90,0x22,0x4f]
// CHECK: fmul	v0.2s, v1.2s, v2.s[2]   // encoding: [0x20,0x98,0x82,0x0f]
// CHECK: fmul	v0.2s, v1.2s, v22.s[2]  // encoding: [0x20,0x98,0x96,0x0f]
// CHECK: fmul	v0.4s, v1.4s, v2.s[2]   // encoding: [0x20,0x98,0x82,0x4f]
// CHECK: fmul	v0.4s, v1.4s, v22.s[2]  // encoding: [0x20,0x98,0x96,0x4f]
// CHECK: fmul	v0.2d, v1.2d, v2.d[1]   // encoding: [0x20,0x98,0xc2,0x4f]
// CHECK: fmul	v0.2d, v1.2d, v22.d[1]  // encoding: [0x20,0x98,0xd6,0x4f]

        fmulx v0.4h, v1.4h, v2.h[2]
        fmulx v0.8h, v1.8h, v2.h[2]
        fmulx v0.2s, v1.2s, v2.s[2]
        fmulx v0.2s, v1.2s, v22.s[2]
        fmulx v0.4s, v1.4s, v2.s[2]
        fmulx v0.4s, v1.4s, v22.s[2]
        fmulx v0.2d, v1.2d, v2.d[1]
        fmulx v0.2d, v1.2d, v22.d[1]

// CHECK: fmulx   v0.4h, v1.4h, v2.h[2]   // encoding: [0x20,0x90,0x22,0x2f]
// CHECK: fmulx   v0.8h, v1.8h, v2.h[2]   // encoding: [0x20,0x90,0x22,0x6f]
// CHECK: fmulx	v0.2s, v1.2s, v2.s[2]   // encoding: [0x20,0x98,0x82,0x2f]
// CHECK: fmulx	v0.2s, v1.2s, v22.s[2]  // encoding: [0x20,0x98,0x96,0x2f]
// CHECK: fmulx	v0.4s, v1.4s, v2.s[2]   // encoding: [0x20,0x98,0x82,0x6f]
// CHECK: fmulx	v0.4s, v1.4s, v22.s[2]  // encoding: [0x20,0x98,0x96,0x6f]
// CHECK: fmulx	v0.2d, v1.2d, v2.d[1]   // encoding: [0x20,0x98,0xc2,0x6f]
// CHECK: fmulx	v0.2d, v1.2d, v22.d[1]  // encoding: [0x20,0x98,0xd6,0x6f]

        smull v0.4s, v1.4h, v2.h[2]
        smull v0.2d, v1.2s, v2.s[2]
        smull v0.2d, v1.2s, v22.s[2]
        smull2 v0.4s, v1.8h, v2.h[2]
        smull2 v0.2d, v1.4s, v2.s[2]
        smull2 v0.2d, v1.4s, v22.s[2]

// CHECK: smull	v0.4s, v1.4h, v2.h[2]   // encoding: [0x20,0xa0,0x62,0x0f]
// CHECK: smull	v0.2d, v1.2s, v2.s[2]   // encoding: [0x20,0xa8,0x82,0x0f]
// CHECK: smull	v0.2d, v1.2s, v22.s[2]  // encoding: [0x20,0xa8,0x96,0x0f]
// CHECK: smull2	v0.4s, v1.8h, v2.h[2]   // encoding: [0x20,0xa0,0x62,0x4f]
// CHECK: smull2	v0.2d, v1.4s, v2.s[2]   // encoding: [0x20,0xa8,0x82,0x4f]
// CHECK: smull2	v0.2d, v1.4s, v22.s[2]  // encoding: [0x20,0xa8,0x96,0x4f]

        umull v0.4s, v1.4h, v2.h[2]
        umull v0.2d, v1.2s, v2.s[2]
        umull v0.2d, v1.2s, v22.s[2]
        umull2 v0.4s, v1.8h, v2.h[2]
        umull2 v0.2d, v1.4s, v2.s[2]
        umull2 v0.2d, v1.4s, v22.s[2]

// CHECK: umull	v0.4s, v1.4h, v2.h[2]   // encoding: [0x20,0xa0,0x62,0x2f]
// CHECK: umull	v0.2d, v1.2s, v2.s[2]   // encoding: [0x20,0xa8,0x82,0x2f]
// CHECK: umull	v0.2d, v1.2s, v22.s[2]  // encoding: [0x20,0xa8,0x96,0x2f]
// CHECK: umull2	v0.4s, v1.8h, v2.h[2]   // encoding: [0x20,0xa0,0x62,0x6f]
// CHECK: umull2	v0.2d, v1.4s, v2.s[2]   // encoding: [0x20,0xa8,0x82,0x6f]
// CHECK: umull2	v0.2d, v1.4s, v22.s[2]  // encoding: [0x20,0xa8,0x96,0x6f]

        sqdmull v0.4s, v1.4h, v2.h[2]
        sqdmull v0.2d, v1.2s, v2.s[2]
        sqdmull v0.2d, v1.2s, v22.s[2]
        sqdmull2 v0.4s, v1.8h, v2.h[2]
        sqdmull2 v0.2d, v1.4s, v2.s[2]
        sqdmull2 v0.2d, v1.4s, v22.s[2]

// CHECK: sqdmull	v0.4s, v1.4h, v2.h[2]   // encoding: [0x20,0xb0,0x62,0x0f]
// CHECK: sqdmull	v0.2d, v1.2s, v2.s[2]   // encoding: [0x20,0xb8,0x82,0x0f]
// CHECK: sqdmull	v0.2d, v1.2s, v22.s[2]  // encoding: [0x20,0xb8,0x96,0x0f]
// CHECK: sqdmull2	v0.4s, v1.8h, v2.h[2] // encoding: [0x20,0xb0,0x62,0x4f]
// CHECK: sqdmull2	v0.2d, v1.4s, v2.s[2] // encoding: [0x20,0xb8,0x82,0x4f]
// CHECK: sqdmull2	v0.2d, v1.4s, v22.s[2] // encoding: [0x20,0xb8,0x96,0x4f]

        sqdmulh v0.4h, v1.4h, v2.h[2]
        sqdmulh v0.8h, v1.8h, v2.h[2]
        sqdmulh v0.2s, v1.2s, v2.s[2]
        sqdmulh v0.2s, v1.2s, v22.s[2]
        sqdmulh v0.4s, v1.4s, v2.s[2]
        sqdmulh v0.4s, v1.4s, v22.s[2]

// CHECK: sqdmulh	v0.4h, v1.4h, v2.h[2]   // encoding: [0x20,0xc0,0x62,0x0f]
// CHECK: sqdmulh	v0.8h, v1.8h, v2.h[2]   // encoding: [0x20,0xc0,0x62,0x4f]
// CHECK: sqdmulh	v0.2s, v1.2s, v2.s[2]   // encoding: [0x20,0xc8,0x82,0x0f]
// CHECK: sqdmulh	v0.2s, v1.2s, v22.s[2]  // encoding: [0x20,0xc8,0x96,0x0f]
// CHECK: sqdmulh	v0.4s, v1.4s, v2.s[2]   // encoding: [0x20,0xc8,0x82,0x4f]
// CHECK: sqdmulh	v0.4s, v1.4s, v22.s[2]  // encoding: [0x20,0xc8,0x96,0x4f]

        sqrdmulh v0.4h, v1.4h, v2.h[2]
        sqrdmulh v0.8h, v1.8h, v2.h[2]
        sqrdmulh v0.2s, v1.2s, v2.s[2]
        sqrdmulh v0.2s, v1.2s, v22.s[2]
        sqrdmulh v0.4s, v1.4s, v2.s[2]
        sqrdmulh v0.4s, v1.4s, v22.s[2]

// CHECK: sqrdmulh	v0.4h, v1.4h, v2.h[2] // encoding: [0x20,0xd0,0x62,0x0f]
// CHECK: sqrdmulh	v0.8h, v1.8h, v2.h[2] // encoding: [0x20,0xd0,0x62,0x4f]
// CHECK: sqrdmulh	v0.2s, v1.2s, v2.s[2] // encoding: [0x20,0xd8,0x82,0x0f]
// CHECK: sqrdmulh	v0.2s, v1.2s, v22.s[2] // encoding: [0x20,0xd8,0x96,0x0f]
// CHECK: sqrdmulh	v0.4s, v1.4s, v2.s[2] // encoding: [0x20,0xd8,0x82,0x4f]
// CHECK: sqrdmulh	v0.4s, v1.4s, v22.s[2] // encoding: [0x20,0xd8,0x96,0x4f]
