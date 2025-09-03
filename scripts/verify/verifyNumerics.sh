#!/bin/bash
source ~/.bashrc

####
# Usage
# !IMPORTANT: Make sure your project is set up with undo.sh and setup.sh scripts
# [1] - which project to verify numerics for
# [2] - Where the testbench is
# [3] - What the pattern to match against is (default "tb.mlir")
####


SRC_DIR=$2

if [[ "$3" == " " ]] || [[ "$3" == "" ]]; then
  echo $SRC_DIR
  pattern="$SRC_DIR/*_tb.mlir"
else
  pattern="$SRC_DIR/$3"
fi

# rebuildc
# setLocal $1

for filepath in $pattern; do
  if [ -f "$filepath" ]; then
    file=${filepath##*/}
    echo $filepath
    [[ $file =~ ([0-9]*)_([0-9]*)_([0-9]*)_.*$ ]]
    args=("${BASH_REMATCH[@]}")
    args=("${args[@]:1}")
    echo ${args[@]}
    firstDim=("${args[0]}")
    secondDim=("${args[2]}")
    thirdDim=("${args[1]}")
    maskNpy tensor_${firstDim}_${thirdDim} $firstDim $thirdDim
    # oneElementNpy tensor_${secondDim}_${thirdDim} $secondDim $thirdDim
    # arangeNpy tensor_${firstDim}_${thirdDim} $firstDim $thirdDim
    maskNpy mask_${secondDim}_${thirdDim} $secondDim $thirdDim
    # oneElementNpy mask_${secondDim}_${thirdDim} $secondDim $thirdDim
  fi
done

ITER="main"
echo "Setting up ${ITER}"
bash $PROJECTS/project2/undo.sh
# cp $LOCAL/subgroup2.cpp /home/muzasyed/iree/third_party/llvm-project/mlir/lib/Dialect/GPU/Transforms/SubgroupReduceLowering.cpp

for filepath in $pattern; do
  if [ -f "$filepath" ]; then
    file=${filepath##*/}
    # [[ $file =~ gemm_([0-9]*)_([0-9]*)_([0-9]*)_.*$ ]]
    [[ $file =~ ([0-9]*)_([0-9]*)_([0-9]*)_.*$ ]]
    args=("${BASH_REMATCH[@]}")
    args=("${args[@]:1}")
    firstDim=("${args[0]}")
    secondDim=("${args[2]}")
    thirdDim=("${args[1]}")
    echo "[COMPILE]"
    echo "iree-compile $filepath -o $SRC_DIR/$file.${ITER}.vmfb --iree-hal-target-device=hip --iree-hip-target=$DEVICE --mlir-print-ir-after-all --debug-only=iree-llvmgpu-kernel-config &> $SRC_DIR/$file.${ITER}.mlir"
    $PROJECTS/project0/iree-build/tools/iree-compile $filepath -o $SRC_DIR/$file.${ITER}.vmfb --iree-hal-target-device=hip --iree-hip-target=$DEVICE --mlir-print-ir-after-all --debug-only=iree-llvmgpu-kernel-config &> $SRC_DIR/$file.${ITER}.mlir
    echo "[EXECUTE]"
    echo "iree-run-module --device=hip --module=$SRC_DIR/$file.${ITER}.vmfb --input=@$GENERATE/tensor_${firstDim}_${thirdDim}.npy --input=@$GENERATE/mask_${secondDim}_${thirdDim}.npy --output=@$SRC_DIR/output_${firstDim}_${secondDim}.${ITER}.npy &> $SRC_DIR/$file.${ITER}.result"
    $PROJECTS/project0/iree-build/tools/iree-run-module --device=hip --module=$SRC_DIR/$file.${ITER}.vmfb --input=@$GENERATE/tensor_${firstDim}_${thirdDim}.npy --input=@$GENERATE/mask_${secondDim}_${thirdDim}.npy --output=@$SRC_DIR/output_${firstDim}_${secondDim}.${ITER}.npy &> $SRC_DIR/$file.${ITER}.result
    echo "$SRC_DIR/$file.${ITER}.result"
  fi
done

ITER="mine"
echo "Setting up ${ITER}"
bash $PROJECTS/project2/setup.sh
# cp $LOCAL/subgroup.cpp /home/muzasyed/iree/third_party/llvm-project/mlir/lib/Dialect/GPU/Transforms/SubgroupReduceLowering.cpp

for filepath in $pattern; do
  if [ -f "$filepath" ]; then
    file=${filepath##*/}
    [[ $file =~ ([0-9]*)_([0-9]*)_([0-9]*)_.*$ ]]
    args=("${BASH_REMATCH[@]}")
    args=("${args[@]:1}")
    firstDim=("${args[0]}")
    secondDim=("${args[2]}")
    thirdDim=("${args[1]}")
    echo "[COMPILE]"
    echo "iree-compile $filepath -o $SRC_DIR/$file.${ITER}.vmfb --iree-hal-target-device=hip --iree-hip-target=$DEVICE --mlir-print-ir-after-all --debug-only=iree-llvmgpu-kernel-config &> $SRC_DIR/$file.${ITER}.mlir"
    $PROJECTS/project2/iree-build/tools/iree-compile $filepath -o $SRC_DIR/$file.${ITER}.vmfb --iree-hal-target-device=hip --iree-hip-target=$DEVICE --mlir-print-ir-after-all --debug-only=iree-llvmgpu-kernel-config &> $SRC_DIR/$file.${ITER}.mlir
    echo "[EXECUTE]"
    echo "iree-run-module --device=hip --module=$SRC_DIR/$file.${ITER}.vmfb --input=@$GENERATE/tensor_${firstDim}_${thirdDim}.npy --input=@$GENERATE/mask_${secondDim}_${thirdDim}.npy --output=@$SRC_DIR/output_${firstDim}_${secondDim}.${ITER}.npy &> $SRC_DIR/$file.${ITER}.result"
    $PROJECTS/project2/iree-build/tools/iree-run-module --device=hip --module=$SRC_DIR/$file.${ITER}.vmfb --input=@$GENERATE/tensor_${firstDim}_${thirdDim}.npy --input=@$GENERATE/mask_${secondDim}_${thirdDim}.npy --output=@$SRC_DIR/output_${firstDim}_${secondDim}.${ITER}.npy &> $SRC_DIR/$file.${ITER}.result
    echo "$SRC_DIR/$file.${ITER}.result"
  fi
done

for filepath in $pattern; do
  if [ -f "$filepath" ]; then
    file=${filepath##*/}
    # [[ $file =~ gemm_([0-9]*)_([0-9]*)_([0-9]*)_.*$ ]]
    [[ $file =~ ([0-9]*)_([0-9]*)_([0-9]*)_.*$ ]]
    args=("${BASH_REMATCH[@]}")
    args=("${args[@]:1}")
    firstDim=("${args[0]}")
    secondDim=("${args[2]}")
    thirdDim=("${args[1]}")
    echo "[VERIFY]"
    echo "checkDiff $SRC_DIR/output_${firstDim}_${secondDim}.main.npy $SRC_DIR/output_${firstDim}_${secondDim}.mine.npy &> $SRC_DIR/diffs_${firstDim}_${secondDim}.txt"
    checkDiff $SRC_DIR/output_${firstDim}_${secondDim}.main.npy $SRC_DIR/output_${firstDim}_${secondDim}.mine.npy &> $SRC_DIR/diffs_${firstDim}_${secondDim}.txt
  fi
done

# echo "$shape"
# iree-compile ${ITER} -o $SRC_DIR --iree-hal-target-device=hip --iree-hip-target=$DEVICE --mlir-print-ir-after-all
# $IN_MLIR/$foo.mlir $IN_VMFB/$foo.main.vmfb &> $OUTPUT/$foo.main.mlir

# iree-run-module --device=hip --module=$IN_VMFB/$foo.mine.vmfb -
# -input=1x64x64xf8E4M3FNUZ=$tensor1 --input=1x64x64xf8E4M3FNUZ=$tensor2 --input=1x64x64xf8E4M3FNUZ=$tensor3 
# &> $OUTPUT/$foo.mine.log
