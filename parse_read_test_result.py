#!/usr/bin/env python
from __future__ import division

path = "/global/homes/y/yuanlai/workspace/DTNSpeedTest/tmp/vary_cc.txt"
totalSize = 2**40
with open(path, 'r') as fp:
	for cc in range(1, 21):
		time = float(fp.readline().rstrip('\n'))
		speed = totalSize / time
		print "cc=" + str(cc) + ":	" + "transfer rate=" + str(speed / (2**20))
