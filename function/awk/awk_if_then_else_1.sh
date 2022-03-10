#!/bin/bash
:
'인수 $1을 daemon 변수에 넣고 마지막 필드($NF)가 변수 daemon과 일치할 때 마지막 필드와 함께 "is running"을 출력한다.'
var="/usr/sbin/nginx"

status()
{
  ps -ef | grep "$1" | grep -v $$ | awk -v daemon="$1" '{
  	if ($NF==daemon) { print $NF " is running" }
	else { print $NF " is not running" }}'
}

status $var