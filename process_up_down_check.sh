#!/bin/sh
proc_names=("instance01" "socket=/tmp/mysql.sock")
date_str=$(date '+%Y/%m/%d %H:%M:%S')
webhook=""

function slack_message(){
    # $1 : message
    # $2 : true=good, false=danger

    COLOR="danger"
    icon_emoji=":scream:"
    if $2 ; then
        COLOR="good"
	icon_emoji=":smile:"
    fi
    curl -s -d 'payload={"attachments":[{"color":"'"$COLOR"'","pretext":"<!channel> *lab*","text":"*HOST* : '"$HOSTNAME"' \n*MESSAGE* : '"$1"' '"$icon_emoji"'"}]}' $webhook > /dev/null 2>&1
}

# PID 찾기
get_process()
{
  local value=$(ps aux | grep $1 | grep -v grep | awk '{print $2}')
  cat /proc/$value/cmdline | grep -ao $1 |head -1 2>/dev/null # standard out error
}

# 1번
if [[ -f /var/tmp/one.txt ]];then
  echo ""
else
  bash -c "cat << EOF > /var/tmp/one.txt
false
EOF"
fi

# 2번
if [[ -f /var/tmp/two.txt ]];then
  echo ""
else
  bash -c "cat << EOF > /var/tmp/two.txt
false
EOF"
fi

# check if exsist process
if [[ $(get_process ${proc_names[0]}) = ${proc_names[0]} ]] && [[ $(cat "/var/tmp/one.txt") == "false" ]]
then
  sed -i 's/^false$/true/' /var/tmp/one.txt
  echo "$date_str : ${proc_names[0]} UP"
  slack_message "process up"
elif [[ $(get_process ${proc_names[0]}) != ${proc_names[0]} ]] && [[ $(cat "/var/tmp/one.txt") == "true" ]]
then
  sed -i 's/^true$/false/' /var/tmp/one.txt
  echo "$date_str : ${proc_names[0]} Down"
  slack_message "process down" false
fi
