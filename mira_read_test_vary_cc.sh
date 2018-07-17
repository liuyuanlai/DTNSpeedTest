#!/bin/bash

fileTimeStamp=$(date "+%m.%d-%H.%M.%S")

#filePath=${lustre}gf_test/read_test_results/vary_cc_result/06.28-20.25.52_night_posix.txt
filePath=/projects/AMASE/lyl/read_test_results/vary_cc_result/${fileTimeStamp}_posix.txt
touch $filePath
for cc in $(seq 2 2 96)
do
	timeStamp=$(date "+%Y.%m.%d-%H.%M.%S")
	echo $timeStamp >> $filePath
	echo $cc
	echo $cc >> $filePath
	/usr/bin/time -a -o $filePath -f "%e" globus-url-copy -q -cc $cc -f /projects/AMASE/lyl/read_test_files/gpfs2nullList.txt
	timeStamp=$(date "+%Y.%m.%d-%H.%M.%S")
	echo $timeStamp >> $filePath
done	


