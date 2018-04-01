FROM ubuntu:bionic
LABEL maintainer="Dooglz"

#package build step to stop doing this every docker build
RUN apt-get update

#ensure munge and slurm have same uids accross cluster
RUN  export MUNGEUID=63000 && export SLURMUID=64030  && \
		groupadd -g $MUNGEUID munge && \
		useradd  -M -u $MUNGEUID -g munge  -s /usr/sbin/nologin munge && \
		groupadd -g $SLURMUID slurm && \
		useradd  -M -u $SLURMUID -g slurm  -s /usr/sbin/nologin slurm

ADD --chown=slurm ./slurm.conf /etc/slurm-llnl/slurm.conf
#munge.key has to be identical across all nodes and controllers
ADD --chown=munge ./munge.key /etc/munge/munge.key

#Envar for LDAP
ENV dn='dc=example,dc=com'
ENV ldap_ip='ldap'

#Configure LDAP
RUN echo "ldap-auth-config ldap-auth-config/dbrootlogin boolean false" |debconf-set-selections && \
	echo "ldap-auth-config ldap-auth-config/pam_password select md5" |debconf-set-selections && \
	echo "ldap-auth-config ldap-auth-config/move-to-debconf boolean true" |debconf-set-selections && \
	echo "ldap-auth-config ldap-auth-config/ldapns/ldap-server string ldap://$ldap_ip" |debconf-set-selections && \
	echo "ldap-auth-config ldap-auth-config/ldapns/base-dn string $dn" |debconf-set-selections && \
	echo "ldap-auth-config ldap-auth-config/override boolean true" |debconf-set-selections && \
	echo "ldap-auth-config ldap-auth-config/ldapns/ldap_version select 3" |debconf-set-selections && \
	echo "ldap-auth-config ldap-auth-config/dblogin boolean false" | debconf-set-selections

#LDAP Packages
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    libpam-ldap nscd

#Final LDAP config
RUN auth-client-config -t nss -p lac_ldap && \
	echo "session required    pam_mkhomedir.so skel=/etc/skel umask=0022" >> /etc/pam.d/common-session && \
	/etc/init.d/nscd restart

#Install slurm worker, and some useful packages
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    slurmd  \
    git bzip2 nano wget openssh-server && \
    rm -rf /var/lib/apt/lists/*

EXPOSE 22
RUN mkdir /var/run/sshd

CMD  service munge start && service ssh start && \
     mkdir -p /slurmctld/log/ && mkdir -p /slurmctld/log/ &&  chown -R slurm /slurmctld/ && slurmd -D
