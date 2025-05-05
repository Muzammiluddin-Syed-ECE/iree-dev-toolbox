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

out = np.zeros(total_elems)
out[0] = 1
out = out.reshape(shape).astype(np.float16, copy=False)
  
# the array is saved in the file geekfile.npy  
np.save(sys.argv[1], out) 
print(out)
print("Wrote tensor to " + sys.argv[1])
