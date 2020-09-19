#!/bin/sh
url()
{
    if [ ! -z "$1" ]; then
        curl -Is "$1" | grep -w "200\|301\|302" >/dev/null 2>&1
        [ "$?" -eq 0 ] && echo "ok" || echo "fail"
    else
        echo "No Arguments..exiting"
    fi
}

#usage 1
url "http://www.google.com"

#usage 2 : loop
declare -a url_list # url_list를 배열로 지정한다.
url_list=( "http://www.google.com"
"https://www.daum.net"
"http://www.naver.com" )

for i in ${url_list[@]}
do
  # url $URL >/dev/null 2>&1
  if [[ $(url $i) == "ok" ]]; then
    echo "$i is alive!!!!"    # if first url is alive, break loop
    break
    #continue
  else
    echo "Cannot find $i"
  fi
done
