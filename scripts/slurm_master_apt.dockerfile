FROM ubuntu:xenial
LABEL maintainer="Dooglz"

RUN apt update && apt upgrade -y
RUN apt install -y sudo nano curl wget htop tree lsof
RUN apt install -y slurm-wlm

ADD slurm.conf /etc/slurm-llnl/slurm.conf

EXPOSE 6817 6818



