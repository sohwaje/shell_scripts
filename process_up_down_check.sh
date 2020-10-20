#!/bin/sh
## usage
## */1 * * * * sh /root/scripts/process_up_down_check.sh >> /home/azureuser/process_up_down_check.log
proc_names=("instance01" "mysqld") # monitoring object
date_str=$(date '+%Y/%m/%d %H:%M:%S')
false_true_check_dir="/var/tmp/"
webhook="https://Y o u r W e b H o o k URL"

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

# Capture the Monitoring object. To do precisely, It find pid as proc_names and proc_names as pid.
get_process()
{
  local value=$(ps aux | grep $1 | grep -v grep | awk '{print $2}'| head -1)
  cat /proc/$value/cmdline | grep -ao $1 |head -1 2>/dev/null
}

# create $proc_name.txt if not exsist $porc_name.txt. And write false(Default : false) in $proc_name.txt
create_proc_name()
{
  for proc_name in "${proc_names[@]}"
  do
    if [[ ! -f $false_true_check_dir/$proc_name.txt ]]
    then
      echo "false" > $false_true_check_dir/$proc_name.txt
    fi
  done
}

# check running process. If not running, change "false" to "true" and alert to slack
## $var.txt = $proc_name.txt
main()
{
  create_proc_name
  for var in "${proc_names[@]}"
  do
    if [[ "${proc_names[@]}" =~ $(get_process $var) ]]    # get_process 함수로 프로세스가 존재하는지 확인
    then
      if [[ $(get_process $var) = $var ]] && [[ $(cat "$false_true_check_dir/$var.txt") == "false" ]]
      then
        sed -i 's/^false$/true/' $false_true_check_dir/${var}.txt
        slack_message "$date_str : $var UP"
        # echo "$date_str : $var UP"  # test
      elif [[ $(get_process $var) != $var ]] && [[ $(cat "$false_true_check_dir/$var.txt") == "true" ]]
      then
        sed -i 's/^true$/false/' $false_true_check_dir/${var}.txt
        slack_message "$date_str : $var DOWN" false
        # echo "$date_str : $var DOWN" # test
      fi
    fi
  done
}

main
