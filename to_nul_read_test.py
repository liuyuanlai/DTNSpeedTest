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

def h2h_addrs(pathPrefix, fromHost, fromPort, fromFileList, toHost, toPort, toFileList):
	f = open(pathPrefix + 'h2hList.txt', 'wb')
	for i in range(len(fromFileList)):
		fromPath = 'ftp://' + fromHost + ':' + fromPort + fromFileList[i]
		toPath = 'ftp://' + toHost + ':' + toPort + toFileList[i]
		line = fromPath + ' ' + toPath + '\n'
		f.write(line)
	f.close() 

def seek_file(pathPrefix, fromHost, fromPort, toHost, toPort, totalSize, num):
	try:
		shutil.rmtree(pathPrefix)
	except:
		pass
	try:
		os.mkdir(pathPrefix)
	except:
		print "Can not create folder"
	fromFileList = seek_file_name(pathPrefix + 'file', num)
	fileSize = seek_file_size(totalSize, num)
	map(seek_one_file, fileName, fileSize)
	toFileList = ['/dev/null'] * num
	h2h_addrs(pathPrefix, fromHost, fromPort, fromFileList, toHost, toPort, toFileList)


path = '/global/project/projectdirs/m2930/lyl/gf_test/read_test_files/'
#path = os.getcwd() + '/read_test_files/'
fromHost = 'localhost'
fromPort = '12334'
toHost = 'localhost'
toPort = '12335'
totalSize = 1000
fileNumber = 10
seek_file(path, fromHost, fromPort, toHost, toPort, totalSize, fileNumber)
