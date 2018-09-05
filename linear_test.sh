#!/bin/bash

filePath=same-size-vary-size.txt
for i in 1 20 50 100 200 500 1000 2000 5000 10000 20000
do
	timeStamp=$(date "+%Y.%m.%d-%H.%M.%S")
        echo $timeStamp >> $filePath
        echo $i
        echo $i >> $filePath
        /usr/bin/time -a -o $filePath -f "%e" globus-url-copy -q -cc 1 -f ${lustre}gf_test/new_test_files_vary_size/${i}/toMiraList.txt
        timeStamp=$(date "+%Y.%m.%d-%H.%M.%S")
        echo $timeStamp >> $filePath
done
