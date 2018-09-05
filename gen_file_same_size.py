#!/usr/bin/env python

import numpy as np
import os
from multiprocessing import Pool
import random

def seek_one_file(name):
        f = open(name, 'wb')
	size = total_size / s
	#print size
        #f.seek(size - 1)
	if size >= 1074000000:
		while size > 1074000000:
        		f.write('\0' * 1074000000)
			size -= 1074000000
			#print "divide:" + str(size) 
	f.write('\0' * size)
        f.close()

def gen_file_size_list(size, number): 
	return [size / number] * number

def seek_file_name(pathPrefix, num):
        return [pathPrefix + str(i) for i in range(num)]

def seek_file(pathPrefix, size, number):
        try:
                shutil.rmtree(pathPrefix)
        except:
                pass
        #try:
        os.mkdir(pathPrefix)
        #       setStripe = "lfs setstripe -c 10 -S 100m " + pathPrefix
        #       os.system(setStripe)
        #except:
        #       print "Can not create folder"
        fileSizeList = gen_file_size_list(size, number)
	indexList = [i for i in range(len(fileSizeList))]
        fileNameList = seek_file_name(pathPrefix + 'file', len(fileSizeList))
	p = Pool(40)
        p.map(seek_one_file, fileNameList)

random.seed(1)
path = '/global/cscratch1/sd/yuanlai/gf_test/new_test_files_vary_size/'
total_size = 2**37
for s in [1, 20, 50, 100, 200, 500, 1000, 2000, 5000, 10000, 20000]:
	print s
	pathPre = path + str(s) + '/'
	seek_file(pathPre, total_size, s)
