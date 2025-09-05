import numpy as numpy
import sys
import re
import scripts.generate.npy.generateNpy as gen

# How to use:
# Add dims as $d0$ in your mlir file and this will use those to do a find and replace.
# python generate.py <template file> <destination dir> <dim0> <dim1> ...
class FileName:
    def __init__(self, dir, filename):
        self.dir = dir
        pattern = r'.[0-9a-z]*'
        tensor_list = re.split('\.', filename)
        fname = ""
        for a in tensor_list[:-1]:
            fname += a
        self.filename = fname
        self.suffix = tensor_list[-1]
        
    def __str__(self):
        return f"{self.dir}/{self.filename}.{self.suffix}"

    def withType(self, type):
        return f"{self.dir}/{self.filename}.{type}"

def createMLIR(src_file_path, dst_dir_path, replacements):
    path = src_file_path.split("/")
    filename = path[-1]
    path = path[:-1]
    path_str = ""
    for dir in path:
        if (len(dir) > 0):
            path_str += "/" + dir


    f = open(src_file_path, "r")
    content = f.read()
    pattern = r'\$[`0-9a-zA-Z\^!@#%\&\*\(\)]*\$'
    args = re.findall(pattern, content)

    # filter list of all duplicates, keeping only the first instance in order.
    substitutions = {}
    i = 0
    for dim in args:
        if dim not in substitutions and i < len(replacements):
            substitutions[dim] = str(replacements[i])
            i = i + 1

    substition_str = ""
    for num in replacements:
        substition_str += str(num) + "_"
    sub_filename = substition_str + filename
    sub_fullpath = FileName(dst_dir_path, sub_filename)

    sub_content = content
    for key in substitutions:
        escaped_key = re.sub("\$", r"\$", key)
        sub_content = re.sub(escaped_key, substitutions[key], sub_content)

    f = open(str(sub_fullpath), "w+")
    f.write(sub_content)
    f.close()
    return sub_fullpath

def generateLoop(src_file_path, dst_dir_path, replacements):
    cmds = []
    f = createMLIR(src_file_path, dst_dir_path, replacements)
    vmfb = f.withType("vmfb")
    cmds.append(f"{str(f)} -o {vmfb} --iree-hal-target-device=hip --iree-hip-target=gfx950")
    cmd = gen.createTensors(str(f), dst_dir_path)
    cmds.append(f"--module={vmfb} --device=hip --output=@{dst_dir_path}/{f.filename}.npy {cmd}")
    return cmds

if __name__ == "__main__":
    src_file_path = sys.argv[1]
    dst_dir_path = sys.argv[2]
    replacements = sys.argv[3:]
    cmds = generateLoop(src_file_path, dst_dir_path, replacements)
    print(cmds)
