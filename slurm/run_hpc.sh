#!/bin/bash
sudo docker kill hpc_frontend || true
sudo docker rm hpc_frontend || true
sudo docker network create hpc_frontend --subnet=172.18.0.0/16 || true

#grab munge key out of ctld
sudo docker cp slurm_ctld:/etc/munge/munge.key ./ || exit 1;

sudo docker build -t hpc_frontend -f hpc_frontend.dockerfile .

sudo docker run -d --name hpc_frontend \
		--hostname=HPC \
		--mount source=hpc_home_vol,target=/home \
		--restart=always \
 		--net=slurm_net \
		--net-alias=HPC \
		--ip 172.18.0.150 \
		-p 8022:22 \
		hpc_frontend

#Run this to get inside
#dk exec -it hpc_frontend /bin/bash