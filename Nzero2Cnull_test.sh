#!/bin/bash

for i in $(seq 5)
do
        echo $i
        /usr/bin/time -a -o 20_1Gzero2null_rate.txt -f "%e" globus-url-copy -cc 1 -v -p 1 -af n2c-alias-file -len 1073741824 -f /global/cscratch1/sd/yuanlai/gf_test/from_chame/20_1G/zero2nullList-alias_mode.txt
done
