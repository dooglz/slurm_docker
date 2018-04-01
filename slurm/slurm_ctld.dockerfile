FROM ubuntu:bionic
LABEL maintainer="Dooglz"

#package build step to stop doing this every docker build
RUN apt-get update

#ensure munge and slurm have same uids accross cluster
RUN export MUNGEUID=63000 && export SLURMUID=64030  && \
	groupadd -g $MUNGEUID munge && \
	useradd  -M -u $MUNGEUID -g munge  -s /usr/sbin/nologin munge && \
	groupadd -g $SLURMUID slurm && \
	useradd  -M -u $SLURMUID -g slurm  -s /usr/sbin/nologin slurm


RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
	slurm-wlm  \
    git bzip2 nano wget && \
    rm -rf /var/lib/apt/lists/*

ADD --chown=slurm ./slurm.conf /etc/slurm-llnl/slurm.conf

CMD	service munge start && \
	mkdir -p /slurmctld/log/ && mkdir -p /slurmctld/log/ &&  chown -R slurm /slurmctld/ && \
	slurmctld -D
