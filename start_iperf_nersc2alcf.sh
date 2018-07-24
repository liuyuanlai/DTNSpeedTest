#!/bin/bash

fileTimeStamp=$(date "+%Y.%m.%d-%H.%M.%S")

filePath=${lustre}gf_test/iperf_nersc2alcf_test_results/${fileTimeStamp}.txt
touch filePath
echo $fileTimeStamp >> $filePath
echo "t=300" >> $filePath
echo "p=10" >> $filePath
./iperf_nersc2alcf.sh >> $filePath

