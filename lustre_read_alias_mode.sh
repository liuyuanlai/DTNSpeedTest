#!/bin/bash

#rm $lustre\gf_test/read_test_files/vary_cc.txt
fileTimeStamp=$(date "+%m.%d-%H.%M.%S")

#filePath=${lustre}gf_test/read_test_results/vary_cc_result/06.28-20.25.52_night_posix.txt
filePath=${lustre}gf_test/new_test_files_same_size_128/${fileTimeStamp}_alias_mode_64.txt
touch $filePath
#for cc in 2 4 8 10 20 30 40 50 60 70 80 90 100 200 300 400
for cc in 64
do
	timeStamp=$(date "+%Y.%m.%d-%H.%M.%S")
	echo $timeStamp >> $filePath
	echo $cc
	echo $cc >> $filePath
	/usr/bin/time -a -o $filePath -f "%e" globus-url-copy -q -cc $cc -p 2 -af n2null-alias-file -f ${lustre}gf_test/new_test_files_same_size_128/toNullList-alias_mode.txt
	timeStamp=$(date "+%Y.%m.%d-%H.%M.%S")
	echo $timeStamp >> $filePath
done	


