#!/bin/bash

fileTimeStamp=$(date "+%m.%d-%H.%M.%S")

n2gDir=/projects/AMASE/lyl/write_test_files

rm -rf $n2gDir

filePath=/projects/AMASE/lyl/write_test_results/${fileTimeStamp}_posix.txt
touch $filePath
t=60
for cc in $(seq 2 2 96)
do
	mkdir $n2gDir
	timeStamp=$(date "+%Y-%m-%d %H.%M.%S")
        echo $timeStamp >> $filePath
        echo $cc
        echo $cc >> $filePath

	globus-url-copy -cc $cc -t $t -f /projects/AMASE/lyl/write_test_results/mirafzeroList.txt
	du -sh  $n2gDir >> $filePath

	timeStamp=$(date "+%Y-%m-%d %H.%M.%S")
        echo $timeStamp >> $filePath
	 
	rm -rf $n2gDir
done
