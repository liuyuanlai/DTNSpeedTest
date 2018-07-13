#!/bin/bash

#rm $lustre\gf_test/read_test_files/vary_cc.txt
fileTimeStamp=$(date "+%m.%d-%H.%M.%S")

l2gDir=/global/project/projectdirs/m2930/lyl/gf_test/l2g_test
rm -rf $l2gDir

#filePath=${lustre}gf_test/read_test_results/vary_cc_result/06.28-20.25.52_night_posix.txt
filePath=${lustre}gf_test/l2g_test_results/vary_cc_result/${fileTimeStamp}_posix.txt
touch $filePath
for cc in $(seq 2 2 96)
do
	mkdir $l2gDir
	timeStamp=$(date "+%Y-%m-%d %H.%M.%S")
	echo $timeStamp >> $filePath
	echo $cc
	echo $cc >> $filePath
	/usr/bin/time -a -o $filePath -f "%e" globus-url-copy -q -cc $cc -f ${lustre}gf_test/read_test_files/l2gDiffDTNList.txt
	timeStamp=$(date "+%Y-%m-%d %H.%M.%S")
	echo $timeStamp >> $filePath
	rm -rf $l2gDir
done	


