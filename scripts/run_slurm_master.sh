#!/bin/bash

sudo docker kill slurm_master
sudo docker rm slurm_master
sudo docker build -t  slurm:master -f slurm_master_apt.dockerfile .
sudo docker run --restart=always --dns-search=slurm --dns=192.168.1.1 \
	-v /mnt/storage/slurm/slurmctld:/var/lib/slurm-llnl/slurmctld \
	-v /mnt/storage/slurm/slurmd:/var/lib/slurm-llnl/slurmd \
	-v /mnt/storage/slurm/logs:/var/log/slurm-llnl \
	--name slurm_master -it slurm:master

