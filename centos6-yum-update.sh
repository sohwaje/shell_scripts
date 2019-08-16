#!/bin/sh
# centos6.x Add Repositories & update OS
yum -y install yum-plugin-fastestmirror \
yum-plugin-priorities epel-release \
centos-release-scl-rh centos-release-scl \
http://rpms.famillecollet.com/enterprise/remi-release-6.rpm

if [ $? -eq 0 ];then
    echo -e "\033[32m "yum repolist & yum update"\033[0m"
    yum repolist && yum update -y
else
    echo -e "\033[31m "update failed"\033[0m"
    exit 9
fi
echo "update ok!"
