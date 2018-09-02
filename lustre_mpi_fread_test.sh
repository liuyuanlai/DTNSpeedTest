#!/bin/bash

file="mpi_fread_test/lustre/lustre_vary_np_test1.txt"

for np in 10 20 40 60 80 100 200 400 600 800
do
	echo $np
	echo "np: ${np}" >> $file
	mpirun -n $np -f mpi_fread_test/host_file mpi_fread_test/lustre_sao_mpi_fread_test $np >> $file
	mpirun -n $np -f mpi_fread_test/host_file mpi_fread_test/lustre_bao_mpi_fread_test $np >> $file
done	
echo "done"

