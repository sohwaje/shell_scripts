#!/bin/bash
# apache 2.4 install

SRC="/src"
MPM="worker"
APACHEVER="httpd-2.4.46"
PREFIX="/src/apache"

# 소스 다운로드 디렉토리
if [[ ! -d ${SRC} ]];then
    mkdir -p ${SRC}
fi

wget http://archive.apache.org/dist/httpd/httpd-2.4.47.tar.bz2 -P ${SRC}

cd ${SRC}
tar jvxf ${APACHEVER}.tar.bz2

cd ${APACHEVER}

# 설치 디렉토리가 있으면 백업
if [[ -d ${PREFIX} ]];then
    mv ${PREFIX} ${PREFIX}-$(date +%Y%m%d%H%M)
fi

# 패키지 설치
yum -y install zlib-devel pcre-devel openssl-devel apr-devel apr-util-devel

./configure \
    --prefix=${PREFIX} \
    --with-mpm=${MPM} \
    --with-pcre \
    --enable-expires \
    --enable-deflate \
    --enable-headers \
    --enable-rewrite \
    --enable-proxy \
    --enable-ssl \
    --enable-so

if [[ $? -eq 0 ]];then
    make && make install
    if [[ $? -eq 0 ]];then
        echo "Apache Install complete!"
    fi
else
    echo "Configure failed!"
fi

# Apache conf file download

if [[ -d ${PREFIX} ]];then
    mv ${PREFIX}/conf/httpd.conf ${PREFIX}/conf/httpd.conf.org
    mv ${PREFIX}/conf/extra/httpd-ssl.conf ${PREFIX}/conf/extra/httpd-ssl.conf.org
    wget https://raw.githubusercontent.com/sohwaje/shell_scripts/master/install/Apache/httpd.conf  ${PREFIX}/conf
    wget https://raw.githubusercontent.com/sohwaje/shell_scripts/master/install/Apache/httpd-ssl.conf -P ${PREFIX}/conf/extra/httpd-ssl.conf
    mkdir -p /log/apache
    rm -rf ${PREFIX}/man
    rm -rf ${PREFIX}/manual
    rm -rf ${PREFIX}/cgi-bin
    rm -rf ${PREFIX}/icons
    chown -R daemon.daemon ${PREFIX}/conf
    chmod 600 -R ${PREFIX}/conf
else
    echo "Apache install failed"
    exit -1
fi

echo "You have to apache config setting"
