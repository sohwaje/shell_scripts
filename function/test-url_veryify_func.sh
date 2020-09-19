#!/bin/sh
url()
{
    if [ ! -z "$1" ]; then
        curl -Is "$1" | grep -w "200\|301\|302" >/dev/null 2>&1
        [ "$?" -eq 0 ] && echo "ok" || echo "fail"
    else
        exit 9
    fi
}

spinner=( Ooooo oOooo ooOoo oooOo ooooO oooOo ooOoo oOooo);
spin(){
  local pid=$!
  # while [ 1 ]
  while [ "$(ps a | awk '{print $1}' | grep $pid)" ];
  do
    for i in "${spinner[@]}"
    do
      echo -ne "\e[1;35;40m\r[$i]\e[0m";
      sleep 0.2;
    done
  done
}

#usage 1
# url "http://www.google.com"

#usage 2 : loop
declare -a url_list # url_list를 배열로 지정한다.
url_list=( "http://ftp.kaist.ac.kr/mysql/Downloads/MySQL-5.7/mysql-5.7.30-linux-glibc2.12-x86_64.tar.gz"
"https://downloads.mysql.com/archives/get/p/23/file/mysql-5.7.30-linux-glibc2.12-x86_64.tar.gz"
"http://ftp.jaist.ac.jp/pub/mysql/Downloads/MySQL-5.7/mysql-5.7.30-linux-glibc2.12-x86_64.tar.gz" )

for i in ${url_list[@]}
do
  # url $URL >/dev/null 2>&1
  if [[ $(url $i) == "ok" ]]; then
    echo "$i Download"
    sudo wget -P /tmp/ "$i" -q & >& /dev/null
    echo -en "\t\e[1;36;40m    Downloading.....\e[0m"
    spin
    echo ""
    break
  else
    echo "Cannot find $i"
  fi
done
