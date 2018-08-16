#!/bin/bash

file="mpi_fread_test/mira_vary_np_test1.txt"

for np in 12 24 48 72 96 120 240 480 720 960
do
	echo $np
	echo "np: ${np}" >> $file
	mpirun -n $np -f mpi_fread_test/mira_host_file mpi_fread_test/mira_sao_mpi_fread_test >> $file
	mpirun -n $np -f mpi_fread_test/mira_host_file mpi_fread_test/mira_bao_mpi_fread_test >> $file
done	
echo "done"
