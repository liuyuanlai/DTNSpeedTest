#!/bin/bash

#fileTimeStamp=$(date "+%m.%d-%H.%M.%S")

#filePath=${lustre}gf_test/write_test_results/fix_cc_result/${fileTimeStamp}_night_posix.txt

#touch $filePath

cc=96
t=90
m=POSIX
#timeStamp=$(date "+%H.%M.%S")
#echo $timeStamp >> $filePath
globus-url-copy -vb -cc $cc -t $t -f ${lustre}gf_test/write_test_files/${m}/h2hList.txt
