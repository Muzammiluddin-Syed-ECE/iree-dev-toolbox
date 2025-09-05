//! $d0$
//! $d1$
//! $d2$
//! $d3$
//<input>tensor<$d0$x$d2$x$d3$xf32></input>
//<input>tensor<$d0$x$d2$xi8></input>
//<input>tensor<$d1$x$d2$x$d3$xf32></input>
//<input>tensor<$d1$x$d2$xi8></input>

!lhs = f4E2M1FN
!rhs = f4E2M1FN
!scale_ty = f8E8M0FNU

!A = tensor<$d0$x$d2$x$d3$xf32>
!B = tensor<$d1$x$d2$x$d3$xf32>
!A_size = tensor<$d0$x$d2$x$d3$x!lhs>
!B_size = tensor<$d1$x$d2$x$d3$x!rhs>

!A_scales = tensor<$d0$x$d2$x!scale_ty>
!B_scales = tensor<$d1$x$d2$x!scale_ty>
!A_s = tensor<$d0$x$d2$xi8>
!B_s = tensor<$d1$x$d2$xi8>

!C_size = tensor<$d0$x$d1$xf32>

#lhs_map = affine_map<(M, N, Ko, Kb) -> (M, Ko, Kb)>
#rhs_map = affine_map<(M, N, Ko, Kb) -> (N, Ko, Kb)>
#scale_m = affine_map<(M, N, Ko, Kb) -> (M, Ko)>
#scale_n = affine_map<(M, N, Ko, Kb) -> (N, Ko)>
#out_map = affine_map<(M, N, Ko, Kb) -> (M, N)>
func.func @matmul(%lhs : !A, %lhs_scales : !A_s, %rhs : !B, %rhs_scales : !B_s) -> !C_size {
  // %lhs = util.unfoldable_constant dense<1.0> : !A
  // %lhs_scales = util.unfoldable_constant dense<127> : !A_s
  // %rhs = util.unfoldable_constant dense<0.5> : !B
  // %rhs_scales = util.unfoldable_constant dense<126> : !B_s
  %A = arith.truncf %lhs : !A to !A_size
  %A_scales = arith.bitcast %lhs_scales : !A_s to !A_scales
  %B = arith.truncf %rhs : !B to !B_size
  %B_scales = arith.bitcast %rhs_scales : !B_s to !B_scales
  %cst = arith.constant 0.000000e+00 : f32
  %empty = tensor.empty() : !C_size
  %C = linalg.fill ins(%cst : f32) outs(%empty : !C_size) -> !C_size
  %D = linalg.generic {
    indexing_maps = [#lhs_map, #rhs_map, #scale_m, #scale_n, #out_map],
    iterator_types = ["parallel", "parallel", "reduction", "reduction"]
  } ins(%A, %B, %A_scales, %B_scales : !A_size, !B_size, !A_scales, !B_scales) outs(%C : !C_size) {
  ^bb0(%a: !lhs, %b: !rhs, %a_scale: !scale_ty, %b_scale: !scale_ty, %out: f32):
    %1 = arith.scaling_extf %a, %a_scale : !lhs, !scale_ty to f32
    %2 = arith.scaling_extf %b, %b_scale : !rhs, !scale_ty to f32
    %3 = arith.mulf %1, %2 : f32
    %4 = arith.addf %out, %3 : f32
    linalg.yield %4 : f32
  } -> !C_size
  return %D : !C_size
}