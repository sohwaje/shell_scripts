### nginx 설치 시 확인해야 할 부분
- install_nginx.sh 변수 확인(설치 위치, nginx 버전)
```
SRC="/src"
NGINXVER="nginx-1.20.2"
PREFIX="/src/nginx"
```
- nginx.conf 변수(ssl/tls 인증서 경로, 인증서 이름)
```
ssl_certificate /src/nginx/conf/ssl/ssl.crt;
ssl_certificate_key /src/nginx/conf/ssl/ssl.key;
```
- nginx.logrotate의 nginx 데몬 경로 확인
```
[ ! -f /var/run/nginx.pid ] || /src/nginx/sbin/nginx -s reload
```
- nginx.init.sh(nginx 데몬 경로, nginx 설정 파일 위치 확인)
```
nginx="/src/nginx/sbin/nginx"
NGINX_CONF_FILE="/src/nginx/conf/nginx.conf"
```
### nginx install
```
wget https://raw.githubusercontent.com/sohwaje/shell_scripts/master/install/nginx/install_nginx.sh
chmod +x install_nginx.sh
./install_nginx.sh
```