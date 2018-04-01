#!/bin/bash

sudo docker kill ldap || true
sudo docker rm ldap || true
sudo docker network create slurm_net --subnet=172.18.0.0/16 || true

sudo docker build -t ldap:host -f ldap_host.dockerfile . || exit 1;

sudo docker run -d --name ldap \
		--hostname=ldap \
		--net=slurm_net \
		--net-alias=ldap \
		--ip 172.18.0.50 \
		-p 8080:80 \
		ldap:host || exit 1;

#Run this to get inside
#dk exec -it ldap /bin/bash