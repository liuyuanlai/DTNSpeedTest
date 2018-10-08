#!/bin/bash

filePath=linear_test_result/Nfile2Anull_linear_test_5G.txt
for i in 1 20 50 100 200 500 1000 2000 5000 10000
#for i in 10000 5000 2000 1000 500 200 100 50 20 1
do
	timeStamp=$(date "+%Y.%m.%d-%H.%M.%S")
        echo $timeStamp >> $filePath
        echo $i
        echo $i >> $filePath
        /usr/bin/time -a -o $filePath -f "%e" globus-url-copy -q -cc 1 -p 1 -ppq 10 -af linear-alias-file -f ${lustre}gf_test/new_test_files_vary_size_5G/${i}/toNerscNullList-alias_mode.txt
        timeStamp=$(date "+%Y.%m.%d-%H.%M.%S")
        echo $timeStamp >> $filePath
done
