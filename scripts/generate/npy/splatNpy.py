import numpy as np
import sys 

shape = []

n = len(sys.argv)
for i in range(3, n):
    shape += [int(sys.argv[i])]

x = np.array([int(sys.argv[2])])
print(x)
print(tuple(shape))
out = np.broadcast_to(x, tuple(shape)).astype(np.int8, copy=False)
  
# the array is saved in the file geekfile.npy  
print(sys.argv[1])
np.save(sys.argv[1], out) 
  
print("Wrote tensor to " + sys.argv[1])
