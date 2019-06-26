// RUN: llvm-mc -arch=amdgcn -mcpu=gfx1010 -show-encoding %s | FileCheck %s --check-prefix=GFX10
// RUN: llvm-mc -arch=amdgcn -mcpu=gfx1010 -filetype=obj %s | llvm-objdump -disassemble -mcpu=gfx1010 - | FileCheck %s --check-prefix=BIN
	s_getpc_b64 s[0:1]
	s_cbranch_vccnz BB0_1
// GFX10: s_cbranch_vccnz BB0_1           ; encoding: [A,A,0x87,0xbf]
// GFX10-NEXT: ;   fixup A - offset: 0, value: BB0_1, kind: fixup_si_sopp_br
// BIN: s_cbranch_vccnz BB0_1 // 000000000004: BF870040
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
	s_nop 0
BB0_1:
	s_nop 0
	s_endpgm
