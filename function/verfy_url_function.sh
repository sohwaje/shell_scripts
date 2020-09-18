#!/bin/sh
url()
{
    if [ ! -z "$1" ]; then
        curl -Is "$1" | grep -w "200\|301" >/dev/null 2>&1
        [ "$?" -eq 0 ] && echo "0" || echo "1"
    fi
}

# url "http://www.example.com"

#usage
declare -a url_list # url_list를 배열로 지정한다.
url_list=( "http://ftp.kaist.ac.kr/mysql/Downloads/MySQL-5.7/mysql-5.7.32-linux-glibc2.12-x86_64.tar.gz"
"https://downloads.mysql.com/archives/get/p/23/file/mysql-5.7.30-linux-glibc2.12-x86_64.tar.gz"
"http://ftp.jaist.ac.jp/pub/mysql/Downloads/MySQL-5.7/mysql-5.7.30-linux-glibc2.12-x86_64.tar.gz" )

if [ $(url "${url_list[0]}") == "0" ]; then
  echo -en "\t\e[1;36;40m    Downloading.....\e[0m"
  echo "${url_list[0]}"
elif [ $(url "${url_list[1]}") == "0" ]; then
  echo -en "\t\e[1;36;40m    Downloading.....\e[0m"
  echo "${url_list[1]}"
elif [ $(url "${url_list[2]}") == "0" ]; then
  echo -en "\t\e[1;36;40m    Downloading.....\e[0m"
  echo "${url_list[2]}"
else
  echo  "failed"
fi
