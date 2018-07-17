#!/bin/bash

p=50050

for i in 01 02 03 04 05 06 07 08 09 10 11 12
do
	ssh miradtn$i 'ps -u yuanlai | grep -i iperf | awk '\''{print $1}'\''| xargs kill'
done
