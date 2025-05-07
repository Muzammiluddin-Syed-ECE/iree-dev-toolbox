module @module {
  util.global private @__auto.token_embd.weight = #stream.parameter.named<"model"::"token_embd.weight"> : tensor<256x32xf32>
  util.global private @__auto.blk.0.ffn_gate_inp.weight = #stream.parameter.named<"model"::"blk.0.ffn_gate_inp.weight"> : tensor<4x32xf32>
  util.global private @__auto.blk.0.ffn_gate_exps.weight = #stream.parameter.named<"model"::"blk.0.ffn_gate_exps.weight"> : tensor<4x16x32xf32>
  util.global private @__auto.blk.0.ffn_up_exps.weight = #stream.parameter.named<"model"::"blk.0.ffn_up_exps.weight"> : tensor<4x16x32xf32>
  util.global private @__auto.blk.0.ffn_down_exps.weight = #stream.parameter.named<"model"::"blk.0.ffn_down_exps.weight"> : tensor<4x32x16xf32>
  util.global private @__auto.output_norm.weight = #stream.parameter.named<"model"::"output_norm.weight"> : tensor<32xf32>
  util.global private @__auto.output.weight = #stream.parameter.named<"model"::"output.weight"> : tensor<256x32xf32>
  func.func @prefill_bs1(%arg0: !torch.vtensor<[1,?],si64>, %arg1: !torch.vtensor<[1],si64>, %arg2: !torch.vtensor<[1,?],si64>, %arg3: !torch.vtensor<[?,49152],f16>) -> !torch.vtensor<[1,?,256],f32> attributes {torch.assume_strict_symbolic_shapes} {
    %__auto.token_embd.weight = util.global.load @__auto.token_embd.weight : tensor<256x32xf32>
    %0 = torch_c.from_builtin_tensor %__auto.token_embd.weight : tensor<256x32xf32> -> !torch.vtensor<[256,32],f32>
    %__auto.blk.0.ffn_gate_inp.weight = util.global.load @__auto.blk.0.ffn_gate_inp.weight : tensor<4x32xf32>
    %1 = torch_c.from_builtin_tensor %__auto.blk.0.ffn_gate_inp.weight : tensor<4x32xf32> -> !torch.vtensor<[4,32],f32>
    %__auto.blk.0.ffn_gate_exps.weight = util.global.load @__auto.blk.0.ffn_gate_exps.weight : tensor<4x16x32xf32>
    %2 = torch_c.from_builtin_tensor %__auto.blk.0.ffn_gate_exps.weight : tensor<4x16x32xf32> -> !torch.vtensor<[4,16,32],f32>
    %__auto.blk.0.ffn_up_exps.weight = util.global.load @__auto.blk.0.ffn_up_exps.weight : tensor<4x16x32xf32>
    %3 = torch_c.from_builtin_tensor %__auto.blk.0.ffn_up_exps.weight : tensor<4x16x32xf32> -> !torch.vtensor<[4,16,32],f32>
    %__auto.blk.0.ffn_down_exps.weight = util.global.load @__auto.blk.0.ffn_down_exps.weight : tensor<4x32x16xf32>
    %4 = torch_c.from_builtin_tensor %__auto.blk.0.ffn_down_exps.weight : tensor<4x32x16xf32> -> !torch.vtensor<[4,32,16],f32>
    %__auto.output_norm.weight = util.global.load @__auto.output_norm.weight : tensor<32xf32>
    %5 = torch_c.from_builtin_tensor %__auto.output_norm.weight : tensor<32xf32> -> !torch.vtensor<[32],f32>
    %__auto.output.weight = util.global.load @__auto.output.weight : tensor<256x32xf32>
    %6 = torch_c.from_builtin_tensor %__auto.output.weight : tensor<256x32xf32> -> !torch.vtensor<[256,32],f32>
    %7 = torch.symbolic_int "32*s1" {min_val = 64, max_val = 224} : !torch.int
    %8 = torch.symbolic_int "s1" {min_val = 2, max_val = 7} : !torch.int
    %9 = torch.symbolic_int "s2" {min_val = 0, max_val = 9223372036854775807} : !torch.int
    torch.bind_symbolic_shape %arg0, [%8], affine_map<()[s0] -> (1, s0 * 32)> : !torch.vtensor<[1,?],si64>
    torch.bind_symbolic_shape %arg2, [%8], affine_map<()[s0] -> (1, s0)> : !torch.vtensor<[1,?],si64>
    torch.bind_symbolic_shape %arg3, [%9], affine_map<()[s0] -> (s0, 49152)> : !torch.vtensor<[?,49152],f16>
    %int5 = torch.constant.int 5
    %10 = torch.prims.convert_element_type %0, %int5 : !torch.vtensor<[256,32],f32>, !torch.int -> !torch.vtensor<[256,32],f16>
    %int-1 = torch.constant.int -1
    %false = torch.constant.bool false
    %false_0 = torch.constant.bool false
    %11 = torch.aten.embedding %10, %arg0, %int-1, %false, %false_0 : !torch.vtensor<[256,32],f16>, !torch.vtensor<[1,?],si64>, !torch.int, !torch.bool, !torch.bool -> !torch.vtensor<[1,?,32],f16>
    torch.bind_symbolic_shape %11, [%8], affine_map<()[s0] -> (1, s0 * 32, 32)> : !torch.vtensor<[1,?,32],f16>
    %int1 = torch.constant.int 1
    %12 = torch.aten.size.int %arg0, %int1 : !torch.vtensor<[1,?],si64>, !torch.int -> !torch.int
    %int-1_1 = torch.constant.int -1
    %int32 = torch.constant.int 32
    %13 = torch.prim.ListConstruct %int-1_1, %int32 : (!torch.int, !torch.int) -> !torch.list<int>
    %14 = torch.aten.view %11, %13 : !torch.vtensor<[1,?,32],f16>, !torch.list<int> -> !torch.vtensor<[?,32],f16>
    torch.bind_symbolic_shape %14, [%8], affine_map<()[s0] -> (s0 * 32, 32)> : !torch.vtensor<[?,32],f16>
    %int5_2 = torch.constant.int 5
    %15 = torch.prims.convert_element_type %1, %int5_2 : !torch.vtensor<[4,32],f32>, !torch.int -> !torch.vtensor<[4,32],f16>
    %int-2 = torch.constant.int -2
    %int-1_3 = torch.constant.int -1
    %16 = torch.aten.transpose.int %15, %int-2, %int-1_3 : !torch.vtensor<[4,32],f16>, !torch.int, !torch.int -> !torch.vtensor<[32,4],f16>
    %int5_4 = torch.constant.int 5
    %17 = torch.prims.convert_element_type %16, %int5_4 : !torch.vtensor<[32,4],f16>, !torch.int -> !torch.vtensor<[32,4],f16>
    %18 = torch.aten.mm %14, %17 : !torch.vtensor<[?,32],f16>, !torch.vtensor<[32,4],f16> -> !torch.vtensor<[?,4],f16>
    torch.bind_symbolic_shape %18, [%8], affine_map<()[s0] -> (s0 * 32, 4)> : !torch.vtensor<[?,4],f16>
    %int6 = torch.constant.int 6
    %19 = torch.prims.convert_element_type %18, %int6 : !torch.vtensor<[?,4],f16>, !torch.int -> !torch.vtensor<[?,4],f32>
    torch.bind_symbolic_shape %19, [%8], affine_map<()[s0] -> (s0 * 32, 4)> : !torch.vtensor<[?,4],f32>
    %20 = torch.aten.sigmoid %19 : !torch.vtensor<[?,4],f32> -> !torch.vtensor<[?,4],f32>
    torch.bind_symbolic_shape %20, [%8], affine_map<()[s0] -> (s0 * 32, 4)> : !torch.vtensor<[?,4],f32>
    %int-1_5 = torch.constant.int -1
    %int4 = torch.constant.int 4
    %21 = torch.prim.ListConstruct %int-1_5, %int4 : (!torch.int, !torch.int) -> !torch.list<int>
    %22 = torch.aten.view %20, %21 : !torch.vtensor<[?,4],f32>, !torch.list<int> -> !torch.vtensor<[?,4],f32>
    torch.bind_symbolic_shape %22, [%8], affine_map<()[s0] -> (s0 * 32, 4)> : !torch.vtensor<[?,4],f32>
    %int-1_6 = torch.constant.int -1
    %int2 = torch.constant.int 2
    %int2_7 = torch.constant.int 2
    %23 = torch.prim.ListConstruct %int-1_6, %int2, %int2_7 : (!torch.int, !torch.int, !torch.int) -> !torch.list<int>
    %24 = torch.aten.view %20, %23 : !torch.vtensor<[?,4],f32>, !torch.list<int> -> !torch.vtensor<[?,2,2],f32>
    torch.bind_symbolic_shape %24, [%8], affine_map<()[s0] -> (s0 * 32, 2, 2)> : !torch.vtensor<[?,2,2],f32>
    %int2_8 = torch.constant.int 2
    %int-1_9 = torch.constant.int -1
    %true = torch.constant.bool true
    %true_10 = torch.constant.bool true
    %values, %indices = torch.aten.topk %24, %int2_8, %int-1_9, %true, %true_10 : !torch.vtensor<[?,2,2],f32>, !torch.int, !torch.int, !torch.bool, !torch.bool -> !torch.vtensor<[?,2,2],f32>, !torch.vtensor<[?,2,2],si64>
    torch.bind_symbolic_shape %values, [%8], affine_map<()[s0] -> (s0 * 32, 2, 2)> : !torch.vtensor<[?,2,2],f32>
    %int-1_11 = torch.constant.int -1
    %25 = torch.prim.ListConstruct %int-1_11 : (!torch.int) -> !torch.list<int>
    %false_12 = torch.constant.bool false
    %none = torch.constant.none
    %26 = torch.aten.sum.dim_IntList %values, %25, %false_12, %none : !torch.vtensor<[?,2,2],f32>, !torch.list<int>, !torch.bool, !torch.none -> !torch.vtensor<[?,2],f32>
    torch.bind_symbolic_shape %26, [%8], affine_map<()[s0] -> (s0 * 32, 2)> : !torch.vtensor<[?,2],f32>
    %int1_13 = torch.constant.int 1
    %int-1_14 = torch.constant.int -1
    %true_15 = torch.constant.bool true
    %true_16 = torch.constant.bool true
    %values_17, %indices_18 = torch.aten.topk %26, %int1_13, %int-1_14, %true_15, %true_16 : !torch.vtensor<[?,2],f32>, !torch.int, !torch.int, !torch.bool, !torch.bool -> !torch.vtensor<[?,1],f32>, !torch.vtensor<[?,1],si64>
    torch.bind_symbolic_shape %indices_18, [%8], affine_map<()[s0] -> (s0 * 32, 1)> : !torch.vtensor<[?,1],si64>
    %none_19 = torch.constant.none
    %none_20 = torch.constant.none
    %none_21 = torch.constant.none
    %false_22 = torch.constant.bool false
    %int1_23 = torch.constant.int 1
    %27 = torch.aten.zeros_like %26, %none_19, %none_20, %none_21, %false_22, %int1_23 : !torch.vtensor<[?,2],f32>, !torch.none, !torch.none, !torch.none, !torch.bool, !torch.int -> !torch.vtensor<[?,2],f32>
    torch.bind_symbolic_shape %27, [%8], affine_map<()[s0] -> (s0 * 32, 2)> : !torch.vtensor<[?,2],f32>
    %int1_24 = torch.constant.int 1
    %int1_25 = torch.constant.int 1
    %28 = torch.aten.scatter.value %27, %int1_24, %indices_18, %int1_25 : !torch.vtensor<[?,2],f32>, !torch.int, !torch.vtensor<[?,1],si64>, !torch.int -> !torch.vtensor<[?,2],f32>
    torch.bind_symbolic_shape %28, [%8], affine_map<()[s0] -> (s0 * 32, 2)> : !torch.vtensor<[?,2],f32>
    %int2_26 = torch.constant.int 2
    %29 = torch.aten.mul.int %12, %int2_26 : !torch.int, !torch.int -> !torch.int
    %int-1_27 = torch.constant.int -1
    %30 = torch.aten.unsqueeze %28, %int-1_27 : !torch.vtensor<[?,2],f32>, !torch.int -> !torch.vtensor<[?,2,1],f32>
    torch.bind_symbolic_shape %30, [%8], affine_map<()[s0] -> (s0 * 32, 2, 1)> : !torch.vtensor<[?,2,1],f32>
    %int-1_28 = torch.constant.int -1
    %int2_29 = torch.constant.int 2
    %int2_30 = torch.constant.int 2
    %31 = torch.prim.ListConstruct %int-1_28, %int2_29, %int2_30 : (!torch.int, !torch.int, !torch.int) -> !torch.list<int>
    %false_31 = torch.constant.bool false
    %32 = torch.aten.expand %30, %31, %false_31 : !torch.vtensor<[?,2,1],f32>, !torch.list<int>, !torch.bool -> !torch.vtensor<[?,2,2],f32>
    torch.bind_symbolic_shape %32, [%8], affine_map<()[s0] -> (s0 * 32, 2, 2)> : !torch.vtensor<[?,2,2],f32>
    %int0 = torch.constant.int 0
    %33 = torch.aten.clone %32, %int0 : !torch.vtensor<[?,2,2],f32>, !torch.int -> !torch.vtensor<[?,2,2],f32>
    torch.bind_symbolic_shape %33, [%8], affine_map<()[s0] -> (s0 * 32, 2, 2)> : !torch.vtensor<[?,2,2],f32>
    %int4_32 = torch.constant.int 4
    %34 = torch.prim.ListConstruct %12, %int4_32 : (!torch.int, !torch.int) -> !torch.list<int>
    %35 = torch.aten._unsafe_view %33, %34 : !torch.vtensor<[?,2,2],f32>, !torch.list<int> -> !torch.vtensor<[?,4],f32>
    torch.bind_symbolic_shape %35, [%8], affine_map<()[s0] -> (s0 * 32, 4)> : !torch.vtensor<[?,4],f32>
    %int11 = torch.constant.int 11
    %36 = torch.prims.convert_element_type %35, %int11 : !torch.vtensor<[?,4],f32>, !torch.int -> !torch.vtensor<[?,4],i1>
    torch.bind_symbolic_shape %36, [%8], affine_map<()[s0] -> (s0 * 32, 4)> : !torch.vtensor<[?,4],i1>
    %37 = torch.aten.bitwise_not %36 : !torch.vtensor<[?,4],i1> -> !torch.vtensor<[?,4],i1>
    torch.bind_symbolic_shape %37, [%8], affine_map<()[s0] -> (s0 * 32, 4)> : !torch.vtensor<[?,4],i1>
    %float0.000000e00 = torch.constant.float 0.000000e+00
    %int6_33 = torch.constant.int 6
    %int0_34 = torch.constant.int 0
    %cpu = torch.constant.device "cpu"
    %none_35 = torch.constant.none
    %38 = torch.aten.scalar_tensor %float0.000000e00, %int6_33, %int0_34, %cpu, %none_35 : !torch.float, !torch.int, !torch.int, !torch.Device, !torch.none -> !torch.vtensor<[],f32>
    %39 = torch.aten.where.self %37, %38, %22 : !torch.vtensor<[?,4],i1>, !torch.vtensor<[],f32>, !torch.vtensor<[?,4],f32> -> !torch.vtensor<[?,4],f32>
    torch.bind_symbolic_shape %39, [%8], affine_map<()[s0] -> (s0 * 32, 4)> : !torch.vtensor<[?,4],f32>
    %int2_36 = torch.constant.int 2
    %int-1_37 = torch.constant.int -1
    %true_38 = torch.constant.bool true
    %true_39 = torch.constant.bool true
    %values_40, %indices_41 = torch.aten.topk %39, %int2_36, %int-1_37, %true_38, %true_39 : !torch.vtensor<[?,4],f32>, !torch.int, !torch.int, !torch.bool, !torch.bool -> !torch.vtensor<[?,2],f32>, !torch.vtensor<[?,2],si64>
    torch.bind_symbolic_shape %values_40, [%8], affine_map<()[s0] -> (s0 * 32, 2)> : !torch.vtensor<[?,2],f32>
    torch.bind_symbolic_shape %indices_41, [%8], affine_map<()[s0] -> (s0 * 32, 2)> : !torch.vtensor<[?,2],si64>
    %int0_42 = torch.constant.int 0
    %int0_43 = torch.constant.int 0
    %int9223372036854775807 = torch.constant.int 9223372036854775807
    %int1_44 = torch.constant.int 1
    %40 = torch.aten.slice.Tensor %14, %int0_42, %int0_43, %int9223372036854775807, %int1_44 : !torch.vtensor<[?,32],f16>, !torch.int, !torch.int, !torch.int, !torch.int -> !torch.vtensor<[?,32],f16>
    torch.bind_symbolic_shape %40, [%8], affine_map<()[s0] -> (s0 * 32, 32)> : !torch.vtensor<[?,32],f16>
    %int1_45 = torch.constant.int 1
    %int0_46 = torch.constant.int 0
    %int9223372036854775807_47 = torch.constant.int 9223372036854775807
    %int1_48 = torch.constant.int 1
    %41 = torch.aten.slice.Tensor %40, %int1_45, %int0_46, %int9223372036854775807_47, %int1_48 : !torch.vtensor<[?,32],f16>, !torch.int, !torch.int, !torch.int, !torch.int -> !torch.vtensor<[?,32],f16>
    torch.bind_symbolic_shape %41, [%8], affine_map<()[s0] -> (s0 * 32, 32)> : !torch.vtensor<[?,32],f16>
    %int1_49 = torch.constant.int 1
    %int0_50 = torch.constant.int 0
    %int9223372036854775807_51 = torch.constant.int 9223372036854775807
    %int1_52 = torch.constant.int 1
    %42 = torch.aten.slice.Tensor %2, %int1_49, %int0_50, %int9223372036854775807_51, %int1_52 : !torch.vtensor<[4,16,32],f32>, !torch.int, !torch.int, !torch.int, !torch.int -> !torch.vtensor<[4,16,32],f32>
    %int2_53 = torch.constant.int 2
    %int0_54 = torch.constant.int 0
    %int9223372036854775807_55 = torch.constant.int 9223372036854775807
    %int1_56 = torch.constant.int 1
    %43 = torch.aten.slice.Tensor %42, %int2_53, %int0_54, %int9223372036854775807_55, %int1_56 : !torch.vtensor<[4,16,32],f32>, !torch.int, !torch.int, !torch.int, !torch.int -> !torch.vtensor<[4,16,32],f32>
    %44 = torch.prim.ListConstruct %indices_41 : (!torch.vtensor<[?,2],si64>) -> !torch.list<optional<vtensor>>
    %45 = torch.aten.index.Tensor %43, %44 : !torch.vtensor<[4,16,32],f32>, !torch.list<optional<vtensor>> -> !torch.vtensor<[?,2,16,32],f32>
    torch.bind_symbolic_shape %45, [%8], affine_map<()[s0] -> (s0 * 32, 2, 16, 32)> : !torch.vtensor<[?,2,16,32],f32>
    %int1_57 = torch.constant.int 1
    %46 = torch.aten.unsqueeze %41, %int1_57 : !torch.vtensor<[?,32],f16>, !torch.int -> !torch.vtensor<[?,1,32],f16>
    torch.bind_symbolic_shape %46, [%8], affine_map<()[s0] -> (s0 * 32, 1, 32)> : !torch.vtensor<[?,1,32],f16>
    %int32_58 = torch.constant.int 32
    %int32_59 = torch.constant.int 32
    %47 = torch.prim.ListConstruct %12, %int32_58, %int32_59 : (!torch.int, !torch.int, !torch.int) -> !torch.list<int>
    %48 = torch.aten.view %45, %47 : !torch.vtensor<[?,2,16,32],f32>, !torch.list<int> -> !torch.vtensor<[?,32,32],f32>
    torch.bind_symbolic_shape %48, [%8], affine_map<()[s0] -> (s0 * 32, 32, 32)> : !torch.vtensor<[?,32,32],f32>
    %int-2_60 = torch.constant.int -2
    %int-1_61 = torch.constant.int -1
    %49 = torch.aten.transpose.int %48, %int-2_60, %int-1_61 : !torch.vtensor<[?,32,32],f32>, !torch.int, !torch.int -> !torch.vtensor<[?,32,32],f32>
    torch.bind_symbolic_shape %49, [%8], affine_map<()[s0] -> (s0 * 32, 32, 32)> : !torch.vtensor<[?,32,32],f32>
    %int5_62 = torch.constant.int 5
    %50 = torch.prims.convert_element_type %49, %int5_62 : !torch.vtensor<[?,32,32],f32>, !torch.int -> !torch.vtensor<[?,32,32],f16>
    torch.bind_symbolic_shape %50, [%8], affine_map<()[s0] -> (s0 * 32, 32, 32)> : !torch.vtensor<[?,32,32],f16>
    %int1_63 = torch.constant.int 1
    %int32_64 = torch.constant.int 32
    %51 = torch.prim.ListConstruct %12, %int1_63, %int32_64 : (!torch.int, !torch.int, !torch.int) -> !torch.list<int>
    %false_65 = torch.constant.bool false
    %52 = torch.aten.expand %46, %51, %false_65 : !torch.vtensor<[?,1,32],f16>, !torch.list<int>, !torch.bool -> !torch.vtensor<[?,1,32],f16>
    torch.bind_symbolic_shape %52, [%8], affine_map<()[s0] -> (s0 * 32, 1, 32)> : !torch.vtensor<[?,1,32],f16>
    %int1_66 = torch.constant.int 1
    %int32_67 = torch.constant.int 32
    %53 = torch.prim.ListConstruct %12, %int1_66, %int32_67 : (!torch.int, !torch.int, !torch.int) -> !torch.list<int>
    %54 = torch.aten.view %52, %53 : !torch.vtensor<[?,1,32],f16>, !torch.list<int> -> !torch.vtensor<[?,1,32],f16>
    torch.bind_symbolic_shape %54, [%8], affine_map<()[s0] -> (s0 * 32, 1, 32)> : !torch.vtensor<[?,1,32],f16>
    %int32_68 = torch.constant.int 32
    %int32_69 = torch.constant.int 32
    %55 = torch.prim.ListConstruct %12, %int32_68, %int32_69 : (!torch.int, !torch.int, !torch.int) -> !torch.list<int>
    %false_70 = torch.constant.bool false
    %56 = torch.aten.expand %50, %55, %false_70 : !torch.vtensor<[?,32,32],f16>, !torch.list<int>, !torch.bool -> !torch.vtensor<[?,32,32],f16>
    torch.bind_symbolic_shape %56, [%8], affine_map<()[s0] -> (s0 * 32, 32, 32)> : !torch.vtensor<[?,32,32],f16>
    %int32_71 = torch.constant.int 32
    %int32_72 = torch.constant.int 32
    %57 = torch.prim.ListConstruct %12, %int32_71, %int32_72 : (!torch.int, !torch.int, !torch.int) -> !torch.list<int>
    %58 = torch.aten.view %56, %57 : !torch.vtensor<[?,32,32],f16>, !torch.list<int> -> !torch.vtensor<[?,32,32],f16>
    torch.bind_symbolic_shape %58, [%8], affine_map<()[s0] -> (s0 * 32, 32, 32)> : !torch.vtensor<[?,32,32],f16>
    %59 = torch.aten.bmm %54, %58 : !torch.vtensor<[?,1,32],f16>, !torch.vtensor<[?,32,32],f16> -> !torch.vtensor<[?,1,32],f16>
    torch.bind_symbolic_shape %59, [%8], affine_map<()[s0] -> (s0 * 32, 1, 32)> : !torch.vtensor<[?,1,32],f16>
    %int1_73 = torch.constant.int 1
    %int32_74 = torch.constant.int 32
    %60 = torch.prim.ListConstruct %12, %int1_73, %int32_74 : (!torch.int, !torch.int, !torch.int) -> !torch.list<int>
    %61 = torch.aten.view %59, %60 : !torch.vtensor<[?,1,32],f16>, !torch.list<int> -> !torch.vtensor<[?,1,32],f16>
    torch.bind_symbolic_shape %61, [%8], affine_map<()[s0] -> (s0 * 32, 1, 32)> : !torch.vtensor<[?,1,32],f16>
    %int2_75 = torch.constant.int 2
    %int16 = torch.constant.int 16
    %62 = torch.prim.ListConstruct %12, %int2_75, %int16 : (!torch.int, !torch.int, !torch.int) -> !torch.list<int>
    %63 = torch.aten.view %61, %62 : !torch.vtensor<[?,1,32],f16>, !torch.list<int> -> !torch.vtensor<[?,2,16],f16>
    torch.bind_symbolic_shape %63, [%8], affine_map<()[s0] -> (s0 * 32, 2, 16)> : !torch.vtensor<[?,2,16],f16>
    %64 = torch.aten.silu %63 : !torch.vtensor<[?,2,16],f16> -> !torch.vtensor<[?,2,16],f16>
    torch.bind_symbolic_shape %64, [%8], affine_map<()[s0] -> (s0 * 32, 2, 16)> : !torch.vtensor<[?,2,16],f16>
    %int0_76 = torch.constant.int 0
    %int0_77 = torch.constant.int 0
    %int9223372036854775807_78 = torch.constant.int 9223372036854775807
    %int1_79 = torch.constant.int 1
    %65 = torch.aten.slice.Tensor %14, %int0_76, %int0_77, %int9223372036854775807_78, %int1_79 : !torch.vtensor<[?,32],f16>, !torch.int, !torch.int, !torch.int, !torch.int -> !torch.vtensor<[?,32],f16>
    torch.bind_symbolic_shape %65, [%8], affine_map<()[s0] -> (s0 * 32, 32)> : !torch.vtensor<[?,32],f16>
    %int1_80 = torch.constant.int 1
    %int0_81 = torch.constant.int 0
    %int9223372036854775807_82 = torch.constant.int 9223372036854775807
    %int1_83 = torch.constant.int 1
    %66 = torch.aten.slice.Tensor %65, %int1_80, %int0_81, %int9223372036854775807_82, %int1_83 : !torch.vtensor<[?,32],f16>, !torch.int, !torch.int, !torch.int, !torch.int -> !torch.vtensor<[?,32],f16>
    torch.bind_symbolic_shape %66, [%8], affine_map<()[s0] -> (s0 * 32, 32)> : !torch.vtensor<[?,32],f16>
    %int1_84 = torch.constant.int 1
    %int0_85 = torch.constant.int 0
    %int9223372036854775807_86 = torch.constant.int 9223372036854775807
    %int1_87 = torch.constant.int 1
    %67 = torch.aten.slice.Tensor %3, %int1_84, %int0_85, %int9223372036854775807_86, %int1_87 : !torch.vtensor<[4,16,32],f32>, !torch.int, !torch.int, !torch.int, !torch.int -> !torch.vtensor<[4,16,32],f32>
    %int2_88 = torch.constant.int 2
    %int0_89 = torch.constant.int 0
    %int9223372036854775807_90 = torch.constant.int 9223372036854775807
    %int1_91 = torch.constant.int 1
    %68 = torch.aten.slice.Tensor %67, %int2_88, %int0_89, %int9223372036854775807_90, %int1_91 : !torch.vtensor<[4,16,32],f32>, !torch.int, !torch.int, !torch.int, !torch.int -> !torch.vtensor<[4,16,32],f32>
    %69 = torch.prim.ListConstruct %indices_41 : (!torch.vtensor<[?,2],si64>) -> !torch.list<optional<vtensor>>
    %70 = torch.aten.index.Tensor %68, %69 : !torch.vtensor<[4,16,32],f32>, !torch.list<optional<vtensor>> -> !torch.vtensor<[?,2,16,32],f32>
    torch.bind_symbolic_shape %70, [%8], affine_map<()[s0] -> (s0 * 32, 2, 16, 32)> : !torch.vtensor<[?,2,16,32],f32>
    %int1_92 = torch.constant.int 1
    %71 = torch.aten.unsqueeze %66, %int1_92 : !torch.vtensor<[?,32],f16>, !torch.int -> !torch.vtensor<[?,1,32],f16>
    torch.bind_symbolic_shape %71, [%8], affine_map<()[s0] -> (s0 * 32, 1, 32)> : !torch.vtensor<[?,1,32],f16>
    %int32_93 = torch.constant.int 32
    %int32_94 = torch.constant.int 32
    %72 = torch.prim.ListConstruct %12, %int32_93, %int32_94 : (!torch.int, !torch.int, !torch.int) -> !torch.list<int>
    %73 = torch.aten.view %70, %72 : !torch.vtensor<[?,2,16,32],f32>, !torch.list<int> -> !torch.vtensor<[?,32,32],f32>
    torch.bind_symbolic_shape %73, [%8], affine_map<()[s0] -> (s0 * 32, 32, 32)> : !torch.vtensor<[?,32,32],f32>
    %int-2_95 = torch.constant.int -2
    %int-1_96 = torch.constant.int -1
    %74 = torch.aten.transpose.int %73, %int-2_95, %int-1_96 : !torch.vtensor<[?,32,32],f32>, !torch.int, !torch.int -> !torch.vtensor<[?,32,32],f32>
    torch.bind_symbolic_shape %74, [%8], affine_map<()[s0] -> (s0 * 32, 32, 32)> : !torch.vtensor<[?,32,32],f32>
    %int5_97 = torch.constant.int 5
    %75 = torch.prims.convert_element_type %74, %int5_97 : !torch.vtensor<[?,32,32],f32>, !torch.int -> !torch.vtensor<[?,32,32],f16>
    torch.bind_symbolic_shape %75, [%8], affine_map<()[s0] -> (s0 * 32, 32, 32)> : !torch.vtensor<[?,32,32],f16>
    %int1_98 = torch.constant.int 1
    %int32_99 = torch.constant.int 32
    %76 = torch.prim.ListConstruct %12, %int1_98, %int32_99 : (!torch.int, !torch.int, !torch.int) -> !torch.list<int>
    %false_100 = torch.constant.bool false
    %77 = torch.aten.expand %71, %76, %false_100 : !torch.vtensor<[?,1,32],f16>, !torch.list<int>, !torch.bool -> !torch.vtensor<[?,1,32],f16>
    torch.bind_symbolic_shape %77, [%8], affine_map<()[s0] -> (s0 * 32, 1, 32)> : !torch.vtensor<[?,1,32],f16>
    %int1_101 = torch.constant.int 1
    %int32_102 = torch.constant.int 32
    %78 = torch.prim.ListConstruct %12, %int1_101, %int32_102 : (!torch.int, !torch.int, !torch.int) -> !torch.list<int>
    %79 = torch.aten.view %77, %78 : !torch.vtensor<[?,1,32],f16>, !torch.list<int> -> !torch.vtensor<[?,1,32],f16>
    torch.bind_symbolic_shape %79, [%8], affine_map<()[s0] -> (s0 * 32, 1, 32)> : !torch.vtensor<[?,1,32],f16>
    %int32_103 = torch.constant.int 32
    %int32_104 = torch.constant.int 32
    %80 = torch.prim.ListConstruct %12, %int32_103, %int32_104 : (!torch.int, !torch.int, !torch.int) -> !torch.list<int>
    %false_105 = torch.constant.bool false
    %81 = torch.aten.expand %75, %80, %false_105 : !torch.vtensor<[?,32,32],f16>, !torch.list<int>, !torch.bool -> !torch.vtensor<[?,32,32],f16>
    torch.bind_symbolic_shape %81, [%8], affine_map<()[s0] -> (s0 * 32, 32, 32)> : !torch.vtensor<[?,32,32],f16>
    %int32_106 = torch.constant.int 32
    %int32_107 = torch.constant.int 32
    %82 = torch.prim.ListConstruct %12, %int32_106, %int32_107 : (!torch.int, !torch.int, !torch.int) -> !torch.list<int>
    %83 = torch.aten.view %81, %82 : !torch.vtensor<[?,32,32],f16>, !torch.list<int> -> !torch.vtensor<[?,32,32],f16>
    torch.bind_symbolic_shape %83, [%8], affine_map<()[s0] -> (s0 * 32, 32, 32)> : !torch.vtensor<[?,32,32],f16>
    %84 = torch.aten.bmm %79, %83 : !torch.vtensor<[?,1,32],f16>, !torch.vtensor<[?,32,32],f16> -> !torch.vtensor<[?,1,32],f16>
    torch.bind_symbolic_shape %84, [%8], affine_map<()[s0] -> (s0 * 32, 1, 32)> : !torch.vtensor<[?,1,32],f16>
    %int1_108 = torch.constant.int 1
    %int32_109 = torch.constant.int 32
    %85 = torch.prim.ListConstruct %12, %int1_108, %int32_109 : (!torch.int, !torch.int, !torch.int) -> !torch.list<int>
    %86 = torch.aten.view %84, %85 : !torch.vtensor<[?,1,32],f16>, !torch.list<int> -> !torch.vtensor<[?,1,32],f16>
    torch.bind_symbolic_shape %86, [%8], affine_map<()[s0] -> (s0 * 32, 1, 32)> : !torch.vtensor<[?,1,32],f16>
    %int2_110 = torch.constant.int 2
    %int16_111 = torch.constant.int 16
    %87 = torch.prim.ListConstruct %12, %int2_110, %int16_111 : (!torch.int, !torch.int, !torch.int) -> !torch.list<int>
    %88 = torch.aten.view %86, %87 : !torch.vtensor<[?,1,32],f16>, !torch.list<int> -> !torch.vtensor<[?,2,16],f16>
    torch.bind_symbolic_shape %88, [%8], affine_map<()[s0] -> (s0 * 32, 2, 16)> : !torch.vtensor<[?,2,16],f16>
    %89 = torch.aten.mul.Tensor %64, %88 : !torch.vtensor<[?,2,16],f16>, !torch.vtensor<[?,2,16],f16> -> !torch.vtensor<[?,2,16],f16>
    torch.bind_symbolic_shape %89, [%8], affine_map<()[s0] -> (s0 * 32, 2, 16)> : !torch.vtensor<[?,2,16],f16>
    %int0_112 = torch.constant.int 0
    %int0_113 = torch.constant.int 0
    %int9223372036854775807_114 = torch.constant.int 9223372036854775807
    %int1_115 = torch.constant.int 1
    %90 = torch.aten.slice.Tensor %89, %int0_112, %int0_113, %int9223372036854775807_114, %int1_115 : !torch.vtensor<[?,2,16],f16>, !torch.int, !torch.int, !torch.int, !torch.int -> !torch.vtensor<[?,2,16],f16>
    torch.bind_symbolic_shape %90, [%8], affine_map<()[s0] -> (s0 * 32, 2, 16)> : !torch.vtensor<[?,2,16],f16>
    %int1_116 = torch.constant.int 1
    %int0_117 = torch.constant.int 0
    %int9223372036854775807_118 = torch.constant.int 9223372036854775807
    %int1_119 = torch.constant.int 1
    %91 = torch.aten.slice.Tensor %90, %int1_116, %int0_117, %int9223372036854775807_118, %int1_119 : !torch.vtensor<[?,2,16],f16>, !torch.int, !torch.int, !torch.int, !torch.int -> !torch.vtensor<[?,2,16],f16>
    torch.bind_symbolic_shape %91, [%8], affine_map<()[s0] -> (s0 * 32, 2, 16)> : !torch.vtensor<[?,2,16],f16>
    %int1_120 = torch.constant.int 1
    %int0_121 = torch.constant.int 0
    %int9223372036854775807_122 = torch.constant.int 9223372036854775807
    %int1_123 = torch.constant.int 1
    %92 = torch.aten.slice.Tensor %4, %int1_120, %int0_121, %int9223372036854775807_122, %int1_123 : !torch.vtensor<[4,32,16],f32>, !torch.int, !torch.int, !torch.int, !torch.int -> !torch.vtensor<[4,32,16],f32>
    %int2_124 = torch.constant.int 2
    %int0_125 = torch.constant.int 0
    %int9223372036854775807_126 = torch.constant.int 9223372036854775807
    %int1_127 = torch.constant.int 1
    %93 = torch.aten.slice.Tensor %92, %int2_124, %int0_125, %int9223372036854775807_126, %int1_127 : !torch.vtensor<[4,32,16],f32>, !torch.int, !torch.int, !torch.int, !torch.int -> !torch.vtensor<[4,32,16],f32>
    %94 = torch.prim.ListConstruct %indices_41 : (!torch.vtensor<[?,2],si64>) -> !torch.list<optional<vtensor>>
    %95 = torch.aten.index.Tensor %93, %94 : !torch.vtensor<[4,32,16],f32>, !torch.list<optional<vtensor>> -> !torch.vtensor<[?,2,32,16],f32>
    torch.bind_symbolic_shape %95, [%8], affine_map<()[s0] -> (s0 * 32, 2, 32, 16)> : !torch.vtensor<[?,2,32,16],f32>
    %int1_128 = torch.constant.int 1
    %int16_129 = torch.constant.int 16
    %96 = torch.prim.ListConstruct %29, %int1_128, %int16_129 : (!torch.int, !torch.int, !torch.int) -> !torch.list<int>
    %97 = torch.aten.view %91, %96 : !torch.vtensor<[?,2,16],f16>, !torch.list<int> -> !torch.vtensor<[?,1,16],f16>
    torch.bind_symbolic_shape %97, [%8], affine_map<()[s0] -> (s0 * 64, 1, 16)> : !torch.vtensor<[?,1,16],f16>
    %int32_130 = torch.constant.int 32
    %int16_131 = torch.constant.int 16
    %98 = torch.prim.ListConstruct %29, %int32_130, %int16_131 : (!torch.int, !torch.int, !torch.int) -> !torch.list<int>
    %99 = torch.aten.view %95, %98 : !torch.vtensor<[?,2,32,16],f32>, !torch.list<int> -> !torch.vtensor<[?,32,16],f32>
    torch.bind_symbolic_shape %99, [%8], affine_map<()[s0] -> (s0 * 64, 32, 16)> : !torch.vtensor<[?,32,16],f32>
    %int-2_132 = torch.constant.int -2
    %int-1_133 = torch.constant.int -1
    %100 = torch.aten.transpose.int %99, %int-2_132, %int-1_133 : !torch.vtensor<[?,32,16],f32>, !torch.int, !torch.int -> !torch.vtensor<[?,16,32],f32>
    torch.bind_symbolic_shape %100, [%8], affine_map<()[s0] -> (s0 * 64, 16, 32)> : !torch.vtensor<[?,16,32],f32>
    %int5_134 = torch.constant.int 5
    %101 = torch.prims.convert_element_type %100, %int5_134 : !torch.vtensor<[?,16,32],f32>, !torch.int -> !torch.vtensor<[?,16,32],f16>
    torch.bind_symbolic_shape %101, [%8], affine_map<()[s0] -> (s0 * 64, 16, 32)> : !torch.vtensor<[?,16,32],f16>
    %int1_135 = torch.constant.int 1
    %int16_136 = torch.constant.int 16
    %102 = torch.prim.ListConstruct %29, %int1_135, %int16_136 : (!torch.int, !torch.int, !torch.int) -> !torch.list<int>
    %false_137 = torch.constant.bool false
    %103 = torch.aten.expand %97, %102, %false_137 : !torch.vtensor<[?,1,16],f16>, !torch.list<int>, !torch.bool -> !torch.vtensor<[?,1,16],f16>
    torch.bind_symbolic_shape %103, [%8], affine_map<()[s0] -> (s0 * 64, 1, 16)> : !torch.vtensor<[?,1,16],f16>
    %int1_138 = torch.constant.int 1
    %int16_139 = torch.constant.int 16
    %104 = torch.prim.ListConstruct %29, %int1_138, %int16_139 : (!torch.int, !torch.int, !torch.int) -> !torch.list<int>
    %105 = torch.aten.view %103, %104 : !torch.vtensor<[?,1,16],f16>, !torch.list<int> -> !torch.vtensor<[?,1,16],f16>
    torch.bind_symbolic_shape %105, [%8], affine_map<()[s0] -> (s0 * 64, 1, 16)> : !torch.vtensor<[?,1,16],f16>
    %int16_140 = torch.constant.int 16
    %int32_141 = torch.constant.int 32
    %106 = torch.prim.ListConstruct %29, %int16_140, %int32_141 : (!torch.int, !torch.int, !torch.int) -> !torch.list<int>
    %false_142 = torch.constant.bool false
    %107 = torch.aten.expand %101, %106, %false_142 : !torch.vtensor<[?,16,32],f16>, !torch.list<int>, !torch.bool -> !torch.vtensor<[?,16,32],f16>
    torch.bind_symbolic_shape %107, [%8], affine_map<()[s0] -> (s0 * 64, 16, 32)> : !torch.vtensor<[?,16,32],f16>
    %int16_143 = torch.constant.int 16
    %int32_144 = torch.constant.int 32
    %108 = torch.prim.ListConstruct %29, %int16_143, %int32_144 : (!torch.int, !torch.int, !torch.int) -> !torch.list<int>
    %109 = torch.aten.view %107, %108 : !torch.vtensor<[?,16,32],f16>, !torch.list<int> -> !torch.vtensor<[?,16,32],f16>
    torch.bind_symbolic_shape %109, [%8], affine_map<()[s0] -> (s0 * 64, 16, 32)> : !torch.vtensor<[?,16,32],f16>
    %110 = torch.aten.bmm %105, %109 : !torch.vtensor<[?,1,16],f16>, !torch.vtensor<[?,16,32],f16> -> !torch.vtensor<[?,1,32],f16>
    torch.bind_symbolic_shape %110, [%8], affine_map<()[s0] -> (s0 * 64, 1, 32)> : !torch.vtensor<[?,1,32],f16>
    %int1_145 = torch.constant.int 1
    %int32_146 = torch.constant.int 32
    %111 = torch.prim.ListConstruct %29, %int1_145, %int32_146 : (!torch.int, !torch.int, !torch.int) -> !torch.list<int>
    %112 = torch.aten.view %110, %111 : !torch.vtensor<[?,1,32],f16>, !torch.list<int> -> !torch.vtensor<[?,1,32],f16>
    torch.bind_symbolic_shape %112, [%8], affine_map<()[s0] -> (s0 * 64, 1, 32)> : !torch.vtensor<[?,1,32],f16>
    %int2_147 = torch.constant.int 2
    %int32_148 = torch.constant.int 32
    %113 = torch.prim.ListConstruct %12, %int2_147, %int32_148 : (!torch.int, !torch.int, !torch.int) -> !torch.list<int>
    %114 = torch.aten.view %112, %113 : !torch.vtensor<[?,1,32],f16>, !torch.list<int> -> !torch.vtensor<[?,2,32],f16>
    torch.bind_symbolic_shape %114, [%8], affine_map<()[s0] -> (s0 * 32, 2, 32)> : !torch.vtensor<[?,2,32],f16>
    %int1_149 = torch.constant.int 1
    %int1_150 = torch.constant.int 1
    %115 = torch.prim.ListConstruct %29, %int1_149, %int1_150 : (!torch.int, !torch.int, !torch.int) -> !torch.list<int>
    %116 = torch.aten.view %values_40, %115 : !torch.vtensor<[?,2],f32>, !torch.list<int> -> !torch.vtensor<[?,1,1],f32>
    torch.bind_symbolic_shape %116, [%8], affine_map<()[s0] -> (s0 * 64, 1, 1)> : !torch.vtensor<[?,1,1],f32>
    %int32_151 = torch.constant.int 32
    %int1_152 = torch.constant.int 1
    %117 = torch.prim.ListConstruct %29, %int32_151, %int1_152 : (!torch.int, !torch.int, !torch.int) -> !torch.list<int>
    %118 = torch.aten.view %114, %117 : !torch.vtensor<[?,2,32],f16>, !torch.list<int> -> !torch.vtensor<[?,32,1],f16>
    torch.bind_symbolic_shape %118, [%8], affine_map<()[s0] -> (s0 * 64, 32, 1)> : !torch.vtensor<[?,32,1],f16>
    %int-2_153 = torch.constant.int -2
    %int-1_154 = torch.constant.int -1
    %119 = torch.aten.transpose.int %118, %int-2_153, %int-1_154 : !torch.vtensor<[?,32,1],f16>, !torch.int, !torch.int -> !torch.vtensor<[?,1,32],f16>
    torch.bind_symbolic_shape %119, [%8], affine_map<()[s0] -> (s0 * 64, 1, 32)> : !torch.vtensor<[?,1,32],f16>
    %int6_155 = torch.constant.int 6
    %120 = torch.prims.convert_element_type %119, %int6_155 : !torch.vtensor<[?,1,32],f16>, !torch.int -> !torch.vtensor<[?,1,32],f32>
    torch.bind_symbolic_shape %120, [%8], affine_map<()[s0] -> (s0 * 64, 1, 32)> : !torch.vtensor<[?,1,32],f32>
    %int1_156 = torch.constant.int 1
    %int1_157 = torch.constant.int 1
    %121 = torch.prim.ListConstruct %29, %int1_156, %int1_157 : (!torch.int, !torch.int, !torch.int) -> !torch.list<int>
    %false_158 = torch.constant.bool false
    %122 = torch.aten.expand %116, %121, %false_158 : !torch.vtensor<[?,1,1],f32>, !torch.list<int>, !torch.bool -> !torch.vtensor<[?,1,1],f32>
    torch.bind_symbolic_shape %122, [%8], affine_map<()[s0] -> (s0 * 64, 1, 1)> : !torch.vtensor<[?,1,1],f32>
    %int1_159 = torch.constant.int 1
    %int1_160 = torch.constant.int 1
    %123 = torch.prim.ListConstruct %29, %int1_159, %int1_160 : (!torch.int, !torch.int, !torch.int) -> !torch.list<int>
    %124 = torch.aten.view %122, %123 : !torch.vtensor<[?,1,1],f32>, !torch.list<int> -> !torch.vtensor<[?,1,1],f32>
    torch.bind_symbolic_shape %124, [%8], affine_map<()[s0] -> (s0 * 64, 1, 1)> : !torch.vtensor<[?,1,1],f32>
    %int1_161 = torch.constant.int 1
    %int32_162 = torch.constant.int 32
    %125 = torch.prim.ListConstruct %29, %int1_161, %int32_162 : (!torch.int, !torch.int, !torch.int) -> !torch.list<int>
    %false_163 = torch.constant.bool false
    %126 = torch.aten.expand %120, %125, %false_163 : !torch.vtensor<[?,1,32],f32>, !torch.list<int>, !torch.bool -> !torch.vtensor<[?,1,32],f32>
    torch.bind_symbolic_shape %126, [%8], affine_map<()[s0] -> (s0 * 64, 1, 32)> : !torch.vtensor<[?,1,32],f32>
    %int1_164 = torch.constant.int 1
    %int32_165 = torch.constant.int 32
    %127 = torch.prim.ListConstruct %29, %int1_164, %int32_165 : (!torch.int, !torch.int, !torch.int) -> !torch.list<int>
    %128 = torch.aten.view %126, %127 : !torch.vtensor<[?,1,32],f32>, !torch.list<int> -> !torch.vtensor<[?,1,32],f32>
    torch.bind_symbolic_shape %128, [%8], affine_map<()[s0] -> (s0 * 64, 1, 32)> : !torch.vtensor<[?,1,32],f32>
    %129 = torch.aten.bmm %124, %128 : !torch.vtensor<[?,1,1],f32>, !torch.vtensor<[?,1,32],f32> -> !torch.vtensor<[?,1,32],f32>
    torch.bind_symbolic_shape %129, [%8], affine_map<()[s0] -> (s0 * 64, 1, 32)> : !torch.vtensor<[?,1,32],f32>
    %int1_166 = torch.constant.int 1
    %int32_167 = torch.constant.int 32
    %130 = torch.prim.ListConstruct %29, %int1_166, %int32_167 : (!torch.int, !torch.int, !torch.int) -> !torch.list<int>
    %131 = torch.aten.view %129, %130 : !torch.vtensor<[?,1,32],f32>, !torch.list<int> -> !torch.vtensor<[?,1,32],f32>
    torch.bind_symbolic_shape %131, [%8], affine_map<()[s0] -> (s0 * 64, 1, 32)> : !torch.vtensor<[?,1,32],f32>
    %int2_168 = torch.constant.int 2
    %int32_169 = torch.constant.int 32
    %132 = torch.prim.ListConstruct %12, %int2_168, %int32_169 : (!torch.int, !torch.int, !torch.int) -> !torch.list<int>
    %133 = torch.aten.view %131, %132 : !torch.vtensor<[?,1,32],f32>, !torch.list<int> -> !torch.vtensor<[?,2,32],f32>
    torch.bind_symbolic_shape %133, [%8], affine_map<()[s0] -> (s0 * 32, 2, 32)> : !torch.vtensor<[?,2,32],f32>
    %int1_170 = torch.constant.int 1
    %134 = torch.prim.ListConstruct %int1_170 : (!torch.int) -> !torch.list<int>
    %false_171 = torch.constant.bool false
    %none_172 = torch.constant.none
    %135 = torch.aten.sum.dim_IntList %133, %134, %false_171, %none_172 : !torch.vtensor<[?,2,32],f32>, !torch.list<int>, !torch.bool, !torch.none -> !torch.vtensor<[?,32],f32>
    torch.bind_symbolic_shape %135, [%8], affine_map<()[s0] -> (s0 * 32, 32)> : !torch.vtensor<[?,32],f32>
    %int1_173 = torch.constant.int 1
    %int32_174 = torch.constant.int 32
    %136 = torch.prim.ListConstruct %int1_173, %12, %int32_174 : (!torch.int, !torch.int, !torch.int) -> !torch.list<int>
    %137 = torch.aten.view %135, %136 : !torch.vtensor<[?,32],f32>, !torch.list<int> -> !torch.vtensor<[1,?,32],f32>
    torch.bind_symbolic_shape %137, [%8], affine_map<()[s0] -> (1, s0 * 32, 32)> : !torch.vtensor<[1,?,32],f32>
    %int6_175 = torch.constant.int 6
    %138 = torch.prims.convert_element_type %137, %int6_175 : !torch.vtensor<[1,?,32],f32>, !torch.int -> !torch.vtensor<[1,?,32],f32>
    torch.bind_symbolic_shape %138, [%8], affine_map<()[s0] -> (1, s0 * 32, 32)> : !torch.vtensor<[1,?,32],f32>
    %int2_176 = torch.constant.int 2
    %139 = torch.aten.pow.Tensor_Scalar %138, %int2_176 : !torch.vtensor<[1,?,32],f32>, !torch.int -> !torch.vtensor<[1,?,32],f32>
    torch.bind_symbolic_shape %139, [%8], affine_map<()[s0] -> (1, s0 * 32, 32)> : !torch.vtensor<[1,?,32],f32>
    %int-1_177 = torch.constant.int -1
    %140 = torch.prim.ListConstruct %int-1_177 : (!torch.int) -> !torch.list<int>
    %true_178 = torch.constant.bool true
    %none_179 = torch.constant.none
    %141 = torch.aten.mean.dim %139, %140, %true_178, %none_179 : !torch.vtensor<[1,?,32],f32>, !torch.list<int>, !torch.bool, !torch.none -> !torch.vtensor<[1,?,1],f32>
    torch.bind_symbolic_shape %141, [%8], affine_map<()[s0] -> (1, s0 * 32, 1)> : !torch.vtensor<[1,?,1],f32>
    %float9.000000e00 = torch.constant.float 9.000000e+00
    %int1_180 = torch.constant.int 1
    %142 = torch.aten.add.Scalar %141, %float9.000000e00, %int1_180 : !torch.vtensor<[1,?,1],f32>, !torch.float, !torch.int -> !torch.vtensor<[1,?,1],f32>
    torch.bind_symbolic_shape %142, [%8], affine_map<()[s0] -> (1, s0 * 32, 1)> : !torch.vtensor<[1,?,1],f32>
    %143 = torch.aten.rsqrt %142 : !torch.vtensor<[1,?,1],f32> -> !torch.vtensor<[1,?,1],f32>
    torch.bind_symbolic_shape %143, [%8], affine_map<()[s0] -> (1, s0 * 32, 1)> : !torch.vtensor<[1,?,1],f32>
    %144 = torch.aten.mul.Tensor %138, %143 : !torch.vtensor<[1,?,32],f32>, !torch.vtensor<[1,?,1],f32> -> !torch.vtensor<[1,?,32],f32>
    torch.bind_symbolic_shape %144, [%8], affine_map<()[s0] -> (1, s0 * 32, 32)> : !torch.vtensor<[1,?,32],f32>
    %int6_181 = torch.constant.int 6
    %145 = torch.prims.convert_element_type %144, %int6_181 : !torch.vtensor<[1,?,32],f32>, !torch.int -> !torch.vtensor<[1,?,32],f32>
    torch.bind_symbolic_shape %145, [%8], affine_map<()[s0] -> (1, s0 * 32, 32)> : !torch.vtensor<[1,?,32],f32>
    %146 = torch.aten.mul.Tensor %5, %145 : !torch.vtensor<[32],f32>, !torch.vtensor<[1,?,32],f32> -> !torch.vtensor<[1,?,32],f32>
    torch.bind_symbolic_shape %146, [%8], affine_map<()[s0] -> (1, s0 * 32, 32)> : !torch.vtensor<[1,?,32],f32>
    %int6_182 = torch.constant.int 6
    %147 = torch.prims.convert_element_type %146, %int6_182 : !torch.vtensor<[1,?,32],f32>, !torch.int -> !torch.vtensor<[1,?,32],f32>
    torch.bind_symbolic_shape %147, [%8], affine_map<()[s0] -> (1, s0 * 32, 32)> : !torch.vtensor<[1,?,32],f32>
    %int-2_183 = torch.constant.int -2
    %int-1_184 = torch.constant.int -1
    %148 = torch.aten.transpose.int %6, %int-2_183, %int-1_184 : !torch.vtensor<[256,32],f32>, !torch.int, !torch.int -> !torch.vtensor<[32,256],f32>
    %int6_185 = torch.constant.int 6
    %149 = torch.prims.convert_element_type %148, %int6_185 : !torch.vtensor<[32,256],f32>, !torch.int -> !torch.vtensor<[32,256],f32>
    %int32_186 = torch.constant.int 32
    %150 = torch.prim.ListConstruct %12, %int32_186 : (!torch.int, !torch.int) -> !torch.list<int>
    %151 = torch.aten.view %147, %150 : !torch.vtensor<[1,?,32],f32>, !torch.list<int> -> !torch.vtensor<[?,32],f32>
    torch.bind_symbolic_shape %151, [%8], affine_map<()[s0] -> (s0 * 32, 32)> : !torch.vtensor<[?,32],f32>
    %152 = torch.aten.mm %151, %149 : !torch.vtensor<[?,32],f32>, !torch.vtensor<[32,256],f32> -> !torch.vtensor<[?,256],f32>
    torch.bind_symbolic_shape %152, [%8], affine_map<()[s0] -> (s0 * 32, 256)> : !torch.vtensor<[?,256],f32>
    %int1_187 = torch.constant.int 1
    %int256 = torch.constant.int 256
    %153 = torch.prim.ListConstruct %int1_187, %12, %int256 : (!torch.int, !torch.int, !torch.int) -> !torch.list<int>
    %154 = torch.aten.view %152, %153 : !torch.vtensor<[?,256],f32>, !torch.list<int> -> !torch.vtensor<[1,?,256],f32>
    torch.bind_symbolic_shape %154, [%8], affine_map<()[s0] -> (1, s0 * 32, 256)> : !torch.vtensor<[1,?,256],f32>
    return %154 : !torch.vtensor<[1,?,256],f32>
  }
}
