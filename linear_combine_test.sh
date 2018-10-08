#!/bin/bash
for i in $(seq 10)
do
	echo $i
	./gen_file_same_size.py
	./linear_test.sh
	./gen_file_same_size.py
	./linear_test_Nersc_read.sh
done

