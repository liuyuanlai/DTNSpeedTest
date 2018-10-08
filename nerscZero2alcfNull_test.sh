#!/bin/bash

#rm $lustre\gf_test/read_test_files/vary_cc.txt
fileTimeStamp=$(date "+%m.%d-%H.%M.%S")

#filePath=${lustre}gf_test/read_test_results/vary_cc_result/06.28-20.25.52_night_posix.txt
filePath=${lustre}gf_test/new_read_test_results_all_ost/toMiraNull_result/${fileTimeStamp}-alias_mode_varycc_Nzero2Anull.txt
touch $filePath
for cc in 2 4 8 10 20 30 40 50 60 70 80 90 100 200 300 400 450 500
#for cc in 64 
do
	timeStamp=$(date "+%Y.%m.%d-%H.%M.%S")
	echo $timeStamp >> $filePath
	echo $cc
	echo $cc >> $filePath
	/usr/bin/time -a -o $filePath -f "%e" globus-url-copy -q -af n2a-alias-file -p 2 -cc $cc -ppq 10 -len 18454064 -f ${lustre}gf_test/new_test_files_all_ost/Zero2NullList-alias_mode.txt
	timeStamp=$(date "+%Y.%m.%d-%H.%M.%S")
	echo $timeStamp >> $filePath
done	


