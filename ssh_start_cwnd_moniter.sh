#!/bin/bash

for nid in 01 02 03 04 05 06 07 08 09 10
do
        #ssh -f dtn$nid "globus-gridftp-server -aa -p $from_port -rp $from_server_folder,$to_server_folder,/dev &"
        ssh -f dtn$nid "/global/homes/y/yuanlai/workspace/DTNSpeedTest/cwnd_moniter_m${nid}.sh"
done
