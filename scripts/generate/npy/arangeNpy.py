import numpy as np
import sys 

shape = []

n = len(sys.argv)
total_elems = 1
max_dim = 1
for i in range(2, n):
    shape += [int(sys.argv[i])]
    total_elems *= int(sys.argv[i])
    max_dim = max(int(sys.argv[i]), max_dim)

out = np.arange(max_dim)
if total_elems == max_dim:
    out = out.reshape(shape).astype(np.float16, copy=False)
else: 
    out = np.broadcast_to(out, (shape)).astype(np.float16, copy=False)
# out = np.random.random_sample(shape).astype(np.float16, copy=False)
  
# the array is saved in the file geekfile.npy  
np.save(sys.argv[1], out) 
# print(out)
print("Wrote tensor to " + sys.argv[1])
