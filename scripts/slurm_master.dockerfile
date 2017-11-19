FROM ubuntu:xenial
LABEL maintainer="Dooglz"

RUN apt update && apt upgrade -y && \
 apt install -y git gcc make ruby ruby-dev libpam0g-dev libmariadb-client-lgpl-dev libmysqlclient-dev && \
 gem install fpm && \
 git clone https://github.com/mknoxnv/ubuntu-slurm.git && \
 apt install -y libmunge-dev libmunge2 munge && \
 apt install -y mariadb-server




