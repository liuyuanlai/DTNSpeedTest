#!/bin/bash

file="mpi_fread_test/gpfs_vary_np_test1.txt"

for np in 1 2 4 6 8 10 12 14 16 18 20
do
	echo $np
	echo "np: ${np}" >> $file
	mpirun -n $np -f mpi_fread_test/host_file mpi_fread_test/gpfs_sao_mpi_fread_test >> $file
	mpirun -n $np -f mpi_fread_test/host_file mpi_fread_test/gpfs_bao_mpi_fread_test >> $file
done	
echo "done"

