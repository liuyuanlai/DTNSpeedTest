#!/bin/bash

#rm $lustre\gf_test/read_test_files/vary_cc.txt
fileTimeStamp=$(date "+%m.%d-%H.%M.%S")

#filePath=${lustre}gf_test/read_test_results/vary_cc_result/06.28-20.25.52_night_posix.txt
filePath1=${lustre}gf_test/read_test_results/vary_cc_result/${fileTimeStamp}.txt
filePath2=${lustre}gf_test/new_read_test_results_all_ost/vary_cc_result/${fileTimeStamp}.txt
touch $filePath
for cc in 1 2 4 8 10 20 30 40 50 60 70 80 90 100 200 300 400
#for cc in 192 256 384 512 
do
	timeStamp=$(date "+%Y.%m.%d-%H.%M.%S")
	echo $timeStamp >> $filePath1
	echo $cc
	echo $cc >> $filePath1
	/usr/bin/time -a -o $filePath1 -f "%e" globus-url-copy -q -cc $cc -f ${lustre}gf_test/read_test_files/toNullList-bysize.txt
	timeStamp=$(date "+%Y.%m.%d-%H.%M.%S")
	echo $timeStamp >> $filePath1


	timeStamp=$(date "+%Y.%m.%d-%H.%M.%S")
	echo $timeStamp >> $filePath2
	echo $cc
	echo $cc >> $filePath2
	/usr/bin/time -a -o $filePath2 -f "%e" globus-url-copy -q -cc $cc -f ${lustre}gf_test/new_test_files_all_ost/toNullList-bysize.txt
	timeStamp=$(date "+%Y.%m.%d-%H.%M.%S")
	echo $timeStamp >> $filePath2
done	

echo "np,rank,dtn,nfile,nbyte,tfopen,tfwrite,tfclose,tsleep,telapse,cfwrite,rtsleep" > mpi_fwrite_test/nosleep-small248fns-bysize.csv
echo "np,rank,dtn,nfile,nbyte,tfopen,tfwrite,tfclose,tsleep,telapse,cfwrite,rtsleep" > mpi_fwrite_test/nosleep-big248fns-bysize.csv

for np in 2 3 5 9 11 21 31 41 51 61 71 81 91 101 201 301 401
do
	mpirun -np $np -f mpi_fwrite_test/host_file mpi_fwrite_test/a.out mpi_fwrite_test/smallfsize-bysize.txt >> mpi_fwrite_test/nosleep-small248fns-bysize.csv
	mpirun -np $np -f mpi_fwrite_test/host_file mpi_fwrite_test/a.out mpi_fwrite_test/bigfsize-bysize.txt >> mpi_fwrite_test/nosleep-big248fns-bysize.csv
done
