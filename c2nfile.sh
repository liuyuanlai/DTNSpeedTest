#!/bin/bash

#rm $lustre\gf_test/read_test_files/vary_cc.txt
fileTimeStamp=$(date "+%m.%d-%H.%M.%S")

#filePath=${lustre}gf_test/read_test_results/vary_cc_result/06.28-20.25.52_night_posix.txt
filePath=${fileTimeStamp}-100G_cc_ppq.txt
touch $filePath
#for cc in 2 4 8 10 20 30 40 50 60 70 80 90 100 200 300 400
#for rtt in 20 40 60 80 100 150 200
for i in 1 2 3 4 5
do
	#sudo tc qdisc del dev eno1 root netem
	#sudo tc qdisc add dev eno1 root netem delay ${rtt}ms
	#echo "rtt: ${rtt}ms"
	#echo "rtt: ${rtt}ms" >> $filePath
	echo "i: ${i}"
	echo "i: ${i}" >> $filePath
	for cc in 1 4 8 12 16 20 24 28 32
	do 
		echo "cc: ${cc}"
		echo "cc: ${cc}" >> $filePath
		for ppq in 1 4 8 12 16 20
		do
			#timeStamp=$(date "+%Y.%m.%d-%H.%M.%S")
			#echo $timeStamp >> $filePath
			echo "ppq: ${ppq}"
			echo "ppq: ${ppq}" >> $filePath
			/usr/bin/time -a -o $filePath -f "%e" globus-url-copy -q -af c2n-alias-file -p 1 -cc $cc -ppq $ppq ftp:///home/cc/data_100G/ ftp:///global/cscratch1/sd/yuanlai/gf_test/data_100G/
			#timeStamp=$(date "+%Y.%m.%d-%H.%M.%S")
			#echo $timeStamp >> $filePath
		done
	done
done	


