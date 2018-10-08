#!/bin/bash
folder=/global/homes/y/yuanlai/workspace/DTNSpeedTest/jupyter/cwnd_moniter_result_cc64_128/
rm -rf $folder
ip=84
mkdir $folder
while : 
do	
	sleep 0.001
	for i in $(seq 12)
	do
		/usr/sbin/ss -i | grep -i -A 1  140.221.68.$(expr ip + $i) >> ${folder}cwnd_N2Afile_cc64_128k_miradtn$(printf "%02d" $i).txt
	done
	#ss -i | grep -i -A 1  129.114.109.111 >> cwnd.txt
done	
