#!/bin/bash

echo "np,rank,dtn,nfile,nbyte,tfopen,tfwrite,tfclose,tsleep,telapse,cfwrite,rtsleep" > nosleep-small248fns-bysize.csv

for np in 2 3 5 9 11 21 31 41 51 61 71 81 91 101 201 301 401
do
	mpirun -np $np -f host_file ./a.out smallfsize-bysize.txt >> nosleep-small248fns-bysize.csv
done
