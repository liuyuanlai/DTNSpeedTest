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
	#mean = totalSize / num
	#sigma = 10000
	#s = np.random.rando(mean, sigma, num)
	#s = np.random.multinomial(totalSize, np.ones(num)/num, size=1)[0]
	#print sum(s)
	maxSize = totalSize / num * 2
	s = np.random.uniform(1, maxSize, num)
	s = s.astype(int)
	print sum(s)
	return s

def seek_file_name(pathPrefix, num):
	return [pathPrefix + str(i) for i in range(num)]

def h2h_addrs(pathPrefix, fromHost, fromPort, fromFileList, toHost, toPort, toFileList):
	fileNum = len(fromFileList)
	nodeList = ['01', '02', '04', '05', '06', '07', '08', '09', '10']
	f = open(pathPrefix + 'h2hList.txt', 'wb')
	for i in range(fileNum):
		fromPath = 'ftp://' + fromHost + nodeList[i % len(nodeList)] + ':' + fromPort + fromFileList[i]
		toPath = 'ftp://' + toHost + nodeList[i % len(nodeList)] + ':' + toPort + toFileList[i]
		line = fromPath + ' ' + toPath + '\n'
		f.write(line)
	f.close() 

def seek_file(pathPrefix, fromHost, fromPort, toHost, toPort, totalSize, num):
	try:
		shutil.rmtree(pathPrefix)
	except:
		pass
	#try:
	os.mkdir(pathPrefix)
	#	setStripe = "lfs setstripe -c 10 -S 100m " + pathPrefix
	#	os.system(setStripe)
	#except:
	#	print "Can not create folder"
	fromFileList = seek_file_name(pathPrefix + 'file', num)
	fileSize = seek_file_size(totalSize, num)
	map(seek_one_file, fromFileList, fileSize)
	toFileList = ['/dev/null'] * num
	h2h_addrs(pathPrefix, fromHost, fromPort, fromFileList, toHost, toPort, toFileList)


#path = "/global/project/projectdirs/m2930/lyl/gf_test/test_files/"
#path = os.getcwd() + '/read_test_files/'
path = "/global/cscratch1/sd/yuanlai/gf_test/test_files/"
fromHost = 'dtn'
fromPort = '12334'
toHost = 'dtn'
toPort = '12335'
totalSize = 2**40
fileNumber = 4000
seek_file(path, fromHost, fromPort, toHost, toPort, totalSize, fileNumber)
