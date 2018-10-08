#!/bin/bash

filePath=linear_test_result/N2Afile_linear_test_5G_1004_pp500.txt
for i in 1 20 50 100 200 500 1000 2000 5000 10000
do
	#./cwnd_moniter_m12.sh $i &
	timeStamp=$(date "+%Y.%m.%d-%H.%M.%S")
        echo $timeStamp >> $filePath
        echo $i
        echo $i >> $filePath
        #/usr/bin/time -a -o $filePath -f "%e" globus-url-copy -q -cc 1 -p 1 -ppq 100 -af linear-alias-file -f ${lustre}gf_test/new_test_files_vary_size_5G/${i}/toMiraList-alias_mode.txt
        /usr/bin/time -a -o $filePath -f "%e" globus-url-copy -q -cc 1 -p 1 -ppq 500 -af linear-alias-file ftp:///global/cscratch1/sd/yuanlai/gf_test/linear_test_files/linear_test_5G/${i}/ ftp:///projects/AMASE/lyl/linear_test_files/linear_test_5G/${i}/
        timeStamp=$(date "+%Y.%m.%d-%H.%M.%S")
        echo $timeStamp >> $filePath
	#ps -u yuanlai | grep -i cwnd | awk '{print $1}' | xargs kill
done
