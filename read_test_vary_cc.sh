#!/bin/bash

#rm $lustre\gf_test/read_test_files/vary_cc.txt
fileTimeStamp=$(date "+%m.%d-%H.%M.%S")

#filePath=${lustre}gf_test/read_test_results/vary_cc_result/06.28-20.25.52_night_posix.txt
filePath=${lustre}gf_test/read_test_results/vary_cc_result/${fileTimeStamp}_night_mpi.txt
touch $filePath
for cc in $(seq 96)
do
	timeStamp=$(date "+%H.%M.%S")
	echo $timeStamp >> $filePath
	echo $cc
	/usr/bin/time -a -o $filePath -f "%e" globus-url-copy -q -cc $cc -f ${lustre}gf_test/read_test_files/h2hList.txt
done	


