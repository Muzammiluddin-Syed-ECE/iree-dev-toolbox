import numpy as numpy
import sys
import re
import scripts.generate.npy.randTensor as randT
# How to use:
# Add dims as $d0$ in your mlir file and this will use those to do a find and replace.
# python generate.py <template file> <destination dir> <dim0> <dim1> ...


class Tensor:
    def __init__(self, shape, type):
        self.shape = shape
        self.type = type
    
    def __init__(self, tensor_str):
        pattern = r'tensor<(.*)>'
        tensor = re.findall(pattern, tensor_str)
        tensor_list = re.split('x', tensor[0])
        shape = []
        for elem in tensor_list[:-1]:
            shape.append(int(elem))
        self.shape = shape
        self.type = tensor_list[-1]
    
    def __str__(self):
        tensor = "tensor<"
        for a in self.shape:
            tensor += a + "x"
        tensor += self.type
        tensor += ">"
        return tensor

    def getPath(self, dir):
        dir += "/"
        for a in self.shape:
            dir += str(a)
            dir += "_"
        dir += self.type
        dir += ".npy"
        return dir

def createTensors(src_file_path, dst_dir_path):
    path = src_file_path.split("/")
    filename = path[-1]
    path = path[:-1]
    path_str = ""
    for dir in path:
        if (len(dir) > 0):
            path_str += "/" + dir

    f = open(src_file_path, "r")
    content = f.read()
    pattern = r'<input>(.*)</input>'

    args = re.findall(pattern, content)
    cmd = ""
    for arg in args:
        t = Tensor(arg)
        path = t.getPath(dst_dir_path)
        cmd += f"--input=@{path} "
        randT.createNpy(path, t.type, t.shape)
    return cmd

if __name__ == "__main__":    
    src_file_path = sys.argv[1]
    dst_dir_path = sys.argv[2]
    createTensors(src_file_path, dst_dir_path)



# substition_str = ""
# for num in replacements:
#     substition_str += str(num) + "_"
# sub_filename = substition_str + filename
# sub_fullpath = dst_dir_path + "/" + sub_filename

# sub_content = content
# for key in substitutions:
#     escaped_key = re.sub("\$", r"\$", key)
#     sub_content = re.sub(escaped_key, substitutions[key], sub_content)

# f = open(sub_fullpath, "w+")
# f.write(sub_content)
# f.close()

# print("Wrote to " + sub_fullpath)
