import numpy as np
import sys 

shape = []

n = len(sys.argv)
for i in range(2, n):
    shape += [int(sys.argv[i])]

"""out = np.random.random_sample(shape).astype(np.float16, copy=False)"""
out = np.random.random_sample(shape).astype(np.int64, copy=False)
  
# the array is saved in the file geekfile.npy  
np.save(sys.argv[1], out) 
  
print("Wrote tensor to " + sys.argv[1])
