FROM ubuntu:20.04 as gvm11builder

ENV TZ=Europe/Berlin
ENV DEBIAN_FRONTEND=noninteractive

# install apt-get packages needed to build gvm, get and build gvm libraries, ospd, ospd-openvas scanner, gvmd, greenbone web frontend and python-gvm
RUN apt-get update \
&& apt-get full-upgrade -y \
&& apt-get install \
curl \
gnupg -y \
&& curl --silent --show-error https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
&& echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
&& curl --silent --show-error https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - \
&& echo "deb https://deb.nodesource.com/node_8.x stretch main" | tee /etc/apt/sources.list.d/nodesource.list \
&& apt-get update \
&& apt-get install \
nodejs \
yarn \
bison \
build-essential \
cmake \
doxygen \
gnutls-bin \
libgcrypt20-dev \
libglib2.0-dev \
libgnutls28-dev \
libgpgme11-dev \
libhiredis-dev \
libical-dev \
libksba-dev \
libldap-dev \
libmicrohttpd-dev \
libsnmp-dev \
libpcap-dev \
libssl-dev \
libssh-dev \
libxml2-dev \
libxslt1-dev \
nmap \
pkg-config \
postgresql-server-dev-12 \
python3-pip \
python3 \
redis-server \
rsync \
texlive-latex-base \
uuid-dev \
wget \
xmltoman \
xsltproc \
postgresql \
postgresql-contrib \
postgresql-server-dev-all \
uuid-dev \
-y \
&& apt-get autoremove -y \
&& curl -L https://github.com/greenbone/gvm-libs/archive/v11.0.0.tar.gz | tar xvz \
&& mkdir gvm-libs-11.0.0/build \
&& cd gvm-libs-11.0.0/build \
&& cmake .. \
&& make \
&& make install \
&& cd \
&& curl -L https://github.com/greenbone/openvas-scanner/archive/v7.0.0.tar.gz | tar xvz \
&& mkdir openvas-7.0.0/build \
&& cd openvas-7.0.0/build \
# changed cmake to workaround fixed deprecation, will be removed in not jet released openvas version
# added -DCMAKE_BUILD_TYPE=RELEASE to cmake
&& cmake .. -DCMAKE_BUILD_TYPE=RELEASE \
&& make \
&& make install \
&& cd \
&& curl -L https://github.com/greenbone/gvmd/archive/v9.0.0.tar.gz | tar xvz \
&& mkdir gvmd-9.0.0/build \
&& cd gvmd-9.0.0/build \
&& cmake .. \
&& make \
&& make install \
&& cd \
&& curl -L https://github.com/greenbone/gsa/archive/v9.0.0.tar.gz | tar xvz \
&& mkdir gsa-9.0.0/build \
&& cd gsa-9.0.0/build \
&& cmake .. \
&& make \
&& make install \
&& cd \
&& curl -L https://github.com/greenbone/python-gvm/archive/v1.4.0.tar.gz | tar xvz \
&& cd python-gvm-1.4.0 \
&& pip3 install . \
&& cd \
&& curl -L https://github.com/greenbone/gvm-tools/archive/v2.1.0.tar.gz | tar xvz \
&& cd gvm-tools-2.1.0 \
&& pip3 install . \
&& ldconfig \
&& apt-get remove build-essential -y \
&& apt-get autoremove -y \
&& rm -rf /var/lib/apt-get/lists/* \
&& cd / \
&& mkdir -p /root/.config \
&& mkdir -p /scripts \
&& pip3 install ospd ospd-openvas \
&& useradd -s /bin/bash -d /home/gvmd gvmd \
&& mkdir -p /home/gvmd

# copy files to get a docker image ready to be used as a container
# you will need to set a gvmd admin user once your container is running on your host
COPY config/redis.conf /etc/redis/redis.conf
COPY scripts/start.sh scripts/init.sh scripts/psql_init.sh scripts/sync_job.sh /scripts/
COPY config/ospd.conf /root/.config/
COPY psql_init.sql /
RUN echo "db_address = /tmp/redis.sock" > /usr/local/etc/openvas/openvas.conf \
&& chmod 0770 -R /scripts \
&& chown :gvmd -R /scripts \
&& chown gvmd /usr/local/var/run/ \
&& chown gvmd /usr/local/sbin/gvmd \
&& touch /usr/local/var/log/gvm/gvmd.log \
&& chown gvmd /usr/local/var/log/gvm/gvmd.log \
&& chown gvmd:gvmd /home/gvmd/ \
&& chown -R gvmd /usr/local/var/run \
&& chown -R gvmd /usr/local/var/lib/ \
&& chown -R gvmd /usr/local/var/lib/gvm/gvmd/ \
&& bash ./scripts/psql_init.sh

EXPOSE 443 1234 9390
ENTRYPOINT ["./scripts/start.sh"]
