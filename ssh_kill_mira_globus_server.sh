#!/bin/bash

for nid in 01 02 03 04 05 06 07 08 09 10 11 12
do
	ssh miradtn$nid 'ps -u yuanlai | grep -i mpi | awk '\''{print $1}'\''| xargs kill'
done
