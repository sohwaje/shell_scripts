#!/bin/sh
yum update -y
curl -s https://get.docker.com | sudo sh && systemctl start docker && systemctl enable docker

yum install -y nginx
systemctl start nginx
