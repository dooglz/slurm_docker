#!/bin/bash

sudo docker kill slurm_node || true
sudo docker rm slurm_node || true
sudo docker volume rm -f slurmnode_vol || true

#grab munge key outof ctld
sudo docker cp slurm_ctld:/etc/munge/munge.key ./ || exit 1;
#sudo docker volume create slurmnode_vol

sudo docker build -t slurm:node -f slurm_node.dockerfile .

sudo docker run -d --name slurm_node \
		--hostname=snode1 \
		--net=slurm_net \
		--net-alias=snode1 \
		slurm:node

sudo docker exec -it slurm_ctld scontrol update nodename=snode1 state=IDLE

#run this on ctrl 
#scontrol update nodename=snode1 state=IDLE


#Run this to get inside
#dk exec -it slurm_node /bin/bash
