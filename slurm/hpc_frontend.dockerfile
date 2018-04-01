FROM ubuntu:bionic
LABEL maintainer="Dooglz"

#package build step to stop doing this every docker build
RUN apt-get update

ENV dn='dc=example,dc=com'
ENV ldap_ip='ldap'

RUN echo "ldap-auth-config ldap-auth-config/dbrootlogin boolean false" |debconf-set-selections && \
echo "ldap-auth-config ldap-auth-config/pam_password select md5" |debconf-set-selections && \
echo "ldap-auth-config ldap-auth-config/move-to-debconf boolean true" |debconf-set-selections && \
echo "ldap-auth-config ldap-auth-config/ldapns/ldap-server string ldap://$ldap_ip" |debconf-set-selections && \
echo "ldap-auth-config ldap-auth-config/ldapns/base-dn string $dn" |debconf-set-selections && \
echo "ldap-auth-config ldap-auth-config/override boolean true" |debconf-set-selections && \
echo "ldap-auth-config ldap-auth-config/ldapns/ldap_version select 3" |debconf-set-selections && \
echo "ldap-auth-config ldap-auth-config/dblogin boolean false" |debconf-set-selections && \
DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    	libpam-ldap nscd \
    	slurm-client \
    	openssh-server \
    	git bzip2 nano wget && \
    	rm -rf /var/lib/apt/lists/*

ADD --chown=slurm ./slurm.conf /etc/slurm-llnl/slurm.conf
ADD --chown=munge ./munge.key /etc/munge/munge.key


RUN auth-client-config -t nss -p lac_ldap && \
	echo "session required    pam_mkhomedir.so skel=/etc/skel umask=0022" >> /etc/pam.d/common-session && \
	/etc/init.d/nscd restart

EXPOSE 22

RUN mkdir /var/run/sshd

CMD service munge start && /usr/sbin/sshd -D
