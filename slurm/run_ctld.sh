#!/bin/bash
sudo docker kill slurm_ctld || true
sudo docker rm slurm_ctld || true
sudo docker network create slurm_net --subnet=172.18.0.0/16 || true

sudo docker build -t slurm:ctld -f slurm_ctld.dockerfile . || exit 1;

sudo docker run -d --name slurm_ctld \
		--hostname=OSLURMCTLD \
		--mount source=slurmctld_vol,target=/slurmctld \
		--restart=always \
 		--net=slurm_net \
		--net-alias=OSLURMCTLD \
		--ip 172.18.0.100 \
		slurm:ctld || exit 1;


#Run this to get inside
#dk exec -it slurm_ctld /bin/bash
