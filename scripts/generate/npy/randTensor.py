import numpy as np
import sys 

def createNpy(dst_dir_path, str_type, shape):
    if str_type == "i64":
        type = np.int64
        max = np.iinfo(type).max
    elif str_type == "f32":
        type = np.float32
        max = np.finfo(type).max
    elif str_type == "f16":
        type = np.float16
        max = np.finfo(type).max
    elif str_type == "i8":
        type = np.int8
        max = np.iinfo(type).max

    out = np.random.random_sample(shape)
    out = out * max
    out = out.astype(type, copy=False)

    np.save(dst_dir_path, out)

if __name__ == "__main__":
    n = len(sys.argv)
    dst_dir_path = sys.argv[1]
    str_type = sys.argv[2]
    shape = []
    for i in range(3, n):
        shape += [int(sys.argv[i])]
    np.random.seed(1)
    createNpy(dst_dir_path, str_type, shape)
    print("Wrote tensor to " + dst_dir_path)