#!/bin/bash

p=50500

for i in 01 02 03 04 05 06 07 08 09 10 11 12
do
	ssh -f miradtn${i} "iperf3 -s -p $p &"
done
