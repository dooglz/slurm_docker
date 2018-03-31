FROM ubuntu:bionic
LABEL maintainer="Dooglz"

#package build step to stop doing this every docker build
RUN apt-get update

RUN  export MUNGEUID=63000 && export SLURMUID=64030  && \
		groupadd -g $MUNGEUID munge && \
		useradd  -M -u $MUNGEUID -g munge  -s /usr/sbin/nologin munge && \
		groupadd -g $SLURMUID slurm && \
		useradd  -M -u $SLURMUID -g slurm  -s /usr/sbin/nologin slurm

# Default configuration: can be overridden at the docker command line
ENV LDAP_ROOTPASS toor
ENV LDAP_ORGANISATION Acme Widgets Inc.
ENV LDAP_DOMAIN example.com

RUN echo "slapd slapd/root_password password ${LDAP_ROOTPASS}" |debconf-set-selections && \
	echo "slapd slapd/root_password_again password ${LDAP_ROOTPASS}" |debconf-set-selections && \
    	echo "slapd slapd/internal/adminpw password p" |debconf-set-selections && \
    	echo "slapd slapd/internal/generated_adminpw password p" |debconf-set-selections && \
    	echo "slapd slapd/password2 password p" |debconf-set-selections && \
    	echo "slapd slapd/password1 password p" |debconf-set-selections && \
    	echo "slapd slapd/domain string ${LDAP_DOMAIN}" |debconf-set-selections && \
    	echo "slapd shared/organization string ${LDAP_ORGANISATION}" |debconf-set-selections && \
    	echo "slapd slapd/backend string HDB" |debconf-set-selections && \
	echo "slapd slapd/purge_database boolean false" |debconf-set-selections && \
	echo "slapd slapd/move_old_database boolean true" |debconf-set-selections && \ 
	echo "slapd slapd/allow_ldap_v2 boolean false" |debconf-set-selections && \
    	echo "slapd slapd/no_configuration boolean false" |debconf-set-selections && \	
	DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
	slurm-wlm  \
    	slapd ldap-utils \
        apache2 ldap-account-manager \
    	git bzip2 nano wget && \
    	rm -rf /var/lib/apt/lists/*

EXPOSE 389
EXPOSE 80

#RUN	sed -i '$ d' /etc/phpldapadmin/config.php && \
#	echo "\$config->custom->appearance['hide_template_warning'] = true;" >> /etc/phpldapadmin/config.php && \
#	echo "?>" >> /etc/phpldapadmin/config.php

#ADD --chown=slurm http://games.soc.napier.ac.uk/a/slurm.html /etc/slurm-llnl/slurm.conf
ADD 	--chown=slurm ./slurm.conf /etc/slurm-llnl/slurm.conf
ADD 	--chown=openldap ./ldap.ldif /ldap.ldif
ADD	--chown=www-data ./lam.conf /usr/share/ldap-account-manager/config/lam.conf

#RUN 	rm -fr /var/lib/ldap/* && 
RUN slapadd -v -c -l ldap.ldif || true

CMD	service munge start && \
	service apache2 start && \
	service slapd start && \
	mkdir -p /slurmctld/log/ && mkdir -p /slurmctld/log/ &&  chown -R slurm /slurmctld/ && \
	slurmctld -D
