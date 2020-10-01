#!/bin/bash
## After Locate the PID by the specified name kill the PID.
## for example : application name
program_name=$1

help()
{
  echo "Usage:$0 [program_name]"    # if Not equal, print
}

# find program's pid name("grep -v $0" is itself script)
pid_check()
{
  ps -ef | grep $program_name | grep -v grep | grep -v $0 | awk '{print $2}' | head -1
}

# exists pid in /proc
check_pid()
{
  for i in $* ; do
    [ -d "/proc/$i" ] && return 0
  done
  return 1
}

# kill pid with echo messages
kill_pid()
{
  pid=$(pid_check)
  if check_pid "$pid"; then
    echo "Kill Process $pid"
    sudo kill -9 $pid
  else
    return 1
  fi
}

# first execute function in this script
main()
{
  if [[ "$#" -ne 1 ]]   # Not equal
  then
    help
  else
    kill_pid
  fi
}

# gO
main $program_name
