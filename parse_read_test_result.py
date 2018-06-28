#!/usr/bin/env python
from __future__ import division
import matplotlib.pyplot as plt

#path = "/global/homes/y/yuanlai/workspace/DTNSpeedTest/tmp/vary_cc.txt"
path = "/global/cscratch1/sd/yuanlai/gf_test/read_test_files/vary_cc.txt"
totalSize = 2**40
ccList = range(1, 31)
tr = []
with open(path, 'r') as fp:
	for cc in range(1, 31):
		timestr = fp.readline().rstrip('\n')
		#print timestr
		try:
			time = float(timestr)
		except:
			break
		speed = totalSize / time
		tr.append("%.2f" % speed)
		print "cc=" + str(cc) + ":	" + "transfer rate=" + str("%.2f" % (speed / (2**20))) + "M/s"
plt.plot(ccList, tr)
plt.show()
