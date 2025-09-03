import numpy as np
import sys 

shape = []

out = np.identity(int(sys.argv[2])).astype(np.float32, copy=False)
  
# the array is saved in the file geekfile.npy  
np.save(sys.argv[1], out) 
  
print("Wrote tensor to " + sys.argv[1])
