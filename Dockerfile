FROM centos:7

ENV TS=2016_10_16 \
    TERM=xterm

# install gpg keys for epel and ius
COPY /container-files/keys/IUS-COMMUNITY-GPG-KEY /etc/pki/rpm-gpg/IUS-COMMUNITY-GPG-KEY
COPY /container-files/keys/RPM-GPG-KEY-EPEL-7    /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7

RUN echo '--- switch to local cache' \
 && echo 'proxy=http://cache.service.consul:3128' >> /etc/yum.conf \
 && echo -e "[main]\nenabled=0" > /etc/yum/pluginconf.d/fastestmirror.conf \
 && rm -rf /etc/yum.repos.d/*
COPY /container-files/yum.repo    /etc/yum.repos.d/yum.repo

RUN echo '--- Yum update' \
 && yum -y update \
 && echo '--- Yum packages' \
 && for pkg in wget unzip supervisor; do yum -y install $pkg; done \
 && echo '--- dumb-init' \
 && wget -qO /usr/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.0/dumb-init_1.2.0_amd64 \
 && chmod +x /usr/bin/dumb-init \
 && echo '--- Consul' \
 && wget -q https://releases.hashicorp.com/consul/0.6.4/consul_0.6.4_linux_amd64.zip \
 && unzip consul_0.6.4_linux_amd64.zip \
 && rm -r consul_0.6.4_linux_amd64.zip \
 && mv consul /usr/bin/consul \
 && echo '--- Base dirs' \
 && mkdir -p /config/{supervisor,init} \
 && echo '--- Cleanup' \
 && yum clean all \
 && rm -rf /var/cache/yum \

COPY /container-files/watcher.sh      /usr/bin/watcher.sh
COPY /container-files/watcher.ini     /config/supervisor/watcher.ini
COPY /container-files/supervisor.ini  /config/supervisor.ini
COPY /container-files/entry.sh        /entry.sh

CMD [ "/entry.sh" ]
