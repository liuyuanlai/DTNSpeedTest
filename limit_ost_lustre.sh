#!/bin/bash

for i in $(seq 3)
do	
	echo "i: ${i}"
	./lustre_read_test_vary_cc.sh
	./lustre2lustre_test_vary_cc.sh
done
