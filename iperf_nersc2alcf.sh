#!/bin/bash

P=7
t=600

for node in 01 02 04 05 06 07 08 09 10
do
	ssh dtn${node} iperf -c miradtn${node}.alcf.anl.gov -t $t -P $P -p 50050 &
done
ssh dtn01 iperf -c miradtn03.alcf.anl.gov -t $t -P $P -p 50050 &
ssh dtn02 iperf -c miradtn11.alcf.anl.gov -t $t -P $P -p 50050 &
ssh dtn04 iperf -c miradtn12.alcf.anl.gov -t $t -P $P -p 50050 &


