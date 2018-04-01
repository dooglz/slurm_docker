FROM ubuntu:bionic
LABEL maintainer="Dooglz"

#package build step to stop doing this every docker build
RUN apt-get update

RUN  export MUNGEUID=63000 && export SLURMUID=64030  && \
		groupadd -g $MUNGEUID munge && \
		useradd  -M -u $MUNGEUID -g munge  -s /usr/sbin/nologin munge && \
		groupadd -g $SLURMUID slurm && \
		useradd  -M -u $SLURMUID -g slurm  -s /usr/sbin/nologin slurm


RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
	slurm-wlm  \
    git bzip2 nano wget && \
    rm -rf /var/lib/apt/lists/*

#RUN	sed -i '$ d' /etc/phpldapadmin/config.php && \
#	echo "\$config->custom->appearance['hide_template_warning'] = true;" >> /etc/phpldapadmin/config.php && \
#	echo "?>" >> /etc/phpldapadmin/config.php

#ADD --chown=slurm http://games.soc.napier.ac.uk/a/slurm.html /etc/slurm-llnl/slurm.conf
ADD --chown=slurm ./slurm.conf /etc/slurm-llnl/slurm.conf

CMD	service munge start && \
	mkdir -p /slurmctld/log/ && mkdir -p /slurmctld/log/ &&  chown -R slurm /slurmctld/ && \
	slurmctld -D
