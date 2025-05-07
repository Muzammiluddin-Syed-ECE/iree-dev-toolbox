// -----// IR Dump Before IREEComprehensiveBufferizePass (iree-codegen-iree-comprehensive-bufferize) //----- //
func.func @prefill_bs1$async_dispatch_7_sort_Dx2xf32_dispatch_tensor_store() attributes {translation_info = #iree_codegen.translation_info<pipeline = LLVMGPUTileAndFuse workgroup_size = [128, 1, 1] subgroup_size = 64>} {
  %0 = hal.interface.constant.load layout(<constants = 3, bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) ordinal(0) : i32
  %1 = hal.interface.constant.load layout(<constants = 3, bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) ordinal(1) : i32
  %2 = hal.interface.constant.load layout(<constants = 3, bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) ordinal(2) : i32
  %3 = arith.index_castui %0 : i32 to index
  %4 = arith.index_castui %1 : i32 to index
  %5 = arith.index_castui %2 : i32 to index
  %6:3 = util.assume.int 
      %3<umin = 3840, umax = 26880>, 
      %4<umin = 3072, umax = 21504>, 
      %5<umin = 32, umax = 224, udiv = 32>
    : index, index, index
  %7 = iree_tensor_ext.dispatch.workload.ordinal %6#2, 0 : index
  %8 = hal.interface.binding.subspan layout(<constants = 3, bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(0) alignment(64) offset(%6#0) flags("ReadOnly|Indirect") : !iree_tensor_ext.dispatch.tensor<readonly:tensor<?x2xf32>>{%7}
  %9 = hal.interface.binding.subspan layout(<constants = 3, bindings = [#hal.pipeline.binding<storage_buffer, "ReadOnly|Indirect">, #hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(1) alignment(64) offset(%6#1) flags(Indirect) : !iree_tensor_ext.dispatch.tensor<readwrite:tensor<?x2xi64>>{%7}
  %10 = iree_tensor_ext.dispatch.tensor.load %8, offsets = [0, 0], sizes = [%7, 2], strides = [1, 1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<?x2xf32>>{%7} -> tensor<?x2xf32>
  %11 = iree_tensor_ext.dispatch.tensor.load %9, offsets = [0, 0], sizes = [%7, 2], strides = [1, 1] : !iree_tensor_ext.dispatch.tensor<readwrite:tensor<?x2xi64>>{%7} -> tensor<?x2xi64>
  %12 = scf.forall (%arg0) in (%7) shared_outs(%arg1 = %11) -> (tensor<?x2xi64>) {
    %extracted_slice = tensor.extract_slice %10[%arg0, 0] [1, 2] [1, 1] : tensor<?x2xf32> to tensor<1x2xf32>
    %extracted_slice_0 = tensor.extract_slice %arg1[%arg0, 0] [1, 2] [1, 1] : tensor<?x2xi64> to tensor<1x2xi64>
    %13 = scf.forall (%arg2) in (1) shared_outs(%arg3 = %extracted_slice_0) -> (tensor<1x2xi64>) {
      %14:2 = iree_linalg_ext.sort {lowering_config = #iree_gpu.lowering_config<{thread = [1, 0], workgroup = [1, 0]}>} dimension(1) outs(%extracted_slice, %arg3 : tensor<1x2xf32>, tensor<1x2xi64>) {
      ^bb0(%arg4: f32, %arg5: f32, %arg6: i64, %arg7: i64):
        %15 = arith.cmpf oge, %arg4, %arg5 : f32
        iree_linalg_ext.yield %15 : i1
      } -> tensor<1x2xf32>, tensor<1x2xi64>
      scf.forall.in_parallel {
        tensor.parallel_insert_slice %14#1 into %arg3[0, 0] [1, 2] [1, 1] : tensor<1x2xi64> into tensor<1x2xi64>
      }
    } {mapping = [#gpu.thread<linear_dim_0>]}
    scf.forall.in_parallel {
      tensor.parallel_insert_slice %13 into %arg1[%arg0, 0] [1, 2] [1, 1] : tensor<1x2xi64> into tensor<?x2xi64>
    }
  } {mapping = [#iree_codegen.workgroup_mapping<x>]}
  iree_tensor_ext.dispatch.tensor.store %12, %9, offsets = [0, 0], sizes = [%7, 2], strides = [1, 1] : tensor<?x2xi64> -> !iree_tensor_ext.dispatch.tensor<readwrite:tensor<?x2xi64>>{%7}
  return
}