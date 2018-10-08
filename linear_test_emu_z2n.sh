#!/bin/bash

#filePath=linear_test_result/Nzero2Alcf_5G_emu_200mssle.txt
#ts=137438953472
for i in 1 20 50 100 200 500 1000 2000 5000 10000 20000 50000
do
	timeStamp=$(date "+%Y.%m.%d-%H.%M.%S")
        #echo $timeStamp >> $filePath
        echo $i
        #echo $i >> $filePath
	let len=ts/i
        /usr/bin/time -f "%e" ./client $i 
        #timeStamp=$(date "+%Y.%m.%d-%H.%M.%S")
        #echo $timeStamp >> $filePath
done
