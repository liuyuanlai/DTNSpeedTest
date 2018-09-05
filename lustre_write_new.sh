#!/bin/bash

fileTimeStamp=$(date "+%m.%d-%H.%M.%S")

n2gDir=${lustre}gf_test/write_test_results/

rm -rf $n2gDir

filePath=${lustre}gf_test/write_test_files/60k_${fileTimeStamp}.txt
touch $filePath
for cc in 1 2 4 8 10 20 30 40 50 60 70 80 90 100 200 300 400
do
	mkdir $n2gDir
	timeStamp=$(date "+%Y-%m-%d %H.%M.%S")
        echo $timeStamp >> $filePath
        echo $cc
        echo $cc >> $filePath

	/usr/bin/time -a -o $filePath -f "%e" globus-url-copy -cc $cc -len 18454064 -f ${lustre}gf_test/write_test_files/fromZeroList.txt
	du -sh $n2gDir >> $filePath
	timeStamp=$(date "+%Y-%m-%d %H.%M.%S")
        echo $timeStamp >> $filePath
	 
	rm -rf $n2gDir
done
