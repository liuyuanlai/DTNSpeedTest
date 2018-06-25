#!/bin/bash

from_port=12334
from_server_folder="/global/project/projectdirs/m2930/lyl/gf_test"
to_port=12335
to_server_folder="/dev/"

globus-gridftp-server -aa -p $from_port -rp $from_server_folder &
globus-gridftp-server -aa -p $to_port -rp $to_server_folder &
