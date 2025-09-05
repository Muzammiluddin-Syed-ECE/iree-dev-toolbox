import scripts.generate.mlir.generate as gen
import subprocess
import sys



template = "/home/muzasyed/iree-dev-toolbox/scripts/generate/mlir/sample.mlir"
template_2 = "/home/muzasyed/iree-dev-toolbox/scripts/generate/mlir/sample_bench.mlir"
template_3 = "/home/muzasyed/iree-dev-toolbox/scripts/generate/mlir/sample_basic.mlir"
dir = "/home/muzasyed/projects/project17/samples/mlir"
shape = [1032, 1032, 32, 32]
cmds = gen.generateLoop(template, dir, shape)
b_cmds = gen.generateLoop(template_2, dir, shape)
c_cmds = gen.generateLoop(template_3, dir, shape)
compile_1 = "iree-compile " + cmds[0] + " --mlir-disable-threading --mlir-print-ir-after-all &> /home/muzasyed/projects/project17/output/sample.mlir"
compile_2 = "iree-compile " + b_cmds[0] + " --mlir-disable-threading --mlir-print-ir-after-all &> /home/muzasyed/projects/project17/output/sample_bench.mlir"
compile_3 = "iree-compile " + c_cmds[0] + " --mlir-disable-threading --mlir-print-ir-after-all &> /home/muzasyed/projects/project17/output/sample_basic.mlir"
benchmark = "iree-benchmark-module --benchmark_repetitions=3 " + b_cmds[1]
runmodule = "rocprofv3 -i /home/muzasyed/att.json -d /home/muzasyed/projects/project17/output/traces/1 -- iree-run-module " + cmds[1]
runmodule_3 = "rocprofv3 -i /home/muzasyed/att.json -d /home/muzasyed/projects/project17/output/traces/2 -- iree-run-module " + c_cmds[1]
subprocess.run(compile_1, shell=True, executable="/bin/bash")
subprocess.run(runmodule, shell=True, executable="/bin/bash")
subprocess.run(compile_2, shell=True, executable="/bin/bash")
subprocess.run(benchmark, shell=True, executable="/bin/bash")
subprocess.run(compile_3, shell=True, executable="/bin/bash")
subprocess.run(runmodule_3, shell=True, executable="/bin/bash")
