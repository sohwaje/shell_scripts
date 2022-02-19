#!/bin/bash
SRC="/src"
NGINXVER="nginx-1.20.2"
PREFIX="/src/nginx"

# 소스 다운로드 디렉토리
if [[ ! -d ${SRC} ]];then
    mkdir -p ${SRC}
fi

wget http://nginx.org/download/nginx-1.20.2.tar.gz -P ${SRC}

cd ${SRC}
tar xvfz ${NGINXVER}.tar.gz

cd ${NGINXVER}

# 설치 디렉토리가 있으면 백업
if [[ -d ${PREFIX} ]];then
    mv ${PREFIX} ${PREFIX}-$(date +%Y%m%d%H%M)
fi

# 패키지 설치
yum -y groupinstall 'Development Tools'
yum -y install openssl-devel
yum -y install pcre-devel libaio-devel zlib-devel

./configure \
    --prefix=${PREFIX} \
    --pid-path=/var/run/nginx.pid \
    --with-file-aio \
    --with-threads \
    --with-http_ssl_module \
    --with-http_v2_module \
    --with-http_gzip_static_module \
    --with-http_stub_status_module \
    --without-mail_pop3_module \
    --without-mail_imap_module \
    --without-mail_smtp_module \
    --error-log-path=/log/nginx/error.log \
    --http-log-path=/log/nginx/access.log \
    --http-client-body-temp-path=${PREFIX}/temp/client_body \
    --http-proxy-temp-path=${PREFIX}/temp/proxy \
    --http-fastcgi-temp-path=${PREFIX}/temp/fastcgi \
    --http-uwsgi-temp-path=${PREFIX}/temp/uwsgi \
    --http-scgi-temp-path=${PREFIX}/temp/scgi

if [[ $? -eq 0 ]];then
    make && make install
    if [[ $? -eq 0 ]];then
        echo "NGINX Install complete!"
    fi
else
    echo "Configure failed!"
fi

# nginx conf file download
if [[ -d ${PREFIX} ]];then
    mkdir -p ${PREFIX}/temp
    # nginx.conf 설정 파일
    rm -f ${PREFIX}/conf/nginx.conf
    wget https://raw.githubusercontent.com/sohwaje/shell_scripts/master/install/nginx/nginx.conf -P ${PREFIX}/conf
    mkdir ${PREFIX}/conf/conf.d
    mkdir ${PREFIX}/conf/ssl

    mkdir -p /log/nginx

    # nginx 시작 스크립트
    mkdir -p ${PREFIX}/bin
    wget https://raw.githubusercontent.com/sohwaje/shell_scripts/master/install/nginx/nginx.init.sh -O ${PREFIX}/bin/nginx/nginx
    chmod 755 ${PREFIX}/bin/nginx

    chown -R nobody:nobody ${PREFIX}/conf
    chmod 600 -R ${PREFIX}/conf

    # nginx 로그 로테이트 파일
    wget https://raw.githubusercontent.com/sohwaje/shell_scripts/master/install/nginx/nginx.logrotate -O /etc/logrotate.d/nginx
else
    echo "nginx install failed"
    exit -1
fi

echo "You have to nginx config setting"

# nginx 시작/중지
# ${PREFIX}/bin/nginx/nginx start
# ${PREFIX}/bin/nginx/nginx stop