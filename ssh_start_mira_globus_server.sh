#!/bin/bash

from_port=12334
from_server_folder=/projects/AMASE/lyl
#to_server_folder=

for nid in 01 02 03 04 05 06 07 08 09 10 11 12
do
	ssh -f miradtn$nid "globus-gridftp-server -aa -p $from_port -rp $from_server_folder,/dev &"
done
