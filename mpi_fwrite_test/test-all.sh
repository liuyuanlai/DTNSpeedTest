#!/bin/bash

for ss in $(seq 1000 5000 51000)
do
	echo "np,rank,dtn,nfile,nbyte,tfopen,tfread,tfclose,tsleep,telapse,cfread,rtsleep" > vary_sample_size_test/nosleep-small5fns-bysize-${ss}.csv
	echo "np,rank,dtn,nfile,nbyte,tfopen,tfread,tfclose,tsleep,telapse,cfread,rtsleep" > vary_sample_size_test/nosleep-small5fns-bysize-byost-${ss}.csv
	echo "np,rank,dtn,nfile,nbyte,tfopen,tfread,tfclose,tsleep,telapse,cfread,rtsleep" > vary_sample_size_test/nosleep-small5fns-size-ost-bysize-${ss}.csv

	#for np in 101
	for np in 6 11 31 51 71 91 201 401
	do
	   mpirun -np $np -f host_file ./ost_not_aware_no_sleep small5fns-bysize-${ss}.txt >> vary_sample_size_test/nosleep-small5fns-bysize-${ss}.csv
	   mpirun -np $np -f host_file ./ost_not_aware_no_sleep small5fns-bysize-byost-${ss}.txt >> vary_sample_size_test/nosleep-small5fns-bysize-byost-${ss}.csv
	   mpirun -np $np -f host_file ./ost_aware_5_no_sleep small5fns-size-ost-bysize-${ss}.txt >> vary_sample_size_test/nosleep-small5fns-size-ost-bysize-${ss}.csv
#	   mpirun -np $np -f host_file ./ost_aware_5_limit_40_no_sleep small5fns-size-ost-bysize-${ss}.txt >> nosleep-small5fns-size-ost-bysize-limit-40.csv
	done
done


#echo "np,rank,dtn,nfile,nbyte,tfopen,tfread,tfclose,tsleep,telapse,cfread,rtsleep" > sleep-small5fns-bysize.csv
#echo "np,rank,dtn,nfile,nbyte,tfopen,tfread,tfclose,tsleep,telapse,cfread,rtsleep" > sleep-small5fns-bysize-byost.csv
#echo "np,rank,dtn,nfile,nbyte,tfopen,tfread,tfclose,tsleep,telapse,cfread,rtsleep" > sleep-small5fns-size-ost-bysize.csv
#echo "np,rank,dtn,nfile,nbyte,tfopen,tfread,tfclose,tsleep,telapse,cfread,rtsleep" > sleep-small5fns-size-ost-bysize-limit-40.csv

#for np in 101
#for np in 2 3 5 9 11 21 31 41 51 61 71 81 91 101 201 301 401
#do
#   mpirun -np $np -f host_file ./ost_not_aware small5fns-bysize.txt >> sleep-small5fns-bysize.csv
#   mpirun -np $np -f host_file ./ost_not_aware small5fns-bysize-byost.txt >> sleep-small5fns-bysize-byost.csv
#   mpirun -np $np -f host_file ./ost_aware_5 small5fns-size-ost-bysize.txt >> sleep-small5fns-size-ost-bysize.csv
#   mpirun -np $np -f host_file ./ost_aware_5_limit_40 small5fns-size-ost-bysize.txt >> sleep-small5fns-size-ost-bysize-limit-40.csv
#done
