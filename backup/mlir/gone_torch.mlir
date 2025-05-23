// -----// IR Dump Before FuseQuantizedOps (torch-fuse-quantized-ops) //----- //
func.func @prefill_bs1(%arg0: !torch.vtensor<[1,?],si64>, %arg1: !torch.vtensor<[1],si64>, %arg2: !torch.vtensor<[1,?],si64>, %arg3: !torch.vtensor<[?,49152],f16>) -> !torch.vtensor<[1,?,256],f32> attributes {torch.assume_strict_symbolic_shapes} {
  %0 = torch.vtensor.literal(dense<0.000000e+00> : tensor<f64>) : !torch.vtensor<[],f64>
  %1 = torch.vtensor.literal(dense<1> : tensor<si64>) : !torch.vtensor<[],si64>
  %2 = torch.vtensor.literal(dense<0> : tensor<si64>) : !torch.vtensor<[],si64>
  %int0 = torch.constant.int 0
  %int256 = torch.constant.int 256
  %float9.000000e00 = torch.constant.float 9.000000e+00
  %int16 = torch.constant.int 16
  %int11 = torch.constant.int 11
  %none = torch.constant.none
  %true = torch.constant.bool true
  %int2 = torch.constant.int 2
  %int4 = torch.constant.int 4
  %int6 = torch.constant.int 6
  %int-2 = torch.constant.int -2
  %int32 = torch.constant.int 32
  %int1 = torch.constant.int 1
  %false = torch.constant.bool false
  %int-1 = torch.constant.int -1
  %int5 = torch.constant.int 5
  %c32 = arith.constant 32 : index
  %c1 = arith.constant 1 : index
  %3 = torch_c.to_builtin_tensor %arg2 : !torch.vtensor<[1,?],si64> -> tensor<1x?xi64>
  %dim = tensor.dim %3, %c1 : tensor<1x?xi64>
  %4 = torch_c.to_builtin_tensor %arg0 : !torch.vtensor<[1,?],si64> -> tensor<1x?xi64>
  %__auto.token_embd.weight = util.global.load @__auto.token_embd.weight : tensor<256x32xf32>
  %5 = torch_c.from_builtin_tensor %__auto.token_embd.weight : tensor<256x32xf32> -> !torch.vtensor<[256,32],f32>
  %__auto.blk.0.ffn_gate_inp.weight = util.global.load @__auto.blk.0.ffn_gate_inp.weight : tensor<4x32xf32>
  %6 = torch_c.from_builtin_tensor %__auto.blk.0.ffn_gate_inp.weight : tensor<4x32xf32> -> !torch.vtensor<[4,32],f32>
  %__auto.blk.0.ffn_gate_exps.weight = util.global.load @__auto.blk.0.ffn_gate_exps.weight : tensor<4x16x32xf32>
  %7 = torch_c.from_builtin_tensor %__auto.blk.0.ffn_gate_exps.weight : tensor<4x16x32xf32> -> !torch.vtensor<[4,16,32],f32>
  %__auto.blk.0.ffn_up_exps.weight = util.global.load @__auto.blk.0.ffn_up_exps.weight : tensor<4x16x32xf32>
  %8 = torch_c.from_builtin_tensor %__auto.blk.0.ffn_up_exps.weight : tensor<4x16x32xf32> -> !torch.vtensor<[4,16,32],f32>
  %__auto.blk.0.ffn_down_exps.weight = util.global.load @__auto.blk.0.ffn_down_exps.weight : tensor<4x32x16xf32>
  %9 = torch_c.from_builtin_tensor %__auto.blk.0.ffn_down_exps.weight : tensor<4x32x16xf32> -> !torch.vtensor<[4,32,16],f32>
  %__auto.output_norm.weight = util.global.load @__auto.output_norm.weight : tensor<32xf32>
  %10 = torch_c.from_builtin_tensor %__auto.output_norm.weight : tensor<32xf32> -> !torch.vtensor<[32],f32>
  %__auto.output.weight = util.global.load @__auto.output.weight : tensor<256x32xf32>
  %11 = torch_c.from_builtin_tensor %__auto.output.weight : tensor<256x32xf32> -> !torch.vtensor<[256,32],f32>
  %12 = arith.muli %dim, %c32 : index
  %13 = util.assume.int %12<umin = 32, umax = 224, udiv = 32> : index
  %14 = flow.tensor.tie_shape %4 : tensor<1x?xi64>{%13}
  %15 = torch_c.from_builtin_tensor %14 : tensor<1x?xi64> -> !torch.vtensor<[1,?],si64>
  %16 = torch.aten.to.dtype %5, %int5, %false, %false, %none : !torch.vtensor<[256,32],f32>, !torch.int, !torch.bool, !torch.bool, !torch.none -> !torch.vtensor<[256,32],f16>
  %17 = torch.aten.embedding %16, %15, %int-1, %false, %false : !torch.vtensor<[256,32],f16>, !torch.vtensor<[1,?],si64>, !torch.int, !torch.bool, !torch.bool -> !torch.vtensor<[1,?,32],f16>
  %18 = torch.aten.size.int %15, %int1 : !torch.vtensor<[1,?],si64>, !torch.int -> !torch.int
  %19 = torch.prim.ListConstruct %int-1, %int32 : (!torch.int, !torch.int) -> !torch.list<int>
  %20 = torch.aten.view %17, %19 : !torch.vtensor<[1,?,32],f16>, !torch.list<int> -> !torch.vtensor<[?,32],f16>
  %21 = torch.aten.to.dtype %6, %int5, %false, %false, %none : !torch.vtensor<[4,32],f32>, !torch.int, !torch.bool, !torch.bool, !torch.none -> !torch.vtensor<[4,32],f16>
  %22 = torch.aten.transpose.int %21, %int-2, %int-1 : !torch.vtensor<[4,32],f16>, !torch.int, !torch.int -> !torch.vtensor<[32,4],f16>
  %23 = torch.aten.mm %20, %22 : !torch.vtensor<[?,32],f16>, !torch.vtensor<[32,4],f16> -> !torch.vtensor<[?,4],f16>
  %24 = torch.aten.to.dtype %23, %int6, %false, %false, %none : !torch.vtensor<[?,4],f16>, !torch.int, !torch.bool, !torch.bool, !torch.none -> !torch.vtensor<[?,4],f32>
  %25 = torch.aten.sigmoid %24 : !torch.vtensor<[?,4],f32> -> !torch.vtensor<[?,4],f32>
  %26 = torch.prim.ListConstruct %int-1, %int4 : (!torch.int, !torch.int) -> !torch.list<int>
  %27 = torch.aten.view %25, %26 : !torch.vtensor<[?,4],f32>, !torch.list<int> -> !torch.vtensor<[?,4],f32>
  %28 = torch.prim.ListConstruct %int-1, %int2, %int2 : (!torch.int, !torch.int, !torch.int) -> !torch.list<int>
  %29 = torch.aten.view %25, %28 : !torch.vtensor<[?,4],f32>, !torch.list<int> -> !torch.vtensor<[?,2,2],f32>
  %values, %indices = torch.aten.sort %29, %int-1, %true : !torch.vtensor<[?,2,2],f32>, !torch.int, !torch.bool -> !torch.vtensor<[?,2,2],f32>, !torch.vtensor<[?,2,2],si64>
  %30 = torch.aten.slice.Tensor %values, %int-1, %int0, %int2, %int1 : !torch.vtensor<[?,2,2],f32>, !torch.int, !torch.int, !torch.int, !torch.int -> !torch.vtensor<[?,2,2],f32>
  %31 = torch.aten.slice.Tensor %indices, %int-1, %int0, %int2, %int1 : !torch.vtensor<[?,2,2],si64>, !torch.int, !torch.int, !torch.int, !torch.int -> !torch.vtensor<[?,2,2],si64>
  %32 = torch.prim.ListConstruct %int-1 : (!torch.int) -> !torch.list<int>
  %33 = torch.aten.sum.dim_IntList %30, %32, %false, %none : !torch.vtensor<[?,2,2],f32>, !torch.list<int>, !torch.bool, !torch.none -> !torch.vtensor<[?,2],f32>
  %values_0, %indices_1 = torch.aten.sort %33, %int-1, %true : !torch.vtensor<[?,2],f32>, !torch.int, !torch.bool -> !torch.vtensor<[?,2],f32>, !torch.vtensor<[?,2],si64>
  %34 = torch.aten.slice.Tensor %values_0, %int-1, %int0, %int1, %int1 : !torch.vtensor<[?,2],f32>, !torch.int, !torch.int, !torch.int, !torch.int -> !torch.vtensor<[?,1],f32>
  %35 = torch.aten.slice.Tensor %indices_1, %int-1, %int0, %int1, %int1 : !torch.vtensor<[?,2],si64>, !torch.int, !torch.int, !torch.int, !torch.int -> !torch.vtensor<[?,1],si64>
  %36 = torch.aten.to.dtype %2, %int6, %false, %false, %none : !torch.vtensor<[],si64>, !torch.int, !torch.bool, !torch.bool, !torch.none -> !torch.vtensor<[],f32>
  %37 = torch.aten.size.int %33, %int0 : !torch.vtensor<[?,2],f32>, !torch.int -> !torch.int
  %38 = torch.prim.ListConstruct %37, %int2 : (!torch.int, !torch.int) -> !torch.list<int>
  %39 = torch.aten.broadcast_to %36, %38 : !torch.vtensor<[],f32>, !torch.list<int> -> !torch.vtensor<[?,2],f32>
  %40 = torch.aten.size.int %35, %int0 : !torch.vtensor<[?,1],si64>, !torch.int -> !torch.int
  %41 = torch.prim.ListConstruct %40, %int1 : (!torch.int, !torch.int) -> !torch.list<int>
  %42 = torch.aten.to.dtype %1, %int6, %false, %false, %none : !torch.vtensor<[],si64>, !torch.int, !torch.bool, !torch.bool, !torch.none -> !torch.vtensor<[],f32>
  %43 = torch.aten.broadcast_to %42, %41 : !torch.vtensor<[],f32>, !torch.list<int> -> !torch.vtensor<[?,1],f32>
  %44 = torch.aten.scatter.src %39, %int1, %35, %43 : !torch.vtensor<[?,2],f32>, !torch.int, !torch.vtensor<[?,1],si64>, !torch.vtensor<[?,1],f32> -> !torch.vtensor<[?,2],f32>
  %45 = torch.aten.mul.int %18, %int2 : !torch.int, !torch.int -> !torch.int
  %46 = torch.aten.unsqueeze %44, %int-1 : !torch.vtensor<[?,2],f32>, !torch.int -> !torch.vtensor<[?,2,1],f32>
  %47 = torch.prim.ListConstruct %int-1, %int2, %int2 : (!torch.int, !torch.int, !torch.int) -> !torch.list<int>
  %48 = torch.aten.broadcast_to %46, %47 : !torch.vtensor<[?,2,1],f32>, !torch.list<int> -> !torch.vtensor<[?,2,2],f32>
  %49 = torch.prim.ListConstruct %18, %int4 : (!torch.int, !torch.int) -> !torch.list<int>
  %50 = torch.aten.view %48, %49 : !torch.vtensor<[?,2,2],f32>, !torch.list<int> -> !torch.vtensor<[?,4],f32>
  %51 = torch.aten.to.dtype %50, %int11, %false, %false, %none : !torch.vtensor<[?,4],f32>, !torch.int, !torch.bool, !torch.bool, !torch.none -> !torch.vtensor<[?,4],i1>
  %52 = torch.aten.bitwise_not %51 : !torch.vtensor<[?,4],i1> -> !torch.vtensor<[?,4],i1>
  %53 = torch.aten.to.dtype %0, %int6, %false, %false, %none : !torch.vtensor<[],f64>, !torch.int, !torch.bool, !torch.bool, !torch.none -> !torch.vtensor<[],f32>
  %54 = torch.aten.where.self %52, %53, %27 : !torch.vtensor<[?,4],i1>, !torch.vtensor<[],f32>, !torch.vtensor<[?,4],f32> -> !torch.vtensor<[?,4],f32>
  %values_2, %indices_3 = torch.aten.sort %54, %int-1, %true : !torch.vtensor<[?,4],f32>, !torch.int, !torch.bool -> !torch.vtensor<[?,4],f32>, !torch.vtensor<[?,4],si64>
  %55 = torch.aten.slice.Tensor %values_2, %int-1, %int0, %int2, %int1 : !torch.vtensor<[?,4],f32>, !torch.int, !torch.int, !torch.int, !torch.int -> !torch.vtensor<[?,2],f32>
  %56 = torch.aten.slice.Tensor %indices_3, %int-1, %int0, %int2, %int1 : !torch.vtensor<[?,4],si64>, !torch.int, !torch.int, !torch.int, !torch.int -> !torch.vtensor<[?,2],si64>
  %57 = torch.prim.ListConstruct %56 : (!torch.vtensor<[?,2],si64>) -> !torch.list<vtensor>
  %58 = torch.aten.index.Tensor_hacked_twin %7, %57 : !torch.vtensor<[4,16,32],f32>, !torch.list<vtensor> -> !torch.vtensor<[?,2,16,32],f32>
  %59 = torch.aten.unsqueeze %20, %int1 : !torch.vtensor<[?,32],f16>, !torch.int -> !torch.vtensor<[?,1,32],f16>
  %60 = torch.prim.ListConstruct %18, %int32, %int32 : (!torch.int, !torch.int, !torch.int) -> !torch.list<int>
  %61 = torch.aten.view %58, %60 : !torch.vtensor<[?,2,16,32],f32>, !torch.list<int> -> !torch.vtensor<[?,32,32],f32>
  %62 = torch.aten.transpose.int %61, %int-2, %int-1 : !torch.vtensor<[?,32,32],f32>, !torch.int, !torch.int -> !torch.vtensor<[?,32,32],f32>
  %63 = torch.aten.to.dtype %62, %int5, %false, %false, %none : !torch.vtensor<[?,32,32],f32>, !torch.int, !torch.bool, !torch.bool, !torch.none -> !torch.vtensor<[?,32,32],f16>
  %64 = torch.prim.ListConstruct %18, %int1, %int32 : (!torch.int, !torch.int, !torch.int) -> !torch.list<int>
  %65 = torch.aten.broadcast_to %59, %64 : !torch.vtensor<[?,1,32],f16>, !torch.list<int> -> !torch.vtensor<[?,1,32],f16>
  %66 = torch.prim.ListConstruct %18, %int1, %int32 : (!torch.int, !torch.int, !torch.int) -> !torch.list<int>
  %67 = torch.aten.view %65, %66 : !torch.vtensor<[?,1,32],f16>, !torch.list<int> -> !torch.vtensor<[?,1,32],f16>
  %68 = torch.prim.ListConstruct %18, %int32, %int32 : (!torch.int, !torch.int, !torch.int) -> !torch.list<int>
  %69 = torch.aten.broadcast_to %63, %68 : !torch.vtensor<[?,32,32],f16>, !torch.list<int> -> !torch.vtensor<[?,32,32],f16>
  %70 = torch.prim.ListConstruct %18, %int32, %int32 : (!torch.int, !torch.int, !torch.int) -> !torch.list<int>
  %71 = torch.aten.view %69, %70 : !torch.vtensor<[?,32,32],f16>, !torch.list<int> -> !torch.vtensor<[?,32,32],f16>
  %72 = torch.aten.bmm %67, %71 : !torch.vtensor<[?,1,32],f16>, !torch.vtensor<[?,32,32],f16> -> !torch.vtensor<[?,1,32],f16>
  %73 = torch.prim.ListConstruct %18, %int1, %int32 : (!torch.int, !torch.int, !torch.int) -> !torch.list<int>
  %74 = torch.aten.view %72, %73 : !torch.vtensor<[?,1,32],f16>, !torch.list<int> -> !torch.vtensor<[?,1,32],f16>
  %75 = torch.prim.ListConstruct %18, %int2, %int16 : (!torch.int, !torch.int, !torch.int) -> !torch.list<int>
  %76 = torch.aten.view %74, %75 : !torch.vtensor<[?,1,32],f16>, !torch.list<int> -> !torch.vtensor<[?,2,16],f16>
  %77 = torch.aten.sigmoid %76 : !torch.vtensor<[?,2,16],f16> -> !torch.vtensor<[?,2,16],f16>
  %78 = torch.aten.mul.Tensor %77, %76 : !torch.vtensor<[?,2,16],f16>, !torch.vtensor<[?,2,16],f16> -> !torch.vtensor<[?,2,16],f16>
  %79 = torch.prim.ListConstruct %56 : (!torch.vtensor<[?,2],si64>) -> !torch.list<vtensor>
  %80 = torch.aten.index.Tensor_hacked_twin %8, %79 : !torch.vtensor<[4,16,32],f32>, !torch.list<vtensor> -> !torch.vtensor<[?,2,16,32],f32>
  %81 = torch.aten.unsqueeze %20, %int1 : !torch.vtensor<[?,32],f16>, !torch.int -> !torch.vtensor<[?,1,32],f16>
  %82 = torch.prim.ListConstruct %18, %int32, %int32 : (!torch.int, !torch.int, !torch.int) -> !torch.list<int>
  %83 = torch.aten.view %80, %82 : !torch.vtensor<[?,2,16,32],f32>, !torch.list<int> -> !torch.vtensor<[?,32,32],f32>
  %84 = torch.aten.transpose.int %83, %int-2, %int-1 : !torch.vtensor<[?,32,32],f32>, !torch.int, !torch.int -> !torch.vtensor<[?,32,32],f32>
  %85 = torch.aten.to.dtype %84, %int5, %false, %false, %none : !torch.vtensor<[?,32,32],f32>, !torch.int, !torch.bool, !torch.bool, !torch.none -> !torch.vtensor<[?,32,32],f16>
  %86 = torch.prim.ListConstruct %18, %int1, %int32 : (!torch.int, !torch.int, !torch.int) -> !torch.list<int>
  %87 = torch.aten.broadcast_to %81, %86 : !torch.vtensor<[?,1,32],f16>, !torch.list<int> -> !torch.vtensor<[?,1,32],f16>
  %88 = torch.prim.ListConstruct %18, %int1, %int32 : (!torch.int, !torch.int, !torch.int) -> !torch.list<int>
  %89 = torch.aten.view %87, %88 : !torch.vtensor<[?,1,32],f16>, !torch.list<int> -> !torch.vtensor<[?,1,32],f16>
  %90 = torch.prim.ListConstruct %18, %int32, %int32 : (!torch.int, !torch.int, !torch.int) -> !torch.list<int>
  %91 = torch.aten.broadcast_to %85, %90 : !torch.vtensor<[?,32,32],f16>, !torch.list<int> -> !torch.vtensor<[?,32,32],f16>
  %92 = torch.prim.ListConstruct %18, %int32, %int32 : (!torch.int, !torch.int, !torch.int) -> !torch.list<int>
  %93 = torch.aten.view %91, %92 : !torch.vtensor<[?,32,32],f16>, !torch.list<int> -> !torch.vtensor<[?,32,32],f16>
  %94 = torch.aten.bmm %89, %93 : !torch.vtensor<[?,1,32],f16>, !torch.vtensor<[?,32,32],f16> -> !torch.vtensor<[?,1,32],f16>
  %95 = torch.prim.ListConstruct %18, %int1, %int32 : (!torch.int, !torch.int, !torch.int) -> !torch.list<int>
  %96 = torch.aten.view %94, %95 : !torch.vtensor<[?,1,32],f16>, !torch.list<int> -> !torch.vtensor<[?,1,32],f16>
  %97 = torch.prim.ListConstruct %18, %int2, %int16 : (!torch.int, !torch.int, !torch.int) -> !torch.list<int>
  %98 = torch.aten.view %96, %97 : !torch.vtensor<[?,1,32],f16>, !torch.list<int> -> !torch.vtensor<[?,2,16],f16>
  %99 = torch.aten.mul.Tensor %78, %98 : !torch.vtensor<[?,2,16],f16>, !torch.vtensor<[?,2,16],f16> -> !torch.vtensor<[?,2,16],f16>
  %100 = torch.prim.ListConstruct %56 : (!torch.vtensor<[?,2],si64>) -> !torch.list<vtensor>
  %101 = torch.aten.index.Tensor_hacked_twin %9, %100 : !torch.vtensor<[4,32,16],f32>, !torch.list<vtensor> -> !torch.vtensor<[?,2,32,16],f32>
  %102 = torch.prim.ListConstruct %45, %int1, %int16 : (!torch.int, !torch.int, !torch.int) -> !torch.list<int>
  %103 = torch.aten.view %99, %102 : !torch.vtensor<[?,2,16],f16>, !torch.list<int> -> !torch.vtensor<[?,1,16],f16>
  %104 = torch.prim.ListConstruct %45, %int32, %int16 : (!torch.int, !torch.int, !torch.int) -> !torch.list<int>
  %105 = torch.aten.view %101, %104 : !torch.vtensor<[?,2,32,16],f32>, !torch.list<int> -> !torch.vtensor<[?,32,16],f32>
  %106 = torch.aten.transpose.int %105, %int-2, %int-1 : !torch.vtensor<[?,32,16],f32>, !torch.int, !torch.int -> !torch.vtensor<[?,16,32],f32>
  %107 = torch.aten.to.dtype %106, %int5, %false, %false, %none : !torch.vtensor<[?,16,32],f32>, !torch.int, !torch.bool, !torch.bool, !torch.none -> !torch.vtensor<[?,16,32],f16>
  %108 = torch.prim.ListConstruct %45, %int1, %int16 : (!torch.int, !torch.int, !torch.int) -> !torch.list<int>
  %109 = torch.aten.broadcast_to %103, %108 : !torch.vtensor<[?,1,16],f16>, !torch.list<int> -> !torch.vtensor<[?,1,16],f16>
  %110 = torch.prim.ListConstruct %45, %int1, %int16 : (!torch.int, !torch.int, !torch.int) -> !torch.list<int>
  %111 = torch.aten.view %109, %110 : !torch.vtensor<[?,1,16],f16>, !torch.list<int> -> !torch.vtensor<[?,1,16],f16>
  %112 = torch.prim.ListConstruct %45, %int16, %int32 : (!torch.int, !torch.int, !torch.int) -> !torch.list<int>
  %113 = torch.aten.broadcast_to %107, %112 : !torch.vtensor<[?,16,32],f16>, !torch.list<int> -> !torch.vtensor<[?,16,32],f16>
  %114 = torch.prim.ListConstruct %45, %int16, %int32 : (!torch.int, !torch.int, !torch.int) -> !torch.list<int>
  %115 = torch.aten.view %113, %114 : !torch.vtensor<[?,16,32],f16>, !torch.list<int> -> !torch.vtensor<[?,16,32],f16>
  %116 = torch.aten.bmm %111, %115 : !torch.vtensor<[?,1,16],f16>, !torch.vtensor<[?,16,32],f16> -> !torch.vtensor<[?,1,32],f16>
  %117 = torch.prim.ListConstruct %45, %int1, %int32 : (!torch.int, !torch.int, !torch.int) -> !torch.list<int>
  %118 = torch.aten.view %116, %117 : !torch.vtensor<[?,1,32],f16>, !torch.list<int> -> !torch.vtensor<[?,1,32],f16>
  %119 = torch.prim.ListConstruct %18, %int2, %int32 : (!torch.int, !torch.int, !torch.int) -> !torch.list<int>
  %120 = torch.aten.view %118, %119 : !torch.vtensor<[?,1,32],f16>, !torch.list<int> -> !torch.vtensor<[?,2,32],f16>
  %121 = torch.prim.ListConstruct %45, %int1, %int1 : (!torch.int, !torch.int, !torch.int) -> !torch.list<int>
  %122 = torch.aten.view %55, %121 : !torch.vtensor<[?,2],f32>, !torch.list<int> -> !torch.vtensor<[?,1,1],f32>
  %123 = torch.prim.ListConstruct %45, %int32, %int1 : (!torch.int, !torch.int, !torch.int) -> !torch.list<int>
  %124 = torch.aten.view %120, %123 : !torch.vtensor<[?,2,32],f16>, !torch.list<int> -> !torch.vtensor<[?,32,1],f16>
  %125 = torch.aten.transpose.int %124, %int-2, %int-1 : !torch.vtensor<[?,32,1],f16>, !torch.int, !torch.int -> !torch.vtensor<[?,1,32],f16>
  %126 = torch.aten.to.dtype %125, %int6, %false, %false, %none : !torch.vtensor<[?,1,32],f16>, !torch.int, !torch.bool, !torch.bool, !torch.none -> !torch.vtensor<[?,1,32],f32>
  %127 = torch.prim.ListConstruct %45, %int1, %int1 : (!torch.int, !torch.int, !torch.int) -> !torch.list<int>
  %128 = torch.aten.broadcast_to %122, %127 : !torch.vtensor<[?,1,1],f32>, !torch.list<int> -> !torch.vtensor<[?,1,1],f32>
  %129 = torch.prim.ListConstruct %45, %int1, %int1 : (!torch.int, !torch.int, !torch.int) -> !torch.list<int>
  %130 = torch.aten.view %128, %129 : !torch.vtensor<[?,1,1],f32>, !torch.list<int> -> !torch.vtensor<[?,1,1],f32>
  %131 = torch.prim.ListConstruct %45, %int1, %int32 : (!torch.int, !torch.int, !torch.int) -> !torch.list<int>
  %132 = torch.aten.broadcast_to %126, %131 : !torch.vtensor<[?,1,32],f32>, !torch.list<int> -> !torch.vtensor<[?,1,32],f32>
  %133 = torch.prim.ListConstruct %45, %int1, %int32 : (!torch.int, !torch.int, !torch.int) -> !torch.list<int>
  %134 = torch.aten.view %132, %133 : !torch.vtensor<[?,1,32],f32>, !torch.list<int> -> !torch.vtensor<[?,1,32],f32>
  %135 = torch.aten.bmm %130, %134 : !torch.vtensor<[?,1,1],f32>, !torch.vtensor<[?,1,32],f32> -> !torch.vtensor<[?,1,32],f32>
  %136 = torch.prim.ListConstruct %45, %int1, %int32 : (!torch.int, !torch.int, !torch.int) -> !torch.list<int>
  %137 = torch.aten.view %135, %136 : !torch.vtensor<[?,1,32],f32>, !torch.list<int> -> !torch.vtensor<[?,1,32],f32>
  %138 = torch.prim.ListConstruct %18, %int2, %int32 : (!torch.int, !torch.int, !torch.int) -> !torch.list<int>
  %139 = torch.aten.view %137, %138 : !torch.vtensor<[?,1,32],f32>, !torch.list<int> -> !torch.vtensor<[?,2,32],f32>
  %140 = torch.prim.ListConstruct %int1 : (!torch.int) -> !torch.list<int>
  %141 = torch.aten.sum.dim_IntList %139, %140, %false, %none : !torch.vtensor<[?,2,32],f32>, !torch.list<int>, !torch.bool, !torch.none -> !torch.vtensor<[?,32],f32>
  %142 = torch.prim.ListConstruct %int1, %18, %int32 : (!torch.int, !torch.int, !torch.int) -> !torch.list<int>
  %143 = torch.aten.view %141, %142 : !torch.vtensor<[?,32],f32>, !torch.list<int> -> !torch.vtensor<[1,?,32],f32>
  %144 = torch.aten.pow.Tensor_Scalar %143, %int2 : !torch.vtensor<[1,?,32],f32>, !torch.int -> !torch.vtensor<[1,?,32],f32>
  %145 = torch.prim.ListConstruct %int-1 : (!torch.int) -> !torch.list<int>
  %146 = torch.aten.sum.dim_IntList %144, %145, %true, %none : !torch.vtensor<[1,?,32],f32>, !torch.list<int>, !torch.bool, !torch.none -> !torch.vtensor<[1,?,1],f32>
  %147 = torch.aten.div.Scalar %146, %int32 : !torch.vtensor<[1,?,1],f32>, !torch.int -> !torch.vtensor<[1,?,1],f32>
  %148 = torch.aten.add.Scalar %147, %float9.000000e00, %int1 : !torch.vtensor<[1,?,1],f32>, !torch.float, !torch.int -> !torch.vtensor<[1,?,1],f32>
  %149 = torch.aten.rsqrt %148 : !torch.vtensor<[1,?,1],f32> -> !torch.vtensor<[1,?,1],f32>
  %150 = torch.aten.mul.Tensor %143, %149 : !torch.vtensor<[1,?,32],f32>, !torch.vtensor<[1,?,1],f32> -> !torch.vtensor<[1,?,32],f32>
  %151 = torch.aten.mul.Tensor %10, %150 : !torch.vtensor<[32],f32>, !torch.vtensor<[1,?,32],f32> -> !torch.vtensor<[1,?,32],f32>
  %152 = torch.aten.transpose.int %11, %int-2, %int-1 : !torch.vtensor<[256,32],f32>, !torch.int, !torch.int -> !torch.vtensor<[32,256],f32>
  %153 = torch.prim.ListConstruct %18, %int32 : (!torch.int, !torch.int) -> !torch.list<int>
  %154 = torch.aten.view %151, %153 : !torch.vtensor<[1,?,32],f32>, !torch.list<int> -> !torch.vtensor<[?,32],f32>
  %155 = torch.aten.mm %154, %152 : !torch.vtensor<[?,32],f32>, !torch.vtensor<[32,256],f32> -> !torch.vtensor<[?,256],f32>
  %156 = torch.prim.ListConstruct %int1, %18, %int256 : (!torch.int, !torch.int, !torch.int) -> !torch.list<int>
  %157 = torch.aten.view %155, %156 : !torch.vtensor<[?,256],f32>, !torch.list<int> -> !torch.vtensor<[1,?,256],f32>
  return %157 : !torch.vtensor<[1,?,256],f32>
}