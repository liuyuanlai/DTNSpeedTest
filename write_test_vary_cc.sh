#!/bin/bash

fileTimeStamp=$(date "+%m.%d-%H.%M.%S")

n2gDir=${gpfs}gf_test/write_test_results/

rm -rf $n2gDir

filePath=${gpfs}gf_test/write_test_files/${fileTimeStamp}_mpi.txt
touch $filePath
t=60
for cc in $(seq 96)
do
	mkdir $n2gDir
	timeStamp=$(date "+%Y-%m-%d %H.%M.%S")
        echo $timeStamp >> $filePath
        echo $cc

	globus-url-copy -cc $cc -t $t -f ${gpfs}gf_test/write_test_files/h2hList.txt
	du -sh  $n2gDir >> $filePath

	timeStamp=$(date "+%Y-%m-%d %H.%M.%S")
        echo $timeStamp >> $filePath
	 
	rm -rf $n2gDir
done
