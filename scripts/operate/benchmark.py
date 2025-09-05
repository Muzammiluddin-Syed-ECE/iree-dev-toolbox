import scripts.generate.mlir.generate as gen
import subprocess
import sys

def runBenchmarkModule(template, dir, shape, filename):
    cmds = gen.generateLoop(template, dir, shape)
    compile = "iree-compile " + cmds[0] + f" --mlir-disable-threading --mlir-print-ir-after-all &> {dir}/output/{filename}.mlir"
    benchmark = "iree-benchmark-module --benchmark_repetitions=3 " + cmds[1]
    subprocess.run(compile, shell=True, executable="/bin/bash")
    subprocess.run(benchmark, shell=True, executable="/bin/bash")

def runRocprof(template, dir, shape, filename):
    cmds = gen.generateLoop(template, dir, shape)
    compile = "iree-compile " + cmds[0] + f" --mlir-disable-threading --mlir-print-ir-after-all &> {dir}/output/{filename}.mlir"
    runmodule = f"rocprofv3 -i /home/muzasyed/att.json -d {dir}/output/traces/{filename} -- iree-run-module " + cmds[1]
    subprocess.run(compile, shell=True, executable="/bin/bash")
    subprocess.run(runmodule, shell=True, executable="/bin/bash")

if __name__ == "__main__":
    template = "/home/muzasyed/iree-dev-toolbox/scripts/generate/mlir/sample.mlir"
    template_2 = "/home/muzasyed/iree-dev-toolbox/scripts/generate/mlir/sample_bench.mlir"
    template_3 = "/home/muzasyed/iree-dev-toolbox/scripts/generate/mlir/sample_basic.mlir"
    dir = "/home/muzasyed/projects/project17/samples/mlir"
    shape = [1032, 1032, 32, 32]
    runBenchmarkModule(template_2, dir, shape, "sample_bench")
    runRocprof(template, dir, shape, "sample")
    runRocprof(template_3, dir, shape, "sample_basic")
