#!/bin/sh
# For zabbix 3.4
echo '[zabbix]
name=Zabbix Official Repository - $basearch
baseurl=http://repo.zabbix.com/zabbix/3.4/rhel/6/$basearch/
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-ZABBIX-A14FE591

[zabbix-deprecated]
name=Zabbix Official Repository deprecated - $basearch
baseurl=http://repo.zabbix.com/zabbix/3.4/rhel/6/$basearch/deprecated
enabled=0
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-ZABBIX-A14FE591

[zabbix-non-supported]
name=Zabbix Official Repository non-supported - $basearch
baseurl=http://repo.zabbix.com/non-supported/rhel/6/$basearch/
enabled=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-ZABBIX
gpgcheck=1' > /etc/yum.repos.d/zabbix.repo
yum repolist
yum install -y zabbix-agent --nogpgcheck
