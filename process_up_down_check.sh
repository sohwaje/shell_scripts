#!/bin/sh
################################################################################
# Instead of using the process name to determine what to monitor, use the string
# included in the cmdline. This scripts uses both cmdline and pid.
# When the monitoring object is down, alert it to slack channel.
# You have to use a unigue string, because match the pid exactly.
## usage : once every minute. use a cron scheduler
## */1 * * * * sh /home/azureuser/process_up_down_check.sh
################################################################################
proc_names=("instance01" "socket=/tmp/mysql.sock")
date_str=$(date '+%Y/%m/%d %H:%M:%S')
webhook="Y o u r - S l a c k - W e b H o o K - U R L"
fals_true_check_dir="/var/tmp/"
# Alert to slack
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

# Capture to Monitoring objects
get_process()
{
  local value=$(ps aux | grep $1 | grep -v grep | awk '{print $2}')
  cat /proc/$value/cmdline | grep -ao $1 |head -1 2>/dev/null
}

# 1번
if [[ -f $fals_true_check_dir/one.txt ]];then
  return 0
else
  bash -c "cat << EOF > $fals_true_check_dir/one.txt
false
EOF"
fi

# 2번
if [[ -f $fals_true_check_dir/two.txt ]];then
  return 0
else
  bash -c "cat << EOF > $fals_true_check_dir/two.txt
false
EOF"
fi

# check if exsist process
if [[ $(get_process ${proc_names[0]}) = ${proc_names[0]} ]] && [[ $(cat "/var/tmp/one.txt") == "false" ]]
then
  sed -i 's/^false$/true/' /var/tmp/one.txt
  echo "$date_str : ${proc_names[0]} UP"
  slack_message "$date_str : ${proc_names[0]} up"
elif [[ $(get_process ${proc_names[0]}) != ${proc_names[0]} ]] && [[ $(cat "/var/tmp/one.txt") == "true" ]]
then
  sed -i 's/^true$/false/' /var/tmp/one.txt
  echo "$date_str : ${proc_names[0]} Down"
  slack_message "$date_str : ${proc_names[0]} down" false # ":scream:"
fi
