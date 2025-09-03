import numpy as np
import sys 
a = np.load(sys.argv[2]) * int(sys.argv[3])
np.save(sys.argv[1], a) 
