// -----// IR Dump Before LLVMGPUSelectLoweringStrategyPass (iree-llvmgpu-select-lowering-strategy) //----- //
module {
  func.func @prefill_bs1$async_dispatch_4_sort_Dx2x2xf32_dispatch_tensor_store() {
    %0 = hal.interface.constant.load layout(<constants = 3, bindings = [#hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) ordinal(0) : i32
    %1 = hal.interface.constant.load layout(<constants = 3, bindings = [#hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) ordinal(1) : i32
    %2 = hal.interface.constant.load layout(<constants = 3, bindings = [#hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) ordinal(2) : i32
    %3 = arith.index_castui %0 : i32 to index
    %4 = arith.index_castui %1 : i32 to index
    %5 = arith.index_castui %2 : i32 to index
    %6:3 = util.assume.int 
        %3<umin = 2560, umax = 17920>, 
        %4<umin = 4352, umax = 30464>, 
        %5<umin = 32, umax = 224, udiv = 32>
      : index, index, index
    %7 = iree_tensor_ext.dispatch.workload.ordinal %6#2, 0 : index
    %8 = hal.interface.binding.subspan layout(<constants = 3, bindings = [#hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(0) alignment(64) offset(%6#0) flags(Indirect) : !iree_tensor_ext.dispatch.tensor<readwrite:tensor<?x2x2xf32>>{%7}
    %9 = hal.interface.binding.subspan layout(<constants = 3, bindings = [#hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(0) alignment(64) offset(%6#1) flags(Indirect) : !iree_tensor_ext.dispatch.tensor<readonly:tensor<?x2x2xi64>>{%7}
    %10 = iree_tensor_ext.dispatch.tensor.load %8, offsets = [0, 0, 0], sizes = [%7, 2, 2], strides = [1, 1, 1] : !iree_tensor_ext.dispatch.tensor<readwrite:tensor<?x2x2xf32>>{%7} -> tensor<?x2x2xf32>
    %11 = iree_tensor_ext.dispatch.tensor.load %9, offsets = [0, 0, 0], sizes = [%7, 2, 2], strides = [1, 1, 1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<?x2x2xi64>>{%7} -> tensor<?x2x2xi64>
    %12:2 = iree_linalg_ext.sort dimension(2) outs(%10, %11 : tensor<?x2x2xf32>, tensor<?x2x2xi64>) {
    ^bb0(%arg0: f32, %arg1: f32, %arg2: i64, %arg3: i64):
      %13 = arith.cmpf oge, %arg0, %arg1 : f32
      iree_linalg_ext.yield %13 : i1
    } -> tensor<?x2x2xf32>, tensor<?x2x2xi64>
    iree_tensor_ext.dispatch.tensor.store %12#0, %8, offsets = [0, 0, 0], sizes = [%7, 2, 2], strides = [1, 1, 1] : tensor<?x2x2xf32> -> !iree_tensor_ext.dispatch.tensor<readwrite:tensor<?x2x2xf32>>{%7}
    return
  }
}

// -----// IR Dump Before TranslateAllExecutablesPass (iree-hal-translate-all-executables) //----- //
hal.executable private @prefill_bs1$async_dispatch_4 {
  hal.executable.variant public @rocm_hsaco_fb target(<"rocm", "rocm-hsaco-fb", {abi = "hip", iree.gpu.target = #iree_gpu.target<arch = "gfx942", features = "", wgp = <compute =  fp64|fp32|fp16|int64|int32|int16|int8, storage =  b64|b32|b16|b8, subgroup =  shuffle|arithmetic, dot =  dp4xi8toi32, mma = [<MFMA_F32_16x16x16_BF16>, <MFMA_F32_32x32x8_BF16>, <MFMA_F32_16x16x32_F8E5M2FNUZ>, <MFMA_F32_16x16x32_F8E5M2FNUZ_F8E4M3FNUZ>, <MFMA_F32_16x16x32_F8E4M3FNUZ>, <MFMA_F32_16x16x32_F8E4M3FNUZ_F8E5M2FNUZ>, <MFMA_F32_32x32x16_F8E5M2FNUZ>, <MFMA_F32_32x32x16_F8E5M2FNUZ_F8E4M3FNUZ>, <MFMA_F32_32x32x16_F8E4M3FNUZ>, <MFMA_F32_32x32x16_F8E4M3FNUZ_F8E5M2FNUZ>, <MFMA_I32_16x16x32_I8>, <MFMA_I32_32x32x16_I8>, <MFMA_F64_16x16x4_F64>, <MFMA_F32_16x16x4_F32>, <MFMA_F32_16x16x16_F16>, <MFMA_F32_32x32x8_F16>], subgroup_size_choices = [64], max_workgroup_sizes = [1024, 1024, 1024], max_thread_count_per_workgroup = 1024, max_workgroup_memory_bytes = 65536, max_workgroup_counts = [2147483647, 2147483647, 2147483647], max_load_instruction_bits = 128, simds_per_wgp = 4, vgpr_space_bits = 16384>>, ukernels = "none"}>) {
    hal.executable.export public @prefill_bs1$async_dispatch_4_sort_Dx2x2xf32_dispatch_tensor_store ordinal(0) layout(#hal.pipeline.layout<constants = 3, bindings = [#hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) count(%arg0: !hal.device, %arg1: index) -> (index, index, index) {
      %x, %y, %z = iree_tensor_ext.dispatch.workgroup_count_from_slice %arg1
      hal.return %x, %y, %z : index, index, index
    }
    builtin.module {
      func.func @prefill_bs1$async_dispatch_4_sort_Dx2x2xf32_dispatch_tensor_store() attributes {translation_info = #iree_codegen.translation_info<pipeline = LLVMGPUTileAndFuse workgroup_size = [128, 1, 1] subgroup_size = 64>} {
        %0 = hal.interface.constant.load layout(<constants = 3, bindings = [#hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) ordinal(0) : i32
        %1 = hal.interface.constant.load layout(<constants = 3, bindings = [#hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) ordinal(1) : i32
        %2 = hal.interface.constant.load layout(<constants = 3, bindings = [#hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) ordinal(2) : i32
        %3 = arith.index_castui %0 : i32 to index
        %4 = arith.index_castui %1 : i32 to index
        %5 = arith.index_castui %2 : i32 to index
        %6:3 = util.assume.int 
            %3<umin = 2560, umax = 17920>, 
            %4<umin = 4352, umax = 30464>, 
            %5<umin = 32, umax = 224, udiv = 32>
          : index, index, index
        %7 = iree_tensor_ext.dispatch.workload.ordinal %6#2, 0 : index
        %8 = hal.interface.binding.subspan layout(<constants = 3, bindings = [#hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(0) alignment(64) offset(%6#0) flags(Indirect) : !iree_tensor_ext.dispatch.tensor<readwrite:tensor<?x2x2xf32>>{%7}
        %9 = hal.interface.binding.subspan layout(<constants = 3, bindings = [#hal.pipeline.binding<storage_buffer, Indirect>], flags = Indirect>) binding(0) alignment(64) offset(%6#1) flags(Indirect) : !iree_tensor_ext.dispatch.tensor<readonly:tensor<?x2x2xi64>>{%7}
        %10 = iree_tensor_ext.dispatch.tensor.load %8, offsets = [0, 0, 0], sizes = [%7, 2, 2], strides = [1, 1, 1] : !iree_tensor_ext.dispatch.tensor<readwrite:tensor<?x2x2xf32>>{%7} -> tensor<?x2x2xf32>
        %11 = iree_tensor_ext.dispatch.tensor.load %9, offsets = [0, 0, 0], sizes = [%7, 2, 2], strides = [1, 1, 1] : !iree_tensor_ext.dispatch.tensor<readonly:tensor<?x2x2xi64>>{%7} -> tensor<?x2x2xi64>
        %12:2 = iree_linalg_ext.sort {lowering_config = #iree_gpu.lowering_config<{thread = [1, 1, 0], workgroup = [1, 2, 0]}>} dimension(2) outs(%10, %11 : tensor<?x2x2xf32>, tensor<?x2x2xi64>) {
        ^bb0(%arg0: f32, %arg1: f32, %arg2: i64, %arg3: i64):
          %13 = arith.cmpf oge, %arg0, %arg1 : f32
          iree_linalg_ext.yield %13 : i1
        } -> tensor<?x2x2xf32>, tensor<?x2x2xi64>
        iree_tensor_ext.dispatch.tensor.store %12#0, %8, offsets = [0, 0, 0], sizes = [%7, 2, 2], strides = [1, 1, 1] : tensor<?x2x2xf32> -> !iree_tensor_ext.dispatch.tensor<readwrite:tensor<?x2x2xf32>>{%7}
        return
      }
    }
  }
}