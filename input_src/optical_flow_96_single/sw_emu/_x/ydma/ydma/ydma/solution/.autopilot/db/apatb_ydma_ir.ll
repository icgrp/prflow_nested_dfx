; ModuleID = '/home/dopark/workspace/zcu102_tuning/prflow_riscv/input_src/optical_flow512/sw_emu/_x/ydma/ydma/ydma/solution/.autopilot/db/a.g.ld.5.gdce.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-i64:64-i128:128-i256:256-i512:512-i1024:1024-i2048:2048-i4096:4096-n8:16:32:64-S128-v16:16-v24:32-v32:32-v48:64-v96:128-v192:256-v256:256-v512:512-v1024:1024"
target triple = "fpga64-xilinx-none"

%struct.ap_fixed.8 = type { %struct.ap_fixed_base.6 }
%struct.ap_fixed_base.6 = type { %struct.ssdm_int.7 }
%struct.ssdm_int.7 = type { i64 }
%struct.ap_uint.7 = type { %struct.ap_int_base.8 }
%struct.ap_int_base.8 = type { %struct.ssdm_int.9 }
%struct.ssdm_int.9 = type { i512 }

; Function Attrs: noinline
define void @apatb_ydma_ir(%struct.ap_fixed.8* %input1, %struct.ap_uint.7* %input2, %struct.ap_fixed.8* %output1, %struct.ap_uint.7* %output2, i32 %config_size, i32 %input_size, i32 %output_size) local_unnamed_addr #0 {
entry:
  %input1_copy1 = alloca %struct.ap_fixed.8, align 512
  %input2_copy2 = alloca %struct.ap_uint.7, align 512
  %output1_copy3 = alloca %struct.ap_fixed.8, align 512
  %output2_copy4 = alloca %struct.ap_uint.7, align 512
  call fastcc void @copy_in(%struct.ap_fixed.8* %input1, %struct.ap_fixed.8* nonnull align 512 %input1_copy1, %struct.ap_uint.7* %input2, %struct.ap_uint.7* nonnull align 512 %input2_copy2, %struct.ap_fixed.8* %output1, %struct.ap_fixed.8* nonnull align 512 %output1_copy3, %struct.ap_uint.7* %output2, %struct.ap_uint.7* nonnull align 512 %output2_copy4)
  call void @apatb_ydma_hw(%struct.ap_fixed.8* %input1_copy1, %struct.ap_uint.7* %input2_copy2, %struct.ap_fixed.8* %output1_copy3, %struct.ap_uint.7* %output2_copy4, i32 %config_size, i32 %input_size, i32 %output_size)
  call fastcc void @copy_out(%struct.ap_fixed.8* %input1, %struct.ap_fixed.8* nonnull align 512 %input1_copy1, %struct.ap_uint.7* %input2, %struct.ap_uint.7* nonnull align 512 %input2_copy2, %struct.ap_fixed.8* %output1, %struct.ap_fixed.8* nonnull align 512 %output1_copy3, %struct.ap_uint.7* %output2, %struct.ap_uint.7* nonnull align 512 %output2_copy4)
  ret void
}

; Function Attrs: argmemonly noinline
define internal fastcc void @copy_in(%struct.ap_fixed.8* readonly, %struct.ap_fixed.8* noalias align 512, %struct.ap_uint.7* readonly, %struct.ap_uint.7* noalias align 512, %struct.ap_fixed.8* readonly, %struct.ap_fixed.8* noalias align 512, %struct.ap_uint.7* readonly, %struct.ap_uint.7* noalias align 512) unnamed_addr #1 {
entry:
  call fastcc void @onebyonecpy_hls.p0struct.ap_fixed.8(%struct.ap_fixed.8* align 512 %1, %struct.ap_fixed.8* %0)
  call fastcc void @onebyonecpy_hls.p0struct.ap_uint.7(%struct.ap_uint.7* align 512 %3, %struct.ap_uint.7* %2)
  call fastcc void @onebyonecpy_hls.p0struct.ap_fixed.8(%struct.ap_fixed.8* align 512 %5, %struct.ap_fixed.8* %4)
  call fastcc void @onebyonecpy_hls.p0struct.ap_uint.7(%struct.ap_uint.7* align 512 %7, %struct.ap_uint.7* %6)
  ret void
}

; Function Attrs: argmemonly noinline
define internal fastcc void @onebyonecpy_hls.p0struct.ap_fixed.8(%struct.ap_fixed.8* noalias align 512, %struct.ap_fixed.8* noalias readonly) unnamed_addr #2 {
entry:
  %2 = icmp eq %struct.ap_fixed.8* %0, null
  %3 = icmp eq %struct.ap_fixed.8* %1, null
  %4 = or i1 %2, %3
  br i1 %4, label %ret, label %copy

copy:                                             ; preds = %entry
  %5 = bitcast %struct.ap_fixed.8* %0 to i8*
  %6 = bitcast %struct.ap_fixed.8* %1 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 1 %5, i8* align 1 %6, i64 8, i1 false)
  br label %ret

ret:                                              ; preds = %copy, %entry
  ret void
}

; Function Attrs: argmemonly nounwind
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* nocapture writeonly, i8* nocapture readonly, i64, i1) #3

; Function Attrs: argmemonly noinline
define internal fastcc void @onebyonecpy_hls.p0struct.ap_uint.7(%struct.ap_uint.7* noalias align 512, %struct.ap_uint.7* noalias readonly) unnamed_addr #2 {
entry:
  %2 = icmp eq %struct.ap_uint.7* %0, null
  %3 = icmp eq %struct.ap_uint.7* %1, null
  %4 = or i1 %2, %3
  br i1 %4, label %ret, label %copy

copy:                                             ; preds = %entry
  %5 = bitcast %struct.ap_uint.7* %0 to i8*
  %6 = bitcast %struct.ap_uint.7* %1 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 1 %5, i8* align 1 %6, i64 64, i1 false)
  br label %ret

ret:                                              ; preds = %copy, %entry
  ret void
}

; Function Attrs: argmemonly noinline
define internal fastcc void @copy_out(%struct.ap_fixed.8*, %struct.ap_fixed.8* noalias readonly align 512, %struct.ap_uint.7*, %struct.ap_uint.7* noalias readonly align 512, %struct.ap_fixed.8*, %struct.ap_fixed.8* noalias readonly align 512, %struct.ap_uint.7*, %struct.ap_uint.7* noalias readonly align 512) unnamed_addr #4 {
entry:
  call fastcc void @onebyonecpy_hls.p0struct.ap_fixed.8(%struct.ap_fixed.8* %0, %struct.ap_fixed.8* align 512 %1)
  call fastcc void @onebyonecpy_hls.p0struct.ap_uint.7(%struct.ap_uint.7* %2, %struct.ap_uint.7* align 512 %3)
  call fastcc void @onebyonecpy_hls.p0struct.ap_fixed.8(%struct.ap_fixed.8* %4, %struct.ap_fixed.8* align 512 %5)
  call fastcc void @onebyonecpy_hls.p0struct.ap_uint.7(%struct.ap_uint.7* %6, %struct.ap_uint.7* align 512 %7)
  ret void
}

declare void @apatb_ydma_hw(%struct.ap_fixed.8*, %struct.ap_uint.7*, %struct.ap_fixed.8*, %struct.ap_uint.7*, i32, i32, i32)

define void @ydma_hw_stub_wrapper(%struct.ap_fixed.8*, %struct.ap_uint.7*, %struct.ap_fixed.8*, %struct.ap_uint.7*, i32, i32, i32) #5 {
entry:
  call void @copy_out(%struct.ap_fixed.8* null, %struct.ap_fixed.8* %0, %struct.ap_uint.7* null, %struct.ap_uint.7* %1, %struct.ap_fixed.8* null, %struct.ap_fixed.8* %2, %struct.ap_uint.7* null, %struct.ap_uint.7* %3)
  call void @ydma_hw_stub(%struct.ap_fixed.8* %0, %struct.ap_uint.7* %1, %struct.ap_fixed.8* %2, %struct.ap_uint.7* %3, i32 %4, i32 %5, i32 %6)
  call void @copy_in(%struct.ap_fixed.8* null, %struct.ap_fixed.8* %0, %struct.ap_uint.7* null, %struct.ap_uint.7* %1, %struct.ap_fixed.8* null, %struct.ap_fixed.8* %2, %struct.ap_uint.7* null, %struct.ap_uint.7* %3)
  ret void
}

declare void @ydma_hw_stub(%struct.ap_fixed.8*, %struct.ap_uint.7*, %struct.ap_fixed.8*, %struct.ap_uint.7*, i32, i32, i32)

attributes #0 = { noinline "fpga.wrapper.func"="wrapper" }
attributes #1 = { argmemonly noinline "fpga.wrapper.func"="copyin" }
attributes #2 = { argmemonly noinline "fpga.wrapper.func"="onebyonecpy_hls" }
attributes #3 = { argmemonly nounwind }
attributes #4 = { argmemonly noinline "fpga.wrapper.func"="copyout" }
attributes #5 = { "fpga.wrapper.func"="stub" }

!llvm.dbg.cu = !{}
!llvm.ident = !{!0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0}
!llvm.module.flags = !{!1, !2, !3}
!blackbox_cfg = !{!4}

!0 = !{!"clang version 7.0.0 "}
!1 = !{i32 2, !"Dwarf Version", i32 4}
!2 = !{i32 2, !"Debug Info Version", i32 3}
!3 = !{i32 1, !"wchar_size", i32 4}
!4 = !{}
