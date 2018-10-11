#!/usr/bin/env python

import numpy as np
import os
import shutil
from scipy.stats import rv_discrete
import random

def seek_one_file(index, name, size):
	#nost = 5
#	os.system('touch %s' % name)
	#os.system( 'lfs setstripe --stripe-index %d --stripe-count 1 %s\n' % ((index % nost), name))
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
    #data = np.load('/global/cscratch1/sd/yuanlai/gf_test/byte_by_app_src-2017.npy')[()]
    data  = np.load('byte_by_app_src-2017.npy')[()]
    data = data['globusonline-fxp'][:30]
    d_sum = data.sum()
    data = data / d_sum
    num = range(30)
    random_variable = rv_discrete(values=(num,data), seed=1)
    total = 0
    res = []
    while total < size:
        _bin = random_variable.rvs(size=1)[0]
        _one = random.randint(2**_bin, 2**(_bin + 1))
        total += _one
        res.append(_one)
    return res

def seek_file_name(pathPrefix, indexList):
        return [pathPrefix + idx for idx in indexList]

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
	fileSizeList.sort(reverse=True)
	print sum(fileSizeList)
	print len(fileSizeList)
	indexList = [str(i) for i in range(len(fileSizeList))]
	indexList.sort()
        fileNameList = seek_file_name(pathPrefix + 'file', indexList)
        map(seek_one_file, indexList,  fileNameList, fileSizeList)

random.seed(1)
#path = '/global/cscratch1/sd/yuanlai/gf_test/new_test_file_order_by_name/'
path = '/home/cc/data_100G/'
size = 100*(2**30)
seek_file(path, size)
