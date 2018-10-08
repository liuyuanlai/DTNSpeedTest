#!/bin/bash

filePath=linear_test_result/Nzero2null_linear_test_5G_1004_pp500.txt
#ts=137438953472
ts=5368709120
for i in 1 20 50 100 200 500 1000 2000 5000 10000
do
	timeStamp=$(date "+%Y.%m.%d-%H.%M.%S")
        echo $timeStamp >> $filePath
        echo $i
        echo $i >> $filePath
	let len=ts/i
        #/usr/bin/time -a -o $filePath -f "%e" globus-url-copy -q -cc 1 -p 1 -ppq 500 -af linear-alias-file -len $len -f ${lustre}gf_test/linear_test_Nzero2Anull_list/${i}_toMiraNullList.txt
        /usr/bin/time -a -o $filePath -f "%e" globus-url-copy -q -cc 1 -p 1 -ppq 500 -af linear-alias-file -len $len ftp:///global/cscratch1/sd/yuanlai/gf_test/linear_test_files/linear_test_5G_devzero/${i}/ ftp:///projects/AMASE/lyl/linear_test_files/linear_test_5G_devnull/${i}/
        timeStamp=$(date "+%Y.%m.%d-%H.%M.%S")
        echo $timeStamp >> $filePath
done
