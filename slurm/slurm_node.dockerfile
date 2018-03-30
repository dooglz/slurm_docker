FROM ubuntu:bionic
LABEL maintainer="Dooglz"

RUN  export MUNGEUID=63000 && export SLURMUID=64030  && \
		groupadd -g $MUNGEUID munge && \
		useradd  -M -u $MUNGEUID -g munge  -s /usr/sbin/nologin munge && \
		groupadd -g $SLURMUID slurm && \
		useradd  -M -u $SLURMUID -g slurm  -s /usr/sbin/nologin slurm

RUN apt-get update && apt-get install -y --no-install-recommends \
    slurmd  \
    git bzip2 nano wget && \
    rm -rf /var/lib/apt/lists/*

#ADD --chown=slurm http://games.soc.napier.ac.uk/a/slurm.html /etc/slurm-llnl/slurm.conf
ADD --chown=slurm ./slurm.conf /etc/slurm-llnl/slurm.conf
ADD --chown=munge ./munge.key /etc/munge/munge.key

CMD  service munge start && \
     mkdir -p /slurmctld/log/ && mkdir -p /slurmctld/log/ &&  chown -R slurm /slurmctld/ && slurmd -D
