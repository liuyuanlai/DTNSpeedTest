#!/bin/bash

P=10
t=300

for node in 01 02 04 05 06 07 08 09 10
do
	ssh dtn${node} iperf3 -c miradtn${node}.alcf.anl.gov -t $t -P $P -p 50500 &
done
ssh dtn08 iperf3 -c miradtn03.alcf.anl.gov -t $t -P $P -p 50500 &
ssh dtn09 iperf3 -c miradtn11.alcf.anl.gov -t $t -P $P -p 50500 &
ssh dtn10 iperf3 -c miradtn12.alcf.anl.gov -t $t -P $P -p 50500 &


