#!/bin/bash

for i in 1 20 50 100 200 500 1000 2000 5000 10000
do
	for j in $(seq 0 $(expr $i - 1))
	do
		ln -s /dev/zero /global/cscratch1/sd/yuanlai/gf_test/linear_test_files/linear_test_5G_devzero/${i}/file${j}
	done
done
