#!/bin/bash

#rm $lustre\gf_test/read_test_files/vary_cc.txt
fileTimeStamp=$(date "+%m.%d-%H.%M.%S")

#filePath=${lustre}gf_test/read_test_results/vary_cc_result/${fileTimeStamp}.txt
filePath=${lustre}gf_test/read_test_results/vary_cc_result/06.28-08.59.52.txt
#touch $filePath
for cc in $(seq 31 40)
do
	timeStamp=$(date "+%H.%M.%S")
	echo $timeStamp >> $filePath
	echo $cc
	/usr/bin/time -a -o $filePath -f "%e" globus-url-copy -vb -cc $cc -f ${lustre}gf_test/read_test_files/h2hList.txt
done	


