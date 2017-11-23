FROM ubuntu:xenial
LABEL maintainer="Dooglz"

RUN apt update && apt upgrade -y
RUN apt install -y sudo nano curl wget htop tree lsof iputils-ping
RUN apt install -y krb5-user libpam-krb5 libpam-ccreds auth-client-config

ADD krb5.conf /etc/krb5.conf


RUN apt install -y openssh-server
RUN mkdir /var/run/sshd
RUN echo 'root:root' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]



