#!/usr/bin/env python

import numpy as np
import os
import shutil
from scipy.stats import rv_discrete
import random

def seek_one_file(index, name, size):
	nost = 5
#	os.system('touch %s' % name)
	os.system( 'lfs setstripe --stripe-index %d --stripe-count 1 %s\n' % ((index % nost), name))
        f = open(name, 'wb')
	print size
        #f.seek(size - 1)
	if size >= 1074000000:
		while size > 1074000000:
        		f.write('\0' * 1074000000)
			size -= 1074000000
			print "divide:" + str(size) 
	f.write('\0' * size)
        f.close()

def gen_file_size_list(size):
    data = np.load('/global/cscratch1/sd/yuanlai/gf_test/byte_by_app_src-2017.npy')[()]
    data = data['globusonline-fxp'][:49]
    d_sum = data.sum()
    data = data / d_sum
    num = range(49)
    random_variable = rv_discrete(values=(num,data))
    total = 0
    res = []
    while total < size:
        _bin = random_variable.rvs(size=1)[0]
        _one = random.randint(2**_bin, 2**(_bin + 1))
        total += _one
        res.append(_one)
    return res

def seek_file_name(pathPrefix, num):
        return [pathPrefix + str(i) for i in range(num)]

def seek_file(pathPrefix, size):
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
        fileSizeList = gen_file_size_list(size)
	print sum(fileSizeList)
	indexList = [i for i in range(len(fileSizeList))]
        fileNameList = seek_file_name(pathPrefix + 'file', len(fileSizeList))
        map(seek_one_file, indexList,  fileNameList, fileSizeList)

random.seed(1)
path = '/global/cscratch1/sd/yuanlai/gf_test/new_test_files_limit_ost/'
size = 2**40
seek_file(path, size)
