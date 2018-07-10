for cc in $(seq  1 64)
do
	echo $cc
	taskid=$(ssh lyl@cli.globusonline.org transfer --label=$cc --no-verify-checksum --perf-p=1 --perf-cc=$cc -- nersc#dtn/global/cscratch1/sd/yuanlai/gf_test/read_test_files/ nersc#dtn/global/project/projectdirs/m2930/lyl/gf_test/l2g_test/ -r)
	taskid=${taskid:9}
	ssh lyl@cli.globusonline.org wait $taskid
done