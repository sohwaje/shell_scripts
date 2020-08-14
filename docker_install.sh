#!/bin/sh
#yum update -y
#curl -s https://get.docker.com | sudo sh && systemctl start docker && systemctl enable docker

sudo yum install -y nginx
sudo systemctl start nginx
