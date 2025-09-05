//! $d0$
//! $d1$
//! $d2$
//! $d3$
//<input>tensor<$d0$x$d2$x$d3$xf32></input>
//<input>tensor<$d1$x$d2$x$d3$xf32></input>

!lhs = f32
!rhs = f32
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
func.func @matmul(%A : !A, %B : !B) -> !C_size {
  // %lhs = util.unfoldable_constant dense<1.0> : !A
  // %lhs_scales = util.unfoldable_constant dense<127> : !A_s
  // %rhs = util.unfoldable_constant dense<0.5> : !B
  // %rhs_scales = util.unfoldable_constant dense<126> : !B_s
  %cst = arith.constant 0.000000e+00 : f32
  %empty = tensor.empty() : !C_size
  %C = linalg.fill ins(%cst : f32) outs(%empty : !C_size) -> !C_size
  %D = linalg.generic {
    indexing_maps = [#lhs_map, #rhs_map, #out_map],
    iterator_types = ["parallel", "parallel", "reduction", "reduction"]
  } ins(%A, %B : !A_size, !B_size) outs(%C : !C_size) {
  ^bb0(%1: !lhs, %2: !rhs, %out: f32):
    %3 = arith.mulf %1, %2 : f32
    %4 = arith.addf %out, %3 : f32
    linalg.yield %4 : f32
  } -> !C_size
  return %D : !C_size
}