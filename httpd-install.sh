#!/bin/sh
sudo yum install -y httpd
systemctl start httpd
systemctl enable httpd
