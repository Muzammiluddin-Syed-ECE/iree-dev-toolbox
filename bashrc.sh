# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

prepare_env() {
    # Install package
    sudo apt install cmake ninja-build clang lld python3.10-venv python3-dev
    sudo apt install -y ccache

    # Update symlinks
    sudo /usr/sbin/update-ccache-symlinks

    # Prepend ccache into the PATH
    echo 'export PATH="/usr/lib/ccache:$PATH"' | tee -a ~/.bashrc
}
export PROJECTS=$HOME/projects
export IREE_HOME=$HOME/iree
export IREE_BUILD_DIR=project14/iree-build
export IREE_BUILD=$PROJECTS/$IREE_BUILD_DIR
export IREE_DEV_TOOLBOX=$HOME/iree-dev-toolbox
export PRJ=project14
export LOCAL=$PROJECTS/$PRJ
export OUTPUT=$LOCAL/output
export IN_MLIR=$LOCAL/samples/mlir
export IN_VMFB=$LOCAL/samples/vmfb
export GENERATE=$LOCAL/data/generate
export SCRIPTS=$LOCAL/scripts
export GENERATED=$LOCAL/data/template/generated
export PATH="~/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:$LOCAL/.venv/bin"
export PATH=$IREE_BUILD/tools:$PATH
export PATH=$PATH:$IREE_HOME/third_party/torch-mlir/tools
export PATH=$PATH:$IREE_BUILD/llvm-project/bin
export PATH=$PATH:$HOME/torch-mlir/build/bin
export PATH=$PATH:$IREE_HOME/third_party/llvm-project/build/bin
export PATH="/usr/lib/ccache:$PATH"
export PYTHONPATH=$IREE_BUILD/compiler/bindings/python:$IREE_BUILD/runtime/bindings/python
export THIRDPARTY=$IREE_HOME/third_party
export DEVICE=$(rocminfo | grep -o "gfx[0-9]*" | head -n 1)
echo "DEVICE IS $DEVICE"

setLocal() {
    old="export PRJ=$PRJ"
    export PRJ=$1
    export LOCAL=$PROJECTS/$PRJ
    export OUTPUT=$LOCAL/output
    export IN_MLIR=$LOCAL/samples/mlir
    export IN_VMFB=$LOCAL/samples/vmfb
    export GENERATE=$LOCAL/data/generate
    export TEMPLATE=$LOCAL/data/template
    export GENERATED=$LOCAL/data/template/generated
    export SCRIPTS=$LOCAL/scripts
    source $LOCAL/.venv/bin/activate
    new="export PRJ=$1"
    sed -i "s|$old|$new|g" $HOME/.bashrc
    old_build="export IREE_BUILD_DIR=$IREE_BUILD_DIR"
    new_build="export IREE_BUILD_DIR=$1/iree-build"
    sed -i "s|$old_build|$new_build|g" $HOME/.bashrc
}
export -f setLocal

refreshBrc() {
    source $HOME/.bashrc
    source $LOCAL/.venv/bin/activate
    setLocal $PRJ
}


installIREE() {
    CMAKE_INSTALL_METHOD=ABS_SYMLINK python -m pip install -e $1/compiler
    CMAKE_INSTALL_METHOD=ABS_SYMLINK python -m pip install -e $1/runtime
}
export -f installIREE

rebuildLLVM() {
    pushd $IREE_HOME/third_party/llvm-project/build
    cmake -G Ninja ../llvm \
   -DLLVM_ENABLE_PROJECTS=mlir \
   -DLLVM_BUILD_EXAMPLES=ON \
   -DLLVM_TARGETS_TO_BUILD="Native;NVPTX;AMDGPU" \
   -DCMAKE_BUILD_TYPE=Release \
   -DMLIR_INCLUDE_INTEGRATION_TESTS=ON \
   -DLLVM_CCACHE_BUILD=ON \
   -DLLVM_ENABLE_ASSERTIONS=ON \
   -DBUILD_SHARED_LIBS=ON
    # Using clang and lld speeds up the build, we recommend adding:
    #  -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ -DLLVM_ENABLE_LLD=ON
    # CCache can drastically speed up further rebuilds, try adding:
    # Optionally, using ASAN/UBSAN can find bugs early in development, enable with:
    # -DLLVM_USE_SANITIZER="Address;Undefined"
    # Optionally, enabling integration tests as well
    cmake --build . --target check-mlir
    popd
}

rebuildc() {
    pushd $IREE_HOME
    cmake -G Ninja -B $IREE_BUILD -S . \
        -DCMAKE_BUILD_TYPE=RelWithDebInfo \
        -DIREE_ENABLE_ASSERTIONS=ON \
        -DIREE_ENABLE_SPLIT_DWARF=ON \
        -DIREE_ENABLE_THIN_ARCHIVES=ON \
        -DCMAKE_C_COMPILER=clang \
        -DCMAKE_CXX_COMPILER=clang++ \
        -DIREE_ENABLE_LLD=ON \
        -DCMAKE_C_COMPILER_LAUNCHER=ccache \
        -DCMAKE_CXX_COMPILER_LAUNCHER=ccache \
        -DIREE_BUILD_PYTHON_BINDINGS=ON  \
        -DPython3_EXECUTABLE="$(which python3)" \
        -DIREE_HAL_DRIVER_HIP=ON \
        -DIREE_HAL_DRIVER_LOCAL_SYNC=ON \
        -DIREE_HAL_DRIVER_LOCAL_TASK=ON \
        -DIREE_HAL_DRIVER_VULKAN=ON \
        -DIREE_HAL_DRIVER_CUDA=ON \
        -DIREE_TARGET_BACKEND_CUDA=ON \
        -DIREE_TARGET_BACKEND_VMVX=ON \
        -DIREE_TARGET_BACKEND_LLVM_CPU=ON \
        -DIREE_TARGET_BACKEND_VULKAN_SPIRV=ON \
        -DIREE_TARGET_BACKEND_ROCM=ON \
        -DIREE_BUILD_ALL_CHECK_TEST_MODULES=ON \
        -DIREE_ENABLE_RUNTIME_TRACING=ON \
        -DIREE_BUILD_TRACY=ON \
        -DIREE_TRACING_MODE=1 \
        -DIREE_HIP_TEST_TARGET_CHIP=gfx942
    cmake --build $IREE_BUILD -j 64
    installIREE $IREE_BUILD
    popd
} 
export -f rebuildc

rebuildTest() {
    pushd $IREE_HOME
    cmake -G Ninja -B $IREE_BUILD -S . \
        -DCMAKE_BUILD_TYPE=RelWithDebInfo \
        -DIREE_ENABLE_ASSERTIONS=ON \
        -DIREE_ENABLE_SPLIT_DWARF=ON \
        -DIREE_ENABLE_THIN_ARCHIVES=ON \
        -DCMAKE_C_COMPILER=clang \
        -DCMAKE_CXX_COMPILER=clang++ \
        -DIREE_ENABLE_LLD=ON \
        -DCMAKE_C_COMPILER_LAUNCHER=ccache \
        -DCMAKE_CXX_COMPILER_LAUNCHER=ccache \
        -DIREE_BUILD_PYTHON_BINDINGS=ON  \
        -DPython3_EXECUTABLE="$(which python3)" \
        -DIREE_HAL_DRIVER_HIP=ON \
        -DIREE_HAL_DRIVER_LOCAL_SYNC=ON \
        -DIREE_HAL_DRIVER_LOCAL_TASK=ON \
        -DIREE_HAL_DRIVER_VULKAN=ON \
        -DIREE_HAL_DRIVER_CUDA=ON \
        -DIREE_TARGET_BACKEND_CUDA=ON \
        -DIREE_TARGET_BACKEND_VMVX=ON \
        -DIREE_TARGET_BACKEND_LLVM_CPU=ON \
        -DIREE_TARGET_BACKEND_VULKAN_SPIRV=ON \
        -DIREE_TARGET_BACKEND_ROCM=ON \
        -DIREE_BUILD_ALL_CHECK_TEST_MODULES=ON \
        -DIREE_ENABLE_RUNTIME_TRACING=ON \
        -DIREE_BUILD_TRACY=ON \
        -DIREE_TRACING_MODE=1 \
        -DIREE_HIP_TEST_TARGET_CHIP=gfx942
    cmake --build $IREE_BUILD -j 64
    installIREE $IREE_BUILD
    cd $IREE_BUILD
    ninja all
    ninja iree-test-deps
    popd
} 
export -f rebuildTest

rebuild() {
    pushd $IREE_HOME
    cmake -G Ninja -B $IREE_BUILD -S . \
        -DCMAKE_BUILD_TYPE=RelWithDebInfo \
        -DIREE_ENABLE_RUNTIME_TRACING=ON \
        -DIREE_ENABLE_ASSERTIONS=ON \
        -DIREE_ENABLE_SPLIT_DWARF=ON \
        -DIREE_ENABLE_THIN_ARCHIVES=ON \
        -DCMAKE_C_COMPILER=clang \
        -DCMAKE_CXX_COMPILER=clang++ \
        -DIREE_ENABLE_LLD=ON \
        -DCMAKE_C_COMPILER_LAUNCHER=ccache \
        -DCMAKE_CXX_COMPILER_LAUNCHER=ccache \
        -DIREE_BUILD_PYTHON_BINDINGS=ON  \
        -DPython3_EXECUTABLE="$(which python3)" \
        -DIREE_HAL_DRIVER_HIP=ON \
        -DIREE_HAL_DRIVER_LOCAL_SYNC=ON \
        -DIREE_HAL_DRIVER_LOCAL_TASK=ON \
        -DIREE_HAL_DRIVER_VULKAN=ON \
        -DIREE_HAL_DRIVER_CUDA=ON \
        -DIREE_TARGET_BACKEND_CUDA=ON \
        -DIREE_TARGET_BACKEND_VMVX=ON \
        -DIREE_TARGET_BACKEND_LLVM_CPU=ON \
        -DIREE_TARGET_BACKEND_VULKAN_SPIRV=ON \
        -DIREE_TARGET_BACKEND_ROCM=ON \
        -DIREE_BUILD_ALL_CHECK_TEST_MODULES=ON \
        -DIREE_BUILD_TRACY=4 \
        -DIREE_HIP_TEST_TARGET_CHIP=gfx942
    cmake --build $IREE_BUILD -j 64
    popd
} 
export -f rebuild

rebuildRelease() {
    pushd $IREE_HOME
    cmake -G Ninja -B $IREE_BUILD -S . \
        -DCMAKE_BUILD_TYPE=Release \
        -DIREE_ENABLE_SPLIT_DWARF=ON \
        -DIREE_ENABLE_THIN_ARCHIVES=ON \
        -DCMAKE_C_COMPILER=clang \
        -DCMAKE_CXX_COMPILER=clang++ \
        -DIREE_ENABLE_LLD=ON \
        -DCMAKE_C_COMPILER_LAUNCHER=ccache \
        -DCMAKE_CXX_COMPILER_LAUNCHER=ccache \
        -DIREE_BUILD_PYTHON_BINDINGS=ON  \
        -DPython3_EXECUTABLE="$(which python3)" \
        -DIREE_HAL_DRIVER_HIP=ON \
        -DIREE_HAL_DRIVER_LOCAL_SYNC=ON \
        -DIREE_HAL_DRIVER_LOCAL_TASK=ON \
        -DIREE_HAL_DRIVER_VULKAN=ON \
        -DIREE_HAL_DRIVER_CUDA=ON \
        -DIREE_TARGET_BACKEND_CUDA=ON \
        -DIREE_TARGET_BACKEND_VMVX=ON \
        -DIREE_TARGET_BACKEND_LLVM_CPU=ON \
        -DIREE_TARGET_BACKEND_VULKAN_SPIRV=ON \
        -DIREE_TARGET_BACKEND_ROCM=ON \
        -DIREE_BUILD_ALL_CHECK_TEST_MODULES=ON \
        -DIREE_HIP_TEST_TARGET_CHIP=gfx942 \
        -DIREE_ENABLE_RUNTIME_TRACING=ON

    cmake --build $IREE_BUILD
    installIREE $IREE_BUILD
    popd
} 
export -f rebuildRelease

rebuildDebug() {
    pushd $IREE_HOME
    cmake -G Ninja -B $IREE_BUILD -S . \
    -DCMAKE_BUILD_TYPE=DEBUG \
    -DIREE_ENABLE_ASSERTIONS=ON \
    -DIREE_ENABLE_SPLIT_DWARF=ON \
    -DIREE_ENABLE_THIN_ARCHIVES=ON \
    -DCMAKE_C_COMPILER=clang \
    -DCMAKE_CXX_COMPILER=clang++ \
    -DIREE_ENABLE_LLD=ON \
    -DIREE_BUILD_PYTHON_BINDINGS=ON  \
    -DPython_EXECUTABLE="$(which python)" \
    -DPython3_EXECUTABLE="$(which python3)" \
    -DCMAKE_C_COMPILER_LAUNCHER=ccache \
    -DCMAKE_CXX_COMPILER_LAUNCHER=ccache \
    -DLLVM_ENABLE_ASSERTIONS=ON
    cmake --build $IREE_BUILD -j 64
    popd
} 

runTest() {
    grep "// RUN:.*" $1 | cut -c 9- | sed "s|%s|${1}|g"
    grep "// RUN:.*" $1 | cut -c 9- | sed "s|%s|${1}|g" | eval
}

### Building IREE
cloneIREE() {
    git clone git@github.com:Muzammiluddin-Syed-ECE/iree.git
    cd iree
    git remote add upstream git@github.com:iree-org/iree.git
    git submodule update --init
    cd third_party/llvm-project
    git remote set-url origin git@github.com:Muzammiluddin-Syed-ECE/llvm-project.git
    git remote add upstream git@github.com:llvm/llvm-project.git
}

setupWorkspace() {
    make_venv
    # Upgrade PIP before installing other requirements
    python3.11 -m pip install --upgrade pip
    # Install IREE build requirements
    python3.11 -m pip install -r $IREE_HOME/runtime/bindings/python/iree/runtime/build_requirements.txt
    # cloneIREE
}

make_venv() {
    python3.11 -m venv .venv
    source .venv/bin/activate
}

buildTorchMLIR() {
    pushd $HOME/torch-mlir
    cmake -GNinja -Bbuild \
    externals/llvm-project/llvm \
    -DCMAKE_BUILD_TYPE=Release \
    -DLLVM_ENABLE_ASSERTIONS=ON \
    -DPython3_FIND_VIRTUALENV=ONLY \
    -DLLVM_ENABLE_PROJECTS=mlir \
    -DLLVM_EXTERNAL_PROJECTS="torch-mlir" \
    -DLLVM_EXTERNAL_TORCH_MLIR_SOURCE_DIR="$PWD" \
    -DMLIR_ENABLE_BINDINGS_PYTHON=ON \
    -DLLVM_TARGETS_TO_BUILD=host \
    `# use clang`\
    -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ \
    `# use ccache to cache build results` \
    -DCMAKE_C_COMPILER_LAUNCHER=ccache -DCMAKE_CXX_COMPILER_LAUNCHER=ccache \
    `# use LLD to link in seconds, rather than minutes` \
    `# if using clang <= 13, replace --ld-path=ld.lld with -fuse-ld=lld` \
    -DCMAKE_EXE_LINKER_FLAGS_INIT="--ld-path=ld.lld" \
    -DCMAKE_MODULE_LINKER_FLAGS_INIT="--ld-path=ld.lld" \
    -DCMAKE_SHARED_LINKER_FLAGS_INIT="--ld-path=ld.lld" \
    `# Enabling libtorch binary cache instead of downloading the latest libtorch everytime.` \
    `# Testing against a mismatched version of libtorch may cause failures` \
    -DLIBTORCH_CACHE=ON \
    `# Enable an experimental path to build libtorch (and PyTorch wheels) from source,` \
    `# instead of downloading them` \
    -DLIBTORCH_SRC_BUILD=ON \
    `# Set the variant of libtorch to build / link against. (shared|static and optionally cxxabi11)` \
    -DLIBTORCH_VARIANT=shared
    cmake --build build --target tools/torch-mlir/all
    popd
}

compileHipPasses() {
    # --mlir-print-ir-after=iree-llvmgpu-vector-lowering,iree-codegen-expand-gpu-ops
    iree-compile $1 -o $2 --iree-hal-target-device=hip --iree-hip-target=gfx942 --iree-codegen-gpu-native-math-precision --mlir-print-ir-after=iree-llvmgpu-vector-lowering,iree-codegen-expand-gpu-ops
}

compileHipAll() {
    # --mlir-print-ir-after=iree-llvmgpu-vector-lowering,iree-codegen-expand-gpu-ops
    iree-compile $1 -o $2 --iree-hal-target-device=hip --iree-hip-target=gfx942 --iree-codegen-gpu-native-math-precision --mlir-print-ir-before-all
}

compileHipJ() {
    iree-compile $1 -o $2 --iree-hal-target-device=hip --iree-hip-target=gfx942 --mlir-print-ir-after-all
}

setFoo() {
    export foo=$1
}

setBar() {
    export bar=$1
}

randTensorAsString() {
    args=("$@")
    args=("${args[@]:1}")
    name=("$1")
    value="$(python3 $IREE_DEV_TOOLBOX/scripts/generate/npy/print.py ${args[@]})"
    # export $name=$value
    export $name="$value"
    echo access tensor as string at $1
}

export -f randTensorAsString

randNpy() {
    args=("$@")
    echo ${args[@]}
    args=("${args[@]:1}")
    python3 $IREE_DEV_TOOLBOX/scripts/generate/npy/randNpy.py $GENERATE/$1 ${args[@]}
}
export -f randNpy

arangeNpy() {
    args=("$@")
    echo ${args[@]}
    args=("${args[@]:1}")
    python3 $IREE_DEV_TOOLBOX/scripts/generate/npy/arangeNpy.py $GENERATE/$1 ${args[@]}
}
export -f arangeNpy

maskNpy() {
    args=("$@")
    echo ${args[@]}
    args=("${args[@]:1}")
    python3 $IREE_DEV_TOOLBOX/scripts/generate/npy/maskNpy.py $GENERATE/$1 ${args[@]}
}
export -f maskNpy

oneElementNpy() {
    args=("$@")
    echo ${args[@]}
    args=("${args[@]:1}")
    python3 $IREE_DEV_TOOLBOX/scripts/generate/npy/oneElementNpy.py $GENERATE/$1 ${args[@]}
}
export -f oneElementNpy

buildTests() {
    export CTEST_PARALLEL_LEVEL=2
    export IREE_CTEST_LABEL_REGEX="^requires-gpu|^driver=hip$"
    export IREE_AMD_RDNA3_TESTS_DISABLE=1
    export IREE_NVIDIA_GPU_TESTS_DISABLE=0
    export IREE_NVIDIA_SM80_TESTS_DISABLE=1
    export IREE_MULTI_DEVICE_TESTS_DISABLE=0
    pushd $IREE_HOME
    cmake --build $LOCAL/iree-build --target iree-test-deps
    $IREE_HOME/build_tools/cmake/ctest_all.sh $LOCAL/iree-build
    popd
}

splitFile() {
    mkdir -p $OUTPUT/$2
    pushd $OUTPUT/$2
    csplit -z --suppress-matched --suffix-format=%02d\.split\.mlir $1 /"// -----"/ {*}
    popd
}

renameWithPassName() {
    firstLine=$(sed -n 1p $1)
    newName=$(echo $firstLine | sed -E 's/^.*IR Dump (Before|After) ([a-zA-Z0-9]+) \(.*$/\2/')
    dirName=$(echo $1 | sed -r "s/(.+)\/.+/\1/")
    if [ "$dirName" == "$1" ]; then
        dirName="."
    fi
    echo $1 
    echo $dirName/$newName.txt
    mv $1 $dirName/$newName.txt
}
export -f renameWithPassName

splitPasses() {
    mkdir -p $OUTPUT/$2
    pushd $OUTPUT/$2
    csplit -z --suffix-format=%02d\.split\.mlir $1 /"// -----"/ {*}
    for file in *split.mlir; do 
        if [ -f "$file" ]; then 
            renameWithPassName "$file" 
        fi 
    done
    popd
}


compileWithArgs() {
    if [ "$#" -eq 1 ]; then
        echo "Using default args: --iree-hal-target-device=hip --iree-hip-target=gfx942 --mlir-print-ir-after-all"
        args=("--iree-hal-target-device=hip" "--iree-hip-target=gfx942" "--mlir-print-ir-after-all") 
    else
        args=("$@")
        args=("${args[@]:1}") 
    fi
    for entry in "$1"/*.mlir
    do
        echo "$entry"
        iree-compile $entry -o $entry.vmfb ${args[@]} &> $entry.out
    done
}

switch() {
    bash $LOCAL/undo.sh
    setLocal $1
    bash $LOCAL/setup.sh
}

checkDiff() {
    python $IREE_DEV_TOOLBOX/scripts/verify/checkDiff.py $1 $2
}
export -f checkDiff

setupProject() {
    mkdir -p $PROJECTS/$1
    cd $PROJECTS/$1
    setupWorkspace
    setLocal $1
    mkdir -p $OUTPUT
    mkdir -p $IN_MLIR
    mkdir -p $IN_VMFB
    mkdir -p $GENERATE
    mkdir -p $GENERATED
    mkdir -p $TEMPLATE
    mkdir -p $SCRIPTS
    touch $LOCAL/setup.sh
    touch $LOCAL/undo.sh
}

printNpy() {
    python $IREE_DEV_TOOLBOX/scripts/verify/printNpy.py $1
}
export -f printNpy

getPatchIree() {
    pushd $LOCAL
    curl https://github.com/iree-org/iree/pull/$1.patch
    popd
}

tomashCommands() {
    cd ~
    git clone git@github.com:iree-org/iree-test-suites.git
    # cd ~/iree-test-suites/
    # python -m pip install -e sharktank_models/
    env TEST_OUTPUT_ARTIFACTS=$PWD BACKEND=rocm \
    pytest $IREE_TESTS/sharktank_models/quality_tests/ \
    -rpfE --log-cli-level=info --test-file-directory=$IREE_HOME/tests/external/iree-test-suites/sharktank_models/quality_tests \
    --external-file-directory=$IREE_HOME/build_tools/pkgci/external_test_suite
}

topkCommands() {
    iree-compile $IN_MLIR/topk.mlir   --iree-hal-target-device=hip[0]   --iree-hal-executable-debug-level=3   -o=output.vmfb --iree-hip-target=gfx942 --mlir-disable-threading --debug-only=iree-llvmgpu-kernel-config &> $OUTPUT/before_no_opt3.mine.mlir
}

llvm_integration() {
    # Source: https://github.com/iree-org/megabump
    # Checkout the megabump repo
    git clone https://github.com/iree-org/megabump.git

    cd megabump
    mkdir work

    # Checkout iree into work/iree (Can also create a symlink to existing clone)
    git clone https://github.com/iree-org/iree work/iree

    # Create a venv and install python deps in it
    python -m venv work/venv
    source work/venv/bin/activate
    cd work/iree
    python -m pip install --upgrade pip
    python -m pip install -r runtime/bindings/python/iree/runtime/build_requirements.txt
    deactivate
}

setUpShortFin() {
    pip install -r pytorch-rocm-requirements.txt
    # Install editable local projects.
    pip install -r requirements.txt -e sharktank/ -e shortfin/

    # Install the latest nightly release of iree-turbine, alond with
    # nightly versions of iree-base-compiler and iree-base-runtime.
    pip install -f https://iree.dev/pip-release-links.html --upgrade --pre \
    iree-turbine
}

ctestThing() {
    ctest --test-dir $LOCAL/iree-build --timeout 900 --output-on-failure --no-tests=error --label-regex '^requires-gpu|^driver=hip$' --label-exclude '(^nodocker$|^driver=vulkan$|^driver=metal$|^driver=cuda$|^vulkan_uses_vk_khr_shader_float16_int8$|^requires-gpu-sm80$|^requires-gpu-rdna3$|^requires-gpu-rdna4$)' --exclude-regex '(^iree/samples/custom_dispatch/cpu/embedded/example_hal.mlir.test$|^iree/samples/custom_dispatch/cpu/embedded/example_stream.mlir.test$|^iree/samples/custom_dispatch/cpu/embedded/example_transform.mlir.test$)'
}


compileDirPattern() {
    echo $1
    SRC_DIR=$PROJECTS/$1
    PREFIX=$3
    if [[ "$2" == " " ]] || [[ "$2" == "" ]]; then
        echo $SRC_DIR
        pattern="$SRC_DIR/samples/mlir/*.mlir"
    else
        pattern="$SRC_DIR/samples/mlir/$2"
    fi
    echo $pattern
    for filepath in $pattern; do
    if [ -f "$filepath" ]; then
        file=${filepath##*/}
        echo "[COMPILE]"
        echo "$SRC_DIR/iree-build/tools/iree-compile $filepath -o $SRC_DIR/output/$PREFIX$file.out --iree-hal-target-device=hip --iree-hip-target=$DEVICE --compile-to=$4 &> $SRC_DIR/output/$PREFIX$file.mlir"
        $SRC_DIR/iree-build/tools/iree-compile $filepath -o $SRC_DIR/output/$PREFIX$file.out --iree-hal-target-device=hip --iree-hip-target=$DEVICE --compile-to=$4 &> $SRC_DIR/output/$PREFIX$file.mlir
    fi
    done
}
export -f compileDirPattern

# pip install -r pytorch-rocm-requirements.txt
# pip install -r requirements.txt -e sharktank/ -e shortfin/
# bash sharktank/sharktank/pipelines/flux/export_from_hf.sh ~/.cache/huggingface/hub/models--black-forest-labs--FLUX.1-dev/snapshots/0ef5fff789c832c5c7f4e127f94c8b54bbcced44 flux_dev
# cd ~/shark-ai/shortfin && python -m shortfin_apps.flux.server --model_config=./python/shortfin_apps/flux/examples/flux_dev_config.json --device=hip --fibers_per_device=1 --workers_per_device=1 --isolation="per_fiber" --build_preference=compile --port=8081

# cd ~/shark-ai/ && pip install -e shortfin/

# iree-compile ~/projects/project11/samples/mlir/flux_77.mlir -o $OUTPUT/flux_77_main.vmfb --iree-hal-target-device=hip --iree-hip-target=gfx942 --iree-hal-dump-executable-sources-to=$OUTPUT/executables/sources
# iree-run-module --device=hip --input=@~/projects/project11/data/generate/1_77_rand.npy --module=$OUTPUT/flux_77_main.vmfb --parameters=model=~/.cache/shark/genfiles/flux/flux_clip_bf16.irpa &> $OUTPUT/results_main.txt


# $IREE_BUILD/tracy/iree-tracy-capture -o capture.tracy

tracyLoop() {
    rebuildc
    cd ~/iree-model-benchmark/sdxl/fp16-model/ && bash ./compile-unet.sh gfx942 --iree-config-add-tuner-attributes --iree-hal-executable-debug-level=3
    TRACY_NO_EXIT=1 iree-run-module   --device=hip   --module=$PWD/tmp/unet.vmfb --parameters=model=$PWD/tmp2/scheduled_unet_fp16.irpa   --input=1x4x128x128xf16   --input=1xi64   --input=2x64x2048xf16   --input=2x1280xf16   --input=2x6xf16   --input=1xf16
    cd $IREE_HOME/third_party/tracy
    cmake -B capture/build -S capture -DCMAKE_BUILD_TYPE=Release
    cmake --build capture/build --parallel --config Release

    # Run the capture tool:
    # ./capture/build/tracy-capture -f -o capture.tracy
    $IREE_BUILD/tracy/iree-tracy-capture -o capture.tracy
}
export -f tracyLoop

# git diff-tree --no-commit-id --name-only -r <commit-hash>
csvExport() {
    # Build using CMake:
    cd third_party/tracy
    cmake -B csvexport/build -S csvexport -DCMAKE_BUILD_TYPE=Release
    cmake --build csvexport/build --parallel --config Release

    # Run the csvexport tool:
    ./csvexport/build/tracy-csvexport --help
}

compilep() {
    echo "$PROJECTS/$1/iree-build/tools/iree-compile $PROJECTS/$1/samples/mlir/$2.mlir -o $PROJECTS/$1/samples/vmfb/$2.vmfb --mlir-print-ir-after-all --iree-hal-target-device=hip --iree-hip-target=gfx942 &> $PROJECTS/$1/output/$2.mlir"
    $PROJECTS/$1/iree-build/tools/iree-compile $PROJECTS/$1/samples/mlir/$2.mlir -o $PROJECTS/$1/samples/vmfb/$2.vmfb --mlir-disable-threading --mlir-print-ir-after-all --iree-hal-target-device=hip --iree-hip-target=gfx942 &> $PROJECTS/$1/output/$2.mlir
}
export -f compilep

compilethis() {
    args=("$@")
    args=("${args[@]:1}")
    echo $args
    echo "$LOCAL/iree-build/tools/iree-compile $LOCAL/samples/mlir/$1.mlir -o $LOCAL/samples/vmfb/$1.vmfb --mlir-print-ir-after-all --iree-hal-target-device=hip --iree-hip-target=gfx950 $args &> $LOCAL/output/$1.mlir"
    $LOCAL/iree-build/tools/iree-compile $LOCAL/samples/mlir/$1.mlir -o $LOCAL/samples/vmfb/$1.vmfb --mlir-disable-threading --mlir-print-ir-after-all --iree-hal-target-device=hip --iree-hip-target=gfx950 $args &> $LOCAL/output/$1.mlir
}
export -f compilethis

e2ethis() {
    args=("$@")
    args=("${args[@]:1}")
    echo $args
    echo "$LOCAL/iree-build/tools/iree-compile $IN_MLIR/$1.mlir -o $IN_VMFB/$1.vmfb --iree-hal-target-device=hip --iree-hip-target=gfx950 $args &> $OUTPUT/$1.mlir"
    $LOCAL/iree-build/tools/iree-compile $IN_MLIR/$1.mlir -o $IN_VMFB/$1.vmfb --iree-hal-target-device=hip --iree-hip-target=gfx950 $args &> $OUTPUT/$1.mlir
    echo "$LOCAL/iree-build/tools/iree-run-module --module=$IN_VMFB/$1.vmfb --device=hip --output=@$OUTPUT/$1.npy $args"
    $LOCAL/iree-build/tools/iree-run-module --module=$IN_VMFB/$1.vmfb --device=hip --output=@$OUTPUT/$1.npy $args
    printNpy $OUTPUT/$1.npy
}
export -f e2ethis

benchmarkthis() {
    args=("$@")
    args=("${args[@]:1}")
    echo $args
    echo "$LOCAL/iree-build/tools/iree-compile $IN_MLIR/$1.mlir -o $IN_VMFB/$1.vmfb --iree-hal-target-device=hip --iree-hip-target=gfx950 $args &> $OUTPUT/$1.mlir"
    $LOCAL/iree-build/tools/iree-compile $IN_MLIR/$1.mlir -o $IN_VMFB/$1.vmfb --iree-hal-target-device=hip --iree-hip-target=gfx950 $args &> $OUTPUT/$1.mlir
    echo "$LOCAL/iree-build/tools/iree-benchmark-module --module=$IN_VMFB/$1.vmfb --device=hip --output=@$OUTPUT/$1.npy $args"
    $LOCAL/iree-build/tools/iree-benchmark-module --module=$IN_VMFB/$1.vmfb --device=hip --output=@$OUTPUT/$1.npy --benchmark_repetitions=3 $args
    printNpy $OUTPUT/$1.npy
}

# compilethis PR "--compile-to=executable-configurations --iree-codegen-llvmgpu-early-tile-and-fuse-matmul=true --mlir-disable-threading"
# cat $IN_VMFB/PR.vmfb &> $IN_MLIR/PR_int.mlir
# compilethis PR_int "--compile-from=executable-configurations --iree-codegen-llvmgpu-early-tile-and-fuse-matmul=true --mlir-disable-threading"
# rocprofv3 -i att.json -d traces -- /home/muzasyed/projects/project17/iree-build/tools/iree-run-module --module=/home/muzasyed/projects/project17/samples/vmfb/scaled_matmul_1_1.vmfb --device=hip --output=@/home/muzasyed/projects/project17/output/scaled_matmul_1_1.npy