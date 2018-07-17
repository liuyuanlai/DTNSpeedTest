#!/bin/bash

P=1

for node in 01 02 04 06 07 08 09 10
do
	ssh dtn${node} iperf3 -c miradtn${node}.alcf.anl.gov -t 30 -P $P -R -p 50050 &
done
ssh dtn01 iperf3 -c miradtn03.alcf.anl.gov -t 30 -P $P -R -p 50050 &
ssh dtn02 iperf3 -c miradtn11.alcf.anl.gov -t 30 -P $P -R -p 50050 &
ssh dtn05 iperf3 -c miradtn12.alcf.anl.gov -t 30 -P $P -R -p 50050 &


