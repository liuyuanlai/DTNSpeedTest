#!/bin/bash

P=1
t=300

for i in 01 02 04 05 06 07 08 09 10
do
	for j in 01 02 03 04 05 06 07 08 09 10 11 12
	do 
		ssh dtn${i} iperf3 -c miradtn${j}.alcf.anl.gov -t $t -P $P -p 50500 &
	done
done


