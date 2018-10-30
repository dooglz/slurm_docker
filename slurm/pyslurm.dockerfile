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

#munge.key has to be identical across all nodes and controllers
ADD --chown=munge ./munge.key /etc/munge/munge.key

#Install slurm cli, and some useful packages
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    slurm-client libslurm-dev libslurmdb-dev python3 cython3 python3-pip python3-setuptools python3-dev gcc \
    git bzip2 nano wget && \
    rm -rf /var/lib/apt/lists/*

RUN GIT_SSL_NO_VERIFY=true git clone https://github.com/PySlurm/pyslurm.git && cd pyslurm && git checkout 3db8af9
RUN ln -sf /usr/include/slurm-wlm/ /usr/include/slurm && mkdir /usr/lib/slurm && ln -sf /usr/lib/x86_64-linux-gnu /usr/lib/slurm/lib
RUN cd /pyslurm && python3 setup.py build --slurm-inc=/usr/include/ --slurm-lib=/usr/lib/slurm && python3 setup.py install
RUN pip3 install flask
ADD --chown=slurm ./slurm.conf /etc/slurm-llnl/slurm.conf

EXPOSE 80

CMD service munge start && \
    export LC_ALL=C.UTF-8 && \
    export LANG=C.UTF-8 && \
    export FLASK_ENV=development && \
    FLASK_APP=/pyslurm_site/website.py flask run --port=80 --host=0.0.0.0
