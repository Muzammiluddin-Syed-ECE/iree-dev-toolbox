import numpy as numpy
import sys
import re

src_file_path = sys.argv[1]
bounds = sys.argv[2:]

num_args = int(len(bounds)/3)
lower_bounds = bounds[:num_args]
upper_bounds = bounds[num_args:num_args*2]
steps = bounds[num_args*2:]
print(lower_bounds)
print(upper_bounds)
print(steps)

path = src_file_path.split("/")
filename = path[-1]
path = path[:-1]
path_str = ""
for dir in path:
    if (len(dir) > 0):
        path_str += "/" + dir


f = open(src_file_path, "r")

content = f.read()


print(content)
pattern = r'\$([`0-9a-zA-Z\^!@#\$%\&\*\(\)]*)\$'
args = re.findall(pattern, content)

assert(len(args) == num_args)

def myround(x, base=64):
    return base * round(max(x/base, 1))

def generateSubstitutions(args, res, lower_bounds, upper_bounds, steps):
    new_res = []
    if args is None or len(args) == 0:
        return res
    step_size = int((int(upper_bounds[0]) - int(lower_bounds[0])) / int(steps[0]))
    for i in range(len(res)):
        iter = int(lower_bounds[0])
        for j in range(int(steps[0])+1):
            # temp = res[i] + [myround(iter)]
            temp = res[i] + [iter]
            print(temp)
            new_res.append(temp)
            iter = iter + step_size
    return generateSubstitutions(args[1:], new_res, lower_bounds[1:], upper_bounds[1:], steps[1:])

substitutions = generateSubstitutions(args, [[]], lower_bounds, upper_bounds, steps)

for substitution in substitutions:
    substition_str = ""
    for num in substitution:
        substition_str += str(num) + "_"
    sub_filename = substition_str + filename
    sub_fullpath = path_str + "/generated/" + sub_filename
    sub_content = content
    for i in range(num_args):
        print(args[i])
        print(str(substitution[i]))
        sub_content = re.sub(args[i], str(substitution[i]), sub_content)
    f = open(sub_fullpath, "w+")
    f.write(sub_content)
    f.close()
