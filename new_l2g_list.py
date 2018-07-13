#!/usr/bin/env python

import random

oldFilePath = "/global/cscratch1/sd/yuanlai/gf_test/read_test_files/l2gList.txt"
newFilePath = "/global/cscratch1/sd/yuanlai/gf_test/read_test_files/l2gDiffDTNList.txt"

f_new = open(newFilePath, 'w')
nodeList = ['01', '02', '03', '04', '05', '06', '07', '08', '09', '10']
with open(oldFilePath, 'r') as f_old:
    for line in f_old:
        #line = f_old.readline()
        lineSplit = line.split(' ')
        des = lineSplit[1]
	des = des[:16] + '4' + des[17:]
        desNumStr = des[9:11]
        desNum = int(desNumStr)
        newDesNum = random.randint(0, 9)
        while newDesNum == 2 or newDesNum == desNum - 1:
            newDesNum = random.randint(0, 9)
        newDesNumStr = nodeList[newDesNum]
        newDes = des[:9] + newDesNumStr + des[11:]
        newLine = lineSplit[0] + " " + newDes
        f_new.writelines(newLine)
        #print(desNumStr + " " + newDesNumStr)
f_new.close()
