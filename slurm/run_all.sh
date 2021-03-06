#!/bin/bash
echo -e "\n\n Starttng LDAP Server \n\n"
./run_ldap.sh || exit 1;
echo -e "\n\n Starttng Slurm Controller \n\n"
./run_ctld.sh || exit 1;
echo -e "\n\n Starttng Slurm Node - snode1\n\n"
./run_node.sh || exit 1;
echo -e "\n\n Waiitng for node to wake and register\n\n"
sleep 5
sudo docker exec -it slurm_ctld scontrol update nodename=snode1 state=IDLE
echo -e "\n\n Starttng HPC Frontend \n\n"
./run_hpc.sh || exit 1;
echo -e "\n\n ssh 127.0.0.1:8022 for HPC \n webb 127.0.0.1:8080 for ldap admin\n"