#!/bin/bash

for nid in 01 02 04 05 06 07 08 09 10
#for nid in 01 02 04 05
do
	ssh dtn$nid 'ps -u yuanlai | grep -i cwnd_moniter | awk '\''{print $1}'\''| xargs kill'
done
