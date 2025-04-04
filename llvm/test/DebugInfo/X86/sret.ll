; RUN: llc -split-dwarf-file=foo.dwo -O0 %s -mtriple=x86_64-unknown-linux-gnu -filetype=obj -o %t
; RUN: llvm-dwarfdump -debug-info %t | FileCheck %s --check-prefix=CHECK-DWO

; Based on the debuginfo-tests/sret.cpp code.

; CHECK-DWO: DW_AT_GNU_dwo_id (0x044dcdf3d75b11a1)
; CHECK-DWO: DW_AT_GNU_dwo_id (0x044dcdf3d75b11a1)

; RUN: llc -O0 -fast-isel=true -mtriple=x86_64-apple-darwin -filetype=obj -o - %s | llvm-dwarfdump -debug-info - | FileCheck -check-prefixes=CHECK,FASTISEL %s
; RUN: llc -O0 -fast-isel=false -mtriple=x86_64-apple-darwin -filetype=obj -o - %s | llvm-dwarfdump -debug-info - | FileCheck -check-prefixes=CHECK,SDAG %s


; CHECK: _ZN1B9AInstanceEv
; CHECK: DW_TAG_variable
; CHECK-NEXT:   DW_AT_location (0x00000000
; FASTISEL-NEXT:     [{{.*}}, {{.*}}): DW_OP_breg6 RBP-32, DW_OP_deref
; FASTISEL-NEXT:     [{{.*}}, {{.*}}): DW_OP_breg5 RDI+0
; FASTISEL-NEXT:     [{{.*}}, {{.*}}): DW_OP_breg6 RBP-32, DW_OP_deref)
; SDAG-NEXT:     [{{.*}}, {{.*}}): DW_OP_breg5 RDI+0
; SDAG-NEXT:     [{{.*}}, {{.*}}): DW_OP_breg6 RBP-32, DW_OP_deref)
; CHECK-NEXT:   DW_AT_name {{.*}}"a"

%class.A = type { ptr, i32 }
%class.B = type { i8 }

@_ZTV1A = linkonce_odr unnamed_addr constant [4 x ptr] [ptr null, ptr @_ZTI1A, ptr @_ZN1AD2Ev, ptr @_ZN1AD0Ev]
@_ZTVN10__cxxabiv117__class_type_infoE = external global ptr
@_ZTS1A = linkonce_odr constant [3 x i8] c"1A\00"
@_ZTI1A = linkonce_odr constant { ptr, ptr } { ptr getelementptr inbounds (ptr, ptr @_ZTVN10__cxxabiv117__class_type_infoE, i64 2), ptr @_ZTS1A }

@_ZN1AC1Ei = alias void (ptr, i32), ptr @_ZN1AC2Ei
@_ZN1AC1ERKS_ = alias void (ptr, ptr), ptr @_ZN1AC2ERKS_

; Function Attrs: nounwind uwtable
define void @_ZN1AC2Ei(ptr %this, i32 %i) unnamed_addr #0 align 2 !dbg !49 {
entry:
  %this.addr = alloca ptr, align 8
  %i.addr = alloca i32, align 4
  store ptr %this, ptr %this.addr, align 8
  call void @llvm.dbg.declare(metadata ptr %this.addr, metadata !67, metadata !DIExpression()), !dbg !69
  store i32 %i, ptr %i.addr, align 4
  call void @llvm.dbg.declare(metadata ptr %i.addr, metadata !70, metadata !DIExpression()), !dbg !71
  %this1 = load ptr, ptr %this.addr
  store ptr getelementptr inbounds ([4 x ptr], ptr @_ZTV1A, i64 0, i64 2), ptr %this1, !dbg !72
  %m_int = getelementptr inbounds %class.A, ptr %this1, i32 0, i32 1, !dbg !72
  %0 = load i32, ptr %i.addr, align 4, !dbg !72
  store i32 %0, ptr %m_int, align 4, !dbg !72
  ret void, !dbg !73
}

; Function Attrs: nounwind readnone
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: nounwind uwtable
define void @_ZN1AC2ERKS_(ptr %this, ptr %rhs) unnamed_addr #0 align 2 !dbg !50 {
entry:
  %this.addr = alloca ptr, align 8
  %rhs.addr = alloca ptr, align 8
  store ptr %this, ptr %this.addr, align 8
  call void @llvm.dbg.declare(metadata ptr %this.addr, metadata !74, metadata !DIExpression()), !dbg !75
  store ptr %rhs, ptr %rhs.addr, align 8
  call void @llvm.dbg.declare(metadata ptr %rhs.addr, metadata !76, metadata !DIExpression()), !dbg !77
  %this1 = load ptr, ptr %this.addr
  store ptr getelementptr inbounds ([4 x ptr], ptr @_ZTV1A, i64 0, i64 2), ptr %this1, !dbg !78
  %m_int = getelementptr inbounds %class.A, ptr %this1, i32 0, i32 1, !dbg !78
  %0 = load ptr, ptr %rhs.addr, align 8, !dbg !78
  %m_int2 = getelementptr inbounds %class.A, ptr %0, i32 0, i32 1, !dbg !78
  %1 = load i32, ptr %m_int2, align 4, !dbg !78
  store i32 %1, ptr %m_int, align 4, !dbg !78
  ret void, !dbg !79
}

; Function Attrs: nounwind uwtable
define ptr @_ZN1AaSERKS_(ptr %this, ptr %rhs) #0 align 2 !dbg !51 {
entry:
  %this.addr = alloca ptr, align 8
  %rhs.addr = alloca ptr, align 8
  store ptr %this, ptr %this.addr, align 8
  call void @llvm.dbg.declare(metadata ptr %this.addr, metadata !80, metadata !DIExpression()), !dbg !81
  store ptr %rhs, ptr %rhs.addr, align 8
  call void @llvm.dbg.declare(metadata ptr %rhs.addr, metadata !82, metadata !DIExpression()), !dbg !83
  %this1 = load ptr, ptr %this.addr
  %0 = load ptr, ptr %rhs.addr, align 8, !dbg !84
  %m_int = getelementptr inbounds %class.A, ptr %0, i32 0, i32 1, !dbg !84
  %1 = load i32, ptr %m_int, align 4, !dbg !84
  %m_int2 = getelementptr inbounds %class.A, ptr %this1, i32 0, i32 1, !dbg !84
  store i32 %1, ptr %m_int2, align 4, !dbg !84
  ret ptr %this1, !dbg !85
}

; Function Attrs: nounwind uwtable
define i32 @_ZN1A7get_intEv(ptr %this) #0 align 2 !dbg !52 {
entry:
  %this.addr = alloca ptr, align 8
  store ptr %this, ptr %this.addr, align 8
  call void @llvm.dbg.declare(metadata ptr %this.addr, metadata !86, metadata !DIExpression()), !dbg !87
  %this1 = load ptr, ptr %this.addr
  %m_int = getelementptr inbounds %class.A, ptr %this1, i32 0, i32 1, !dbg !88
  %0 = load i32, ptr %m_int, align 4, !dbg !88
  ret i32 %0, !dbg !88
}

; Function Attrs: uwtable
define void @_ZN1B9AInstanceEv(ptr noalias sret(%class.A) %agg.result, ptr %this) #2 align 2 !dbg !53 {
entry:
  %this.addr = alloca ptr, align 8
  %nrvo = alloca i1, align 1
  %cleanup.dest.slot = alloca i32
  store ptr %this, ptr %this.addr, align 8
  call void @llvm.dbg.declare(metadata ptr %this.addr, metadata !89, metadata !DIExpression()), !dbg !91
  %this1 = load ptr, ptr %this.addr
  store i1 false, ptr %nrvo, !dbg !92
  call void @llvm.dbg.declare(metadata ptr %agg.result, metadata !93, metadata !DIExpression()), !dbg !92
  call void @_ZN1AC1Ei(ptr %agg.result, i32 12), !dbg !92
  store i1 true, ptr %nrvo, !dbg !94
  store i32 1, ptr %cleanup.dest.slot
  %nrvo.val = load i1, ptr %nrvo, !dbg !95
  br i1 %nrvo.val, label %nrvo.skipdtor, label %nrvo.unused, !dbg !95

nrvo.unused:                                      ; preds = %entry
  call void @_ZN1AD2Ev(ptr %agg.result), !dbg !96
  br label %nrvo.skipdtor, !dbg !96

nrvo.skipdtor:                                    ; preds = %nrvo.unused, %entry
  ret void, !dbg !98
}

; Function Attrs: nounwind uwtable
define linkonce_odr void @_ZN1AD2Ev(ptr %this) unnamed_addr #0 align 2 !dbg !63 {
entry:
  %this.addr = alloca ptr, align 8
  store ptr %this, ptr %this.addr, align 8
  call void @llvm.dbg.declare(metadata ptr %this.addr, metadata !101, metadata !DIExpression()), !dbg !102
  %this1 = load ptr, ptr %this.addr
  ret void, !dbg !103
}

; Function Attrs: uwtable
define i32 @main(i32 %argc, ptr %argv) #2 personality ptr @__gxx_personality_v0 !dbg !54 {
entry:
  %retval = alloca i32, align 4
  %argc.addr = alloca i32, align 4
  %argv.addr = alloca ptr, align 8
  %b = alloca %class.B, align 8
  %return_val = alloca i32, align 4
  %temp.lvalue = alloca %class.A, align 8
  %exn.slot = alloca ptr
  %ehselector.slot = alloca i32
  %a = alloca %class.A, align 8
  %cleanup.dest.slot = alloca i32
  store i32 0, ptr %retval
  store i32 %argc, ptr %argc.addr, align 4
  call void @llvm.dbg.declare(metadata ptr %argc.addr, metadata !104, metadata !DIExpression()), !dbg !105
  store ptr %argv, ptr %argv.addr, align 8
  call void @llvm.dbg.declare(metadata ptr %argv.addr, metadata !106, metadata !DIExpression()), !dbg !105
  call void @llvm.dbg.declare(metadata ptr %b, metadata !107, metadata !DIExpression()), !dbg !108
  call void @_ZN1BC2Ev(ptr %b), !dbg !108
  call void @llvm.dbg.declare(metadata ptr %return_val, metadata !109, metadata !DIExpression()), !dbg !110
  call void @_ZN1B9AInstanceEv(ptr sret(%class.A) %temp.lvalue, ptr %b), !dbg !110
  %call = invoke i32 @_ZN1A7get_intEv(ptr %temp.lvalue)
          to label %invoke.cont unwind label %lpad, !dbg !110

invoke.cont:                                      ; preds = %entry
  call void @_ZN1AD2Ev(ptr %temp.lvalue), !dbg !111
  store i32 %call, ptr %return_val, align 4, !dbg !111
  call void @llvm.dbg.declare(metadata ptr %a, metadata !113, metadata !DIExpression()), !dbg !114
  call void @_ZN1B9AInstanceEv(ptr sret(%class.A) %a, ptr %b), !dbg !114
  %0 = load i32, ptr %return_val, align 4, !dbg !115
  store i32 %0, ptr %retval, !dbg !115
  store i32 1, ptr %cleanup.dest.slot
  call void @_ZN1AD2Ev(ptr %a), !dbg !116
  %1 = load i32, ptr %retval, !dbg !116
  ret i32 %1, !dbg !116

lpad:                                             ; preds = %entry
  %2 = landingpad { ptr, i32 }
          cleanup, !dbg !116
  %3 = extractvalue { ptr, i32 } %2, 0, !dbg !116
  store ptr %3, ptr %exn.slot, !dbg !116
  %4 = extractvalue { ptr, i32 } %2, 1, !dbg !116
  store i32 %4, ptr %ehselector.slot, !dbg !116
  invoke void @_ZN1AD2Ev(ptr %temp.lvalue)
          to label %invoke.cont1 unwind label %terminate.lpad, !dbg !116

invoke.cont1:                                     ; preds = %lpad
  br label %eh.resume, !dbg !117

eh.resume:                                        ; preds = %invoke.cont1
  %exn = load ptr, ptr %exn.slot, !dbg !119
  %sel = load i32, ptr %ehselector.slot, !dbg !119
  %lpad.val = insertvalue { ptr, i32 } undef, ptr %exn, 0, !dbg !119
  %lpad.val2 = insertvalue { ptr, i32 } %lpad.val, i32 %sel, 1, !dbg !119
  resume { ptr, i32 } %lpad.val2, !dbg !119

terminate.lpad:                                   ; preds = %lpad
  %5 = landingpad { ptr, i32 }
          catch ptr null, !dbg !121
  %6 = extractvalue { ptr, i32 } %5, 0, !dbg !121
  call void @__clang_call_terminate(ptr %6) #5, !dbg !121
  unreachable, !dbg !121
}

; Function Attrs: nounwind uwtable
define linkonce_odr void @_ZN1BC2Ev(ptr %this) unnamed_addr #0 align 2 !dbg !62 {
entry:
  %this.addr = alloca ptr, align 8
  store ptr %this, ptr %this.addr, align 8
  call void @llvm.dbg.declare(metadata ptr %this.addr, metadata !123, metadata !DIExpression()), !dbg !124
  %this1 = load ptr, ptr %this.addr
  ret void, !dbg !125
}

declare i32 @__gxx_personality_v0(...)

; Function Attrs: noinline noreturn nounwind
define linkonce_odr hidden void @__clang_call_terminate(ptr) #3 {
  %2 = call ptr @__cxa_begin_catch(ptr %0) #6
  call void @_ZSt9terminatev() #5
  unreachable
}

declare ptr @__cxa_begin_catch(ptr)

declare void @_ZSt9terminatev()

; Function Attrs: uwtable
define linkonce_odr void @_ZN1AD0Ev(ptr %this) unnamed_addr #2 align 2 personality ptr @__gxx_personality_v0 !dbg !61 {
entry:
  %this.addr = alloca ptr, align 8
  %exn.slot = alloca ptr
  %ehselector.slot = alloca i32, align 4
  store ptr %this, ptr %this.addr, align 8
  call void @llvm.dbg.declare(metadata ptr %this.addr, metadata !126, metadata !DIExpression()), !dbg !127
  %this1 = load ptr, ptr %this.addr
  invoke void @_ZN1AD2Ev(ptr %this1)
          to label %invoke.cont unwind label %lpad, !dbg !128

invoke.cont:                                      ; preds = %entry
  call void @_ZdlPv(ptr %this1) #7, !dbg !129
  ret void, !dbg !129

lpad:                                             ; preds = %entry
  %0 = landingpad { ptr, i32 }
          cleanup, !dbg !131
  %1 = extractvalue { ptr, i32 } %0, 0, !dbg !131
  store ptr %1, ptr %exn.slot, !dbg !131
  %2 = extractvalue { ptr, i32 } %0, 1, !dbg !131
  store i32 %2, ptr %ehselector.slot, !dbg !131
  call void @_ZdlPv(ptr %this1) #7, !dbg !131
  br label %eh.resume, !dbg !131

eh.resume:                                        ; preds = %lpad
  %exn = load ptr, ptr %exn.slot, !dbg !133
  %sel = load i32, ptr %ehselector.slot, !dbg !133
  %lpad.val = insertvalue { ptr, i32 } undef, ptr %exn, 0, !dbg !133
  %lpad.val2 = insertvalue { ptr, i32 } %lpad.val, i32 %sel, 1, !dbg !133
  resume { ptr, i32 } %lpad.val2, !dbg !133
}

; Function Attrs: nobuiltin nounwind
declare void @_ZdlPv(ptr) #4

attributes #0 = { nounwind uwtable "less-precise-fpmad"="false" "frame-pointer"="all" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone }
attributes #2 = { uwtable "less-precise-fpmad"="false" "frame-pointer"="all" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { noinline noreturn nounwind }
attributes #4 = { nobuiltin nounwind "less-precise-fpmad"="false" "frame-pointer"="all" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #5 = { noreturn nounwind }
attributes #6 = { nounwind }
attributes #7 = { builtin nounwind }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!64, !65}
!llvm.ident = !{!66}

!0 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus, producer: "clang version 3.5.0 (trunk 203283) (llvm/trunk 203307)", isOptimized: false, splitDebugFilename: "sret.dwo", emissionKind: FullDebug, file: !1, enums: !2, retainedTypes: !3, globals: !2, imports: !2)
!1 = !DIFile(filename: "sret.cpp", directory: "/usr/local/google/home/echristo/tmp")
!2 = !{}
!3 = !{!4, !37}
!4 = !DICompositeType(tag: DW_TAG_class_type, name: "A", line: 1, size: 128, align: 64, file: !1, elements: !5, vtableHolder: !4, identifier: "_ZTS1A")
!5 = !{!6, !13, !14, !19, !25, !29, !33}
!6 = !DIDerivedType(tag: DW_TAG_member, name: "_vptr$A", size: 64, flags: DIFlagArtificial, file: !1, scope: !7, baseType: !8)
!7 = !DIFile(filename: "sret.cpp", directory: "/usr/local/google/home/echristo/tmp")
!8 = !DIDerivedType(tag: DW_TAG_pointer_type, size: 64, baseType: !9)
!9 = !DIDerivedType(tag: DW_TAG_pointer_type, name: "__vtbl_ptr_type", size: 64, baseType: !10)
!10 = !DISubroutineType(types: !11)
!11 = !{!12}
!12 = !DIBasicType(tag: DW_TAG_base_type, name: "int", size: 32, align: 32, encoding: DW_ATE_signed)
!13 = !DIDerivedType(tag: DW_TAG_member, name: "m_int", line: 13, size: 32, align: 32, offset: 64, flags: DIFlagProtected, file: !1, scope: !4, baseType: !12)
!14 = !DISubprogram(name: "A", line: 4, isLocal: false, isDefinition: false, virtualIndex: 6, flags: DIFlagPrototyped, isOptimized: false, scopeLine: 4, file: !1, scope: !4, type: !15)
!15 = !DISubroutineType(types: !16)
!16 = !{null, !17, !12}
!17 = !DIDerivedType(tag: DW_TAG_pointer_type, size: 64, align: 64, flags: DIFlagArtificial | DIFlagObjectPointer, baseType: !4)
!19 = !DISubprogram(name: "A", line: 5, isLocal: false, isDefinition: false, virtualIndex: 6, flags: DIFlagPrototyped, isOptimized: false, scopeLine: 5, file: !1, scope: !4, type: !20)
!20 = !DISubroutineType(types: !21)
!21 = !{null, !17, !22}
!22 = !DIDerivedType(tag: DW_TAG_reference_type, size: 64, align: 64, baseType: !23)
!23 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !4)
!25 = !DISubprogram(name: "operator=", linkageName: "_ZN1AaSERKS_", line: 7, isLocal: false, isDefinition: false, virtualIndex: 6, flags: DIFlagPrototyped, isOptimized: false, scopeLine: 7, file: !1, scope: !4, type: !26)
!26 = !DISubroutineType(types: !27)
!27 = !{!22, !17, !22}
!29 = !DISubprogram(name: "~A", line: 8, isLocal: false, isDefinition: false, virtuality: DW_VIRTUALITY_virtual, virtualIndex: 6, flags: DIFlagPrototyped, isOptimized: false, scopeLine: 8, file: !1, scope: !4, type: !30, containingType: !4)
!30 = !DISubroutineType(types: !31)
!31 = !{null, !17}
!33 = !DISubprogram(name: "get_int", linkageName: "_ZN1A7get_intEv", line: 10, isLocal: false, isDefinition: false, virtualIndex: 6, flags: DIFlagPrototyped, isOptimized: false, scopeLine: 10, file: !1, scope: !4, type: !34)
!34 = !DISubroutineType(types: !35)
!35 = !{!12, !17}
!37 = !DICompositeType(tag: DW_TAG_class_type, name: "B", line: 38, size: 8, align: 8, file: !1, elements: !38, identifier: "_ZTS1B")
!38 = !{!39, !44}
!39 = !DISubprogram(name: "B", line: 41, isLocal: false, isDefinition: false, virtualIndex: 6, flags: DIFlagPrototyped, isOptimized: false, scopeLine: 41, file: !1, scope: !37, type: !40)
!40 = !DISubroutineType(types: !41)
!41 = !{null, !42}
!42 = !DIDerivedType(tag: DW_TAG_pointer_type, size: 64, align: 64, flags: DIFlagArtificial | DIFlagObjectPointer, baseType: !37)
!44 = !DISubprogram(name: "AInstance", linkageName: "_ZN1B9AInstanceEv", line: 43, isLocal: false, isDefinition: false, virtualIndex: 6, flags: DIFlagPrototyped, isOptimized: false, scopeLine: 43, file: !1, scope: !37, type: !45)
!45 = !DISubroutineType(types: !46)
!46 = !{!4, !42}
!49 = distinct !DISubprogram(name: "A", linkageName: "_ZN1AC2Ei", line: 16, isLocal: false, isDefinition: true, virtualIndex: 6, flags: DIFlagPrototyped, isOptimized: false, unit: !0, scopeLine: 18, file: !1, scope: !4, type: !15, declaration: !14, retainedNodes: !2)
!50 = distinct !DISubprogram(name: "A", linkageName: "_ZN1AC2ERKS_", line: 21, isLocal: false, isDefinition: true, virtualIndex: 6, flags: DIFlagPrototyped, isOptimized: false, unit: !0, scopeLine: 23, file: !1, scope: !4, type: !20, declaration: !19, retainedNodes: !2)
!51 = distinct !DISubprogram(name: "operator=", linkageName: "_ZN1AaSERKS_", line: 27, isLocal: false, isDefinition: true, virtualIndex: 6, flags: DIFlagPrototyped, isOptimized: false, unit: !0, scopeLine: 28, file: !1, scope: !4, type: !26, declaration: !25, retainedNodes: !2)
!52 = distinct !DISubprogram(name: "get_int", linkageName: "_ZN1A7get_intEv", line: 33, isLocal: false, isDefinition: true, virtualIndex: 6, flags: DIFlagPrototyped, isOptimized: false, unit: !0, scopeLine: 34, file: !1, scope: !4, type: !34, declaration: !33, retainedNodes: !2)
!53 = distinct !DISubprogram(name: "AInstance", linkageName: "_ZN1B9AInstanceEv", line: 47, isLocal: false, isDefinition: true, virtualIndex: 6, flags: DIFlagPrototyped, isOptimized: false, unit: !0, scopeLine: 48, file: !1, scope: !37, type: !45, declaration: !44, retainedNodes: !2)
!54 = distinct !DISubprogram(name: "main", line: 53, isLocal: false, isDefinition: true, virtualIndex: 6, flags: DIFlagPrototyped, isOptimized: false, unit: !0, scopeLine: 54, file: !1, scope: !7, type: !55, retainedNodes: !2)
!55 = !DISubroutineType(types: !56)
!56 = !{!12, !12, !57}
!57 = !DIDerivedType(tag: DW_TAG_pointer_type, size: 64, align: 64, baseType: !58)
!58 = !DIDerivedType(tag: DW_TAG_pointer_type, size: 64, align: 64, baseType: !59)
!59 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !60)
!60 = !DIBasicType(tag: DW_TAG_base_type, name: "char", size: 8, align: 8, encoding: DW_ATE_signed_char)
!61 = distinct !DISubprogram(name: "~A", linkageName: "_ZN1AD0Ev", line: 8, isLocal: false, isDefinition: true, virtualIndex: 6, flags: DIFlagPrototyped, isOptimized: false, unit: !0, scopeLine: 8, file: !1, scope: !4, type: !30, declaration: !29, retainedNodes: !2)
!62 = distinct !DISubprogram(name: "B", linkageName: "_ZN1BC2Ev", line: 41, isLocal: false, isDefinition: true, virtualIndex: 6, flags: DIFlagPrototyped, isOptimized: false, unit: !0, scopeLine: 41, file: !1, scope: !37, type: !40, declaration: !39, retainedNodes: !2)
!63 = distinct !DISubprogram(name: "~A", linkageName: "_ZN1AD2Ev", line: 8, isLocal: false, isDefinition: true, virtualIndex: 6, flags: DIFlagPrototyped, isOptimized: false, unit: !0, scopeLine: 8, file: !1, scope: !4, type: !30, declaration: !29, retainedNodes: !2)
!64 = !{i32 2, !"Dwarf Version", i32 4}
!65 = !{i32 1, !"Debug Info Version", i32 3}
!66 = !{!"clang version 3.5.0 (trunk 203283) (llvm/trunk 203307)"}
!67 = !DILocalVariable(name: "this", arg: 1, flags: DIFlagArtificial | DIFlagObjectPointer, scope: !49, type: !68)
!68 = !DIDerivedType(tag: DW_TAG_pointer_type, size: 64, align: 64, baseType: !4)
!69 = !DILocation(line: 0, scope: !49)
!70 = !DILocalVariable(name: "i", line: 16, arg: 2, scope: !49, file: !7, type: !12)
!71 = !DILocation(line: 16, scope: !49)
!72 = !DILocation(line: 18, scope: !49)
!73 = !DILocation(line: 19, scope: !49)
!74 = !DILocalVariable(name: "this", arg: 1, flags: DIFlagArtificial | DIFlagObjectPointer, scope: !50, type: !68)
!75 = !DILocation(line: 0, scope: !50)
!76 = !DILocalVariable(name: "rhs", line: 21, arg: 2, scope: !50, file: !7, type: !22)
!77 = !DILocation(line: 21, scope: !50)
!78 = !DILocation(line: 23, scope: !50)
!79 = !DILocation(line: 24, scope: !50)
!80 = !DILocalVariable(name: "this", arg: 1, flags: DIFlagArtificial | DIFlagObjectPointer, scope: !51, type: !68)
!81 = !DILocation(line: 0, scope: !51)
!82 = !DILocalVariable(name: "rhs", line: 27, arg: 2, scope: !51, file: !7, type: !22)
!83 = !DILocation(line: 27, scope: !51)
!84 = !DILocation(line: 29, scope: !51)
!85 = !DILocation(line: 30, scope: !51)
!86 = !DILocalVariable(name: "this", arg: 1, flags: DIFlagArtificial | DIFlagObjectPointer, scope: !52, type: !68)
!87 = !DILocation(line: 0, scope: !52)
!88 = !DILocation(line: 35, scope: !52)
!89 = !DILocalVariable(name: "this", arg: 1, flags: DIFlagArtificial | DIFlagObjectPointer, scope: !53, type: !90)
!90 = !DIDerivedType(tag: DW_TAG_pointer_type, size: 64, align: 64, baseType: !37)
!91 = !DILocation(line: 0, scope: !53)
!92 = !DILocation(line: 49, scope: !53)
!93 = !DILocalVariable(name: "a", line: 49, scope: !53, file: !7, type: !4)
!94 = !DILocation(line: 50, scope: !53)
!95 = !DILocation(line: 51, scope: !53)
!96 = !DILocation(line: 51, scope: !97)
!97 = distinct !DILexicalBlock(line: 51, column: 0, file: !1, scope: !53)
!98 = !DILocation(line: 51, scope: !99)
!99 = distinct !DILexicalBlock(line: 51, column: 0, file: !1, scope: !100)
!100 = distinct !DILexicalBlock(line: 51, column: 0, file: !1, scope: !53)
!101 = !DILocalVariable(name: "this", arg: 1, flags: DIFlagArtificial | DIFlagObjectPointer, scope: !63, type: !68)
!102 = !DILocation(line: 0, scope: !63)
!103 = !DILocation(line: 8, scope: !63)
!104 = !DILocalVariable(name: "argc", line: 53, arg: 1, scope: !54, file: !7, type: !12)
!105 = !DILocation(line: 53, scope: !54)
!106 = !DILocalVariable(name: "argv", line: 53, arg: 2, scope: !54, file: !7, type: !57)
!107 = !DILocalVariable(name: "b", line: 55, scope: !54, file: !7, type: !37)
!108 = !DILocation(line: 55, scope: !54)
!109 = !DILocalVariable(name: "return_val", line: 56, scope: !54, file: !7, type: !12)
!110 = !DILocation(line: 56, scope: !54)
!111 = !DILocation(line: 56, scope: !112)
!112 = distinct !DILexicalBlock(line: 56, column: 0, file: !1, scope: !54)
!113 = !DILocalVariable(name: "a", line: 58, scope: !54, file: !7, type: !4)
!114 = !DILocation(line: 58, scope: !54)
!115 = !DILocation(line: 59, scope: !54)
!116 = !DILocation(line: 60, scope: !54)
!117 = !DILocation(line: 60, scope: !118)
!118 = distinct !DILexicalBlock(line: 60, column: 0, file: !1, scope: !54)
!119 = !DILocation(line: 60, scope: !120)
!120 = distinct !DILexicalBlock(line: 60, column: 0, file: !1, scope: !54)
!121 = !DILocation(line: 60, scope: !122)
!122 = distinct !DILexicalBlock(line: 60, column: 0, file: !1, scope: !54)
!123 = !DILocalVariable(name: "this", arg: 1, flags: DIFlagArtificial | DIFlagObjectPointer, scope: !62, type: !90)
!124 = !DILocation(line: 0, scope: !62)
!125 = !DILocation(line: 41, scope: !62)
!126 = !DILocalVariable(name: "this", arg: 1, flags: DIFlagArtificial | DIFlagObjectPointer, scope: !61, type: !68)
!127 = !DILocation(line: 0, scope: !61)
!128 = !DILocation(line: 8, scope: !61)
!129 = !DILocation(line: 8, scope: !130)
!130 = distinct !DILexicalBlock(line: 8, column: 0, file: !1, scope: !61)
!131 = !DILocation(line: 8, scope: !132)
!132 = distinct !DILexicalBlock(line: 8, column: 0, file: !1, scope: !61)
!133 = !DILocation(line: 8, scope: !134)
!134 = distinct !DILexicalBlock(line: 8, column: 0, file: !1, scope: !61)
