#!/bin/bash

rm $lustre\gf_test/read_test_files/vary_cc.txt
for cc in $(seq 20)
do
	echo $cc
	/usr/bin/time -a -o $lustre\gf_test/read_test_files/vary_cc.txt -f "%e" globus-url-copy -vb -cc $cc -f $lustre\gf_test/read_test_files/h2hList.txt
done	


