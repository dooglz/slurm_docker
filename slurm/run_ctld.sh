#!/bin/bash


#docker run -d -v ./build/:/build/ docker_image:tag --name slurm_builder -it slurm:builder

sudo docker kill slurm_ctld || true
sudo docker rm slurm_ctld || true
sudo docker network create slurm_net --subnet=172.18.0.0/16 || true

sudo docker build -t slurm:master -f slurm_ctld.dockerfile .
#sudo docker run -v $PWD/slurmctld/:/slurmctld/ -d --name slurm_ctld --hostname=OSLURMCTLD slurm:master
                #--dns-search=slurm --dns=192.168.1.1 \
                # --restart=always

sudo docker build -t slurm:ctld -f slurm_ctld.dockerfile .

sudo docker run -d --name slurm_ctld \
		--hostname=OSLURMCTLD \
		--mount source=slurmctld_vol,target=/slurmctld \
		--restart=always \
 		--net=slurm_net \
		--net-alias=OSLURMCTLD \
		--ip 172.18.0.100 \
		slurm:ctld


#Run this to get inside
#dk exec -it slurm_ctld /bin/bash
