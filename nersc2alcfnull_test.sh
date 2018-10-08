#!/bin/bash

#rm $lustre\gf_test/read_test_files/vary_cc.txt
fileTimeStamp=$(date "+%m.%d-%H.%M.%S")

#filePath=${lustre}gf_test/read_test_results/vary_cc_result/06.28-20.25.52_night_posix.txt
filePath=${lustre}gf_test/new_read_test_results_all_ost/toMiraNull_result/${fileTimeStamp}-alias_mode_cc60_p4.txt
touch $filePath
#for cc in 2 4 8 10 20 30 40 50 60 70 80 90 100 200 300 400
for cc in 60 
do
	timeStamp=$(date "+%Y.%m.%d-%H.%M.%S")
	echo $timeStamp >> $filePath
	echo $cc
	echo $cc >> $filePath
	/usr/bin/time -a -o $filePath -f "%e" globus-url-copy -q -af n2a-alias-file -p 4 -cc $cc -f ${lustre}gf_test/new_test_files_all_ost/toMiraNullList-bysize-alias_mode.txt
	timeStamp=$(date "+%Y.%m.%d-%H.%M.%S")
	echo $timeStamp >> $filePath
done	


