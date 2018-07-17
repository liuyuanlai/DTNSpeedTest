#!/bin/bash

for i in $(seq 3)
do	
	echo "i: ${i}"
	./gpfs_read_test_vary_cc.sh
	./gpfs_write_test_vary_cc.sh
	./l2g_vary_cc.sh
done
