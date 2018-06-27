#!/bin/bash

from_port=12334
#from_server_folder="/global/project/projectdirs/m2930/lyl/gf_test"
from_server_folder=/global/cscratch1/sd/yuanlai/gf_test
to_port=12335
to_server_folder=/dev/

#for nid in 01 02 04 05 06 07 08 09 10
for nid in 01 02 04 05
do
	ssh -f dtn$nid "globus-gridftp-server -aa -p $from_port -rp $from_server_folder &"
	ssh -f dtn$nid "globus-gridftp-server -aa -p $to_port -rp $to_server_folder &"
done
