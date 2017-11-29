FROM centos:latest
MAINTAINER hhf

### SUPPORTING FILES
COPY src /usr/local/src

### ARG
ARG CACTI_VERSION=1.1.27 
ARG SPINE_VERSION=1.1.27
ARG RRDTOOL_VERSION=1.7.0
ARG CACTI_HOME=/usr/local/cacti
ARG SPINE_HOME=/usr/local/spine
ARG RRDTOOL_HOME=/usr/local/rrdtool
ARG TIMEZONE="Asia/Shanghai"

### ENV
ENV ENV TZ=${TIMEZONE} \
    DB_NAME=cacti \
    DB_USER=cactiuser \
    DB_PASS=cactiuser \
    DB_HOST=localhost \
    DB_PORT=3306 \
    RDB_NAME=cacti \
    RDB_USER=cactiuser \
    RDB_PASS=cactiuser \
    RDB_HOST=localhost \
    RDB_PORT=3306 \
    DB_ROOT_PASS=cacti \
    INITIALIZE_DB=0

### COMMON
RUN rpm --rebuilddb && yum clean all && \
    yum -y update && \
    yum -y install epel-release gcc gcc-c++ glibc glibc-common gd gd-devel make automake autoconf redhat-lsb fakesystemd systemd openssh-clients \
    wget curl zip unzip gzip vim lrzsz ntp tcpdump man nmap telnet mlocate expect parallel screen dmidecode dos2unix nc traceroute net-tools bind-utils

### CACTI
RUN yum -y install php php-devel php-ldap php-cli php-mysql php-common php-mbstring php-snmp php-gd php-pear php-pdo php-xml \
    httpd mysql cronie net-snmp net-snmp-devel net-snmp-utils net-snmp-libs openssl openldap mod_ssl bison \

### SPINE
RUN yum -y install help2man libtool m4 libmysqlclient libmysqlclient-devel openssl-devel mariadb-devel

### RRDTOOL
RUN yum -y install perl perl-devel perl-CPAN cairo cairo-devel libxml2 libxml2-devel pango pango-devel \
    libpng libpng-devel freetype freetype-devel libart_lgpl libart_lgpl-devel pixman pixman-devel \
    pkgconfig pkgconfig-devel fontconfig fontconfig-devel zlib zlib-devel glib2 glib2-devel 

### 
RUN tar -zxf /usr/local/src/cacti-${CACTI_VERSION}.tar.gz -C /usr/local/src/ && \
    mv /usr/local/src/cacti-${CACTI_VERSION} $CACTI_HOME

RUN tar -zxf /usr/local/src/cacti-spine-${SPINE_VERSION}.tar.gz -C /usr/local/src/ && \
    cd /usr/local/src/cacti-spine-${SPINE_VERSION} && \
    ./configure --prefix=$SPINE_HOME && \
    make && \
    make install && \
    chown root:root $SPINE_HOME/bin/spine && \
    chmod +s $SPINE_HOME/bin/spine

RUN tar -zxf /usr/local/src/rrdtool-${RRDTOOL_VERSION}.tar.gz -C /usr/local/src/ && \
    cd /usr/local/src/rrdtool-${RRDTOOL_VERSION} && \
    ./configure --prefix=$RRDTOOL_HOME && \
    make && \
    make install

RUN chown root.root $SPINE_HOME/bin/spine && chmod +s $SPINE_HOME/bin/spine

### CRON
COPY conf/crontab /etc/crontab
# Fix cron issues - https://github.com/CentOS/CentOS-Dockerfiles/issues/31
RUN sed -i '/session required pam_loginuid.so/d' /etc/pam.d/crond

### SERVICE CONFIGS
COPY conf/cacti.conf /etc/httpd/conf.d
COPY conf/config.php $CACTI_HOME/include
COPY conf/spine.conf $SPINE_HOME/etc

### SETTINGS/EXTRAS
COPY templates /templates
COPY plugins $CACTI_HOME/plugins
COPY settings /settings

RUN rm -rf /usr/local/src/*
RUN cp -Rp ${CACTI_HOME} ${CACTI_HOME}.init

VOLUME /usr/local/cacti

### Start
COPY start.sh /start.sh
RUN chmod +x /start.sh
CMD ["/start.sh"]

EXPOSE 80 443
