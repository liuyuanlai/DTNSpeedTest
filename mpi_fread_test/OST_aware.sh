#!/bin/bash

for np in 
do
	echo $np >> 
	mpirun -np $np -f host_file ./ost_aware_5 f_path_size_ost_s5.txt >> result.txt 
