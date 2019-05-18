#!/usr/bin/env bash
#[1] Nginx 컴파일 설치 환경 구성
# Nginx 설치전 아래 패키지 설치를 먼저 진행한다.
# yum install -y perl perl-devel perl-ExtUtils-Embed libxslt libxslt-devel libxml2 libxml2-devel gd gd-devel GeoIP GeoIP-devel libxslt-devel gd gd-devel google-perftools libgoogle-perftools-dev gperftools

NGINX_ROOT_PATH=/nginx
NGINX_LIBS_PATH=$NGINX_ROOT_PATH/libs

-f $NGINX_LIBS_PATH || mkdir -p $NGINX_LIBS_PATH

(cd $NGINX_LIBS_PATH &&
wget http://nginx.org/download/nginx-1.15.11.tar.gz
tar -xvf nginx-1.15.11.tar.gz &
wget http://zlib.net/zlib-1.2.11.tar.gz
tar -xvf zlib-1.2.11.tar.gz &
wget http://downloads.sourceforge.net/project/pcre/pcre/8.41/pcre-8.41.tar.gz
tar -xvf pcre-8.41.tar.gz &
wget http://www.openssl.org/source/openssl-1.0.2f.tar.gz
tar -xvf openssl-1.0.2f.tar.gz
)
