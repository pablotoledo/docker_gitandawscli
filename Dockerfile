FROM centos:centos7
MAINTAINER pablotoledo <jptgjuanpablo@gmail.com>

# If proxy is defined
ARG proxy
ENV HTTP_PROXY=$proxy
ENV HTTPS_PROXY=$proxy
RUN echo proxy=$HTTPS_PROXY >> /etc/yum.conf

#SSH with Basic Auth
RUN yum -y update; yum clean all
RUN yum -y install openssh-server passwd; yum clean all
ADD ./start.sh /start.sh
RUN mkdir /var/run/sshd

RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N '' 

RUN chmod 755 /start.sh
EXPOSE 22
RUN ./start.sh

#Install Python3.6

RUN yum -y install yum-utils
RUN yum -y groupinstall development
RUN yum -y install https://centos7.iuscommunity.org/ius-release.rpm
RUN yum -y install python36u
RUN yum -y install python36u-pip
RUN pip3.6 install --proxy $proxy -U pip
USER slave
RUN pip3.6 install --proxy $proxy awscli --upgrade --user

#Install Git
USER root
RUN yum -y install git

#Git config
USER slave
RUN git config --global credential.helper '!aws codecommit credential-helper $@'
RUN git config --global credential.UseHttpPath true
RUN git config --global http.proxy $proxy
RUN git config --global https.proxy $proxy
ENV PATH=$PATH:$HOME/.local/bin/

RUN sed -i "s|UsePAM yes|UsePAM no |g" /etc/ssh/sshd_config

USER root
ENTRYPOINT ["/usr/sbin/sshd", "-D"]



