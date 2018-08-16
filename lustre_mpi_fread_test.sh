#!/bin/bash

file="mpi_fread_test/vary_np_test_new1.txt"

for np in 10 20 40 60 80 100 200 400 600 800
do
	echo $np
	echo "np: ${np}" >> $file
	mpirun -n $np -f mpi_fread_test/host_file mpi_fread_test/s5o_mpi_fread_test >> $file
	mpirun -n $np -f mpi_fread_test/host_file mpi_fread_test/sao_mpi_fread_test >> $file
	mpirun -n $np -f mpi_fread_test/host_file mpi_fread_test/bao_mpi_fread_test >> $file
done	
echo "done"

