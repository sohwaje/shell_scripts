#!/bin/bash
SRC="/src"
REDISVER="redis-6.2.6"
PREFIX="/src/redis"

# 소스 다운로드 디렉토리
if [[ ! -d ${SRC} ]];then
    mkdir -p ${SRC}
fi

wget https://download.redis.io/releases/redis-6.2.6.tar.gz -P ${SRC}

cd ${SRC}
tar xvfz ${REDISVER}.tar.gz

cd ${REDISVER}/src

# 설치 디렉토리가 있으면 백업
if [[ -d ${PREFIX} ]];then
    mv ${PREFIX} ${PREFIX}-$(date +%Y%m%d%H%M)
fi

perl -p -i -e 's#PREFIX\?=/usr/local#PREFIX\?=/src/redis#g' Makefile

make && make install

if [[ $? -eq 0 ]];then
    make install
        if [[ $? -eq 0 ]];then
            echo "Redis install complete"
        fi
else
        echo "configure failed"
fi

if [[ -d ${PREFIX} ]];then
        mkdir ${PREFIX}/conf
        wget https://raw.githubusercontent.com/sohwaje/shell_scripts/master/install/redis/redis.conf -P ${PREFIX}/conf
        wget https://raw.githubusercontent.com/sohwaje/shell_scripts/master/install/redis/redisd -P ${PREFIX}/bin
        wget https://raw.githubusercontent.com/sohwaje/shell_scripts/master/install/redis/sentineld -P ${PREFIX}/bin
        chmod +x ${PREFIX}/bin/redisd
        chmod +x ${PREFIX}/bin/sentineld
else
        echo "redis install failed"
        exit -1
fi

mkdir -p /log/redis
wget https://raw.githubusercontent.com/sohwaje/shell_scripts/master/install/redis/redis.logrotate -O /etc/logrotate.d/redis
echo "${PREFIX}/bin/redisd start|stop"
