#!/bin/sh
sudo yum update -y
sudo curl -s https://get.docker.com | sudo sh && systemctl start docker && systemctl enable docker
sudo yum install -y httpd
sudo sed -i 's/^Listen 80$/Listen 38080/' /etc/httpd/conf/httpd.conf
sudo echo "Test-Page" > /var/www/html/index.html
sudo systemctl start httpd
sudo systemctl enable httpd
