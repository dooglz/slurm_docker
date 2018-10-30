#!/bin/bash
sudo docker kill pyslurm || true
sudo docker rm pyslurm || true

#grab munge key out of ctld
sudo docker cp slurm_ctld:/etc/munge/munge.key ./ || exit 1;

sudo docker build -t pyslurm -f pyslurm.dockerfile . || exit 1;

sudo docker run -d --name pyslurm \
		--hostname=pyslurm \
 		--net=slurm_net \
		--net-alias=pyslurm \
		--ip 172.18.0.180 \
		-p 8090:80 \
		pyslurm || exit 1;

#Run this to get inside
#dk exec -it hpc_frontend /bin/bash
