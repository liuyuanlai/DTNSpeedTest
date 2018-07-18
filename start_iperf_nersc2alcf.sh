#!/bin/bash

fileTimeStamp=$(date "+%m.%d-%H.%M.%S")

filePath=/projects/AMASE/lyl/iperf_nersc2alcf_test_results/${fileTimeStamp}.txt
touch filePath
echo $fileTimeStamp >> $filePath
./iperf_nersc2alcf.sh >> $filePath

