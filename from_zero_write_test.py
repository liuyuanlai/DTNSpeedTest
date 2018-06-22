#!/usr/bin/env python

from __future__ import division
import numpy as np
import os
import shutil

def sink_file_time(totalSize, num):
	t = [1] * num
	return t

def sink_file_name(pathPrefix, num):
	return [pathPrefix + str(i) for i in range(num)]

def h2h_addrs(pathPrefix, fromHost, fromPort, fromFileList, toHost, toPort, toFileList):
	f = open(pathPrefix + 'h2hList.txt', 'wb')
	for i in range(len(fromFileList)):
		fromPath = 'ftp://' + fromHost + ':' + fromPort + fromFileList[i]
		toPath = 'ftp://' + toHost + ':' + toPort + toFileList[i]
		line = fromPath + ' ' + toPath + '\n'
		f.write(line)
	f.close()

def sink_file(pathPrefix, fromHost, fromPort, toHost, toPort, num):
	try:
		shutil.rmtree(pathPrefix)
	except:
		pass
	try:
		os.mkdir(pathPrefix)
	except:
		print "Can not create folder"
	toFileList = sink_file_name(pathPrefix + 'file', num)
	fromFileList = ['/dev/zero'] * num
	h2h_addrs(pathPrefix, fromHost, fromPort, fromFileList, toHost, toPort, toFileList)

path = '/global/project/projectdirs/m2930/lyl/gf_test/write_test_files/'
#path = os.getcwd() + '/write_test_files/'
fromHost = 'localhost'
fromPort = '12335'
toHost = 'localhost'
toPort = '12334'
totalSize = 1000
fileNumber = 10
sink_file(path, fromHost, fromPort, toHost, toPort, fileNumber)
