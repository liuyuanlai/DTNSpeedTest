#!/bin/bash

#rm $lustre\gf_test/read_test_files/vary_cc.txt
fileTimeStamp=$(date "+%m.%d-%H.%M.%S")

#filePath=${lustre}gf_test/read_test_results/vary_cc_result/06.28-20.25.52_night_posix.txt
filePath=${lustre}gf_test/new_read_test_results/vary_dis_result/${fileTimeStamp}.txt
touch $filePath
#for cc in 4 8 16 32 64 96 128
for i in $(seq 3)
do
	echo $i
	echo "i: ${i}" >> $filePath
	for cc in $(seq 4 4 96)
	do
		echo $cc
		echo "cc: ${cc}" >> $filePath
		timeStamp=`date -u +%s` 
		echo $timeStamp >> $filePath
		/usr/bin/time -a -o $filePath -f "%e" globus-url-copy -q -cc $cc -f ${lustre}gf_test/new_test_files_all_ost/toNullListNew
		timeStamp=`date -u +%s` 
		echo $timeStamp >> $filePath
		
		timeStamp=`date -u +%s` 
		echo $timeStamp >> $filePath
		/usr/bin/time -a -o $filePath -f "%e" globus-url-copy -q -cc $cc -f ${lustre}gf_test/new_test_files_limit_ost_smaller/toNullListNew
		timeStamp=`date -u +%s` 
		echo $timeStamp >> $filePath
		
		timeStamp=`date -u +%s` 
		echo $timeStamp >> $filePath
		/usr/bin/time -a -o $filePath -f "%e" globus-url-copy -q -cc $cc -f ${lustre}gf_test/read_test_files/toNullListNew
		timeStamp=`date -u +%s` 
		echo $timeStamp >> $filePath
	done
done	


