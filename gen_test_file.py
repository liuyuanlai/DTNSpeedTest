#!/usr/bin/env python

from __future__ import division
import numpy as np
import os
import shutil

def seek_one_file(name, size):
	f = open(name, 'wb')
	f.seek(size - 1)
	f.write('\0')
	f.close()

def seek_file_size(totalSize, num):
	mean = totalSize / num
	sigma = 10
	s = np.random.normal(mean, sigma, num)
	return s

def seek_file_name(pathPrefix, num):
	return [pathPrefix + str(i) for i in range(num)]

def seek_file(pathPrefix, totalSize, num):
	try:
		shutil.rmtree(pathPrefix)
	except:
		pass
	try:
		os.mkdir(pathPrefix)
	except:
		print "Can not create folder"
	fileName = seek_file_name(pathPrefix + 'file', num)
	fileSize = seek_file_size(totalSize, num)
	map(seek_one_file, fileName, fileSize)
path = os.getcwd() + '/test_files/'
seek_file(path, 1000, 10)
