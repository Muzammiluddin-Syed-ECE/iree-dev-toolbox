import numpy as np
import sys 

shape = []

n = len(sys.argv)
for i in range(2, n):
    shape += [int(sys.argv[i])]

out = np.random.random_sample(shape).astype(np.float16, copy=False)

np.set_printoptions(threshold=sys.maxsize)
print("writing array of shape: " + str(shape), "to", sys.argv[1])
file = open(sys.argv[1], "w+")
content = str(out)
file.write(content)
file.close()

# print(out.tolist())
