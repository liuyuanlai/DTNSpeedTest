#!/bin/bash
while : 
do	
	sleep 0.001
	/usr/sbin/ss -i | grep -i -A 1  140.221.68.89 >> /global/homes/y/yuanlai/workspace/DTNSpeedTest/jupyter/cwnd_moniter_result/cwnd_Nfile2Anull_cc60_miradtn05.txt
	#ss -i | grep -i -A 1  129.114.109.111 >> cwnd.txt
done	
