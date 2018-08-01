#!/bin/bash

#rm $lustre\gf_test/read_test_files/vary_cc.txt
fileTimeStamp=$(date "+%m.%d-%H.%M.%S")

#filePath=${lustre}gf_test/read_test_results/vary_cc_result/06.28-20.25.52_night_posix.txt
filePath=${lustre}gf_test/new_read_test_results_limit_ost/vary_cc_result/${fileTimeStamp}.txt
touch $filePath
for cc in 4 8 16 32 64 96 128
do
	timeStamp=$(date "+%Y.%m.%d-%H.%M.%S")
	echo $timeStamp >> $filePath
	echo $cc
	echo $cc >> $filePath
	/usr/bin/time -a -o $filePath -f "%e" globus-url-copy -q -cc $cc -f ${lustre}gf_test/new_test_files_limit_ost/toNullList
	timeStamp=$(date "+%Y.%m.%d-%H.%M.%S")
	echo $timeStamp >> $filePath
done	


