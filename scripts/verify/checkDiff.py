import numpy as np
import sys
import re

file_one = sys.argv[1]
file_two = sys.argv[2]

a = np.load(str(file_one))
b = np.load(str(file_two))

diff = np.subtract(a, b)
absolute_diff = np.absolute(diff)
a_clipped = np.clip(absolute_diff, a_min=1.0, a_max=None)
ratio_diff = np.divide(absolute_diff, a_clipped)
percent_diff = np.multiply(ratio_diff, 100.0)
max_percent_diff = np.max(percent_diff)

print(f"The max diff is {max_percent_diff}%")
