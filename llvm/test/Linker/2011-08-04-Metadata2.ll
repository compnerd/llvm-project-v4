; This file is used by 2011-08-04-Metadata.ll, so it doesn't actually do anything itself
;
; RUN: true

source_filename = "test/Linker/2011-08-04-Metadata2.ll"
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64"
target triple = "x86_64-apple-macosx10.7.0"

@x = internal global i32 0, align 4, !dbg !0

; Function Attrs: nounwind ssp uwtable
define void @bar() #0 !dbg !8 {
entry:
  store i32 1, i32* @x, align 4, !dbg !11
  ret void, !dbg !11
}

attributes #0 = { nounwind ssp uwtable }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!7}

!0 = !DIGlobalVariableExpression(var: !1)
!1 = !DIGlobalVariable(name: "x", scope: !2, file: !3, line: 1, type: !6, isLocal: true, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "clang version 3.0 ()", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !4, globals: !5)
!3 = !DIFile(filename: "/tmp/two.c", directory: "/Volumes/Lalgate/Slate/D")
!4 = !{}
!5 = !{!0}
!6 = !DIBasicType(name: "int", size: 32, align: 32, encoding: DW_ATE_signed)
!7 = !{i32 1, !"Debug Info Version", i32 3}
!8 = distinct !DISubprogram(name: "bar", scope: !3, file: !3, line: 2, type: !9, isLocal: false, isDefinition: true, virtualIndex: 6, isOptimized: false, unit: !2)
!9 = !DISubroutineType(types: !10)
!10 = !{null}
!11 = !DILocation(line: 2, column: 14, scope: !12)
!12 = distinct !DILexicalBlock(scope: !8, file: !3, line: 2, column: 12)

