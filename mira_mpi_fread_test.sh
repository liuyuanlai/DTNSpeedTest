#!/bin/bash

file="mpi_fread_test/mira_dynamic/mira_dynamic_vary_np_test.txt"

for np in 13 25 49 73 97 121 241 481 721 961
do
	echo $np
	echo "np: ${np}" >> $file
	mpirun -n $np -f mpi_fread_test/mira_host_file mpi_fread_test/dynamic_mpi_fread_test mpi_fread_test/s_fname_list.txt >> $file
	mpirun -n $np -f mpi_fread_test/mira_host_file mpi_fread_test/dynamic_mpi_fread_test mpi_fread_test/b_fname_list.tx t>> $file
done	
echo "done"

