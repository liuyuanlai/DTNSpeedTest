#!/bin/bash


for i in 02 03 04 05 06 07 08 09 10 11 12 01
do
	ssh miradtn$i 'ps -u yuanlai | grep -i iperf3 | awk '\''{print $1}'\''| xargs kill'
done
