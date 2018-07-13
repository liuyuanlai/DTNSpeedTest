#!/usr/bin/env python

newFilePath = "/global/cscratch1/sd/yuanlai/gf_test/read_test_files/h2hList.txt"
oldFilePath = "/global/project/projectdirs/m2930/lyl/gf_test/l2g_test_files/h2hList.txt"

newSourcePart = "/global/cscratch1/sd/yuanlai/gf_test/read_test_files/file"

f_new = open(newFilePath, 'w')
i = 0
with open(oldFilePath, 'r') as f_old:
    for line in f_old:
        #line = f_old.readline()
        lineSplit = line.split(' ')
        newSource = lineSplit[0][:17] + newSourcePart + str(i)
        i += 1
        newLine = newSource + " " + lineSplit[1]
        f_new.writelines(newLine)
        #print(newLine)
f_new.close()
