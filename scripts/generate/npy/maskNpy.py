import numpy as np
import sys 

shape = []

n = len(sys.argv)
# print(sys.argv)
elemTy = str(sys.argv[2])
for i in range(3, n):
    shape += [int(sys.argv[i])]

typ = np.float16
if elemTy == "fp32":
    typ = np.float32
  
out = np.random.randint(2, size=(shape)).astype(typ, copy=False)
# the array is saved in the file geekfile.npy  
np.save(sys.argv[1], out) 
print("Wrote tensor to " + sys.argv[1])
