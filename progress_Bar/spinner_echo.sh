#!/bin/bash
clear
spinner=( Ooooo oOooo ooOoo oooOo ooooO oooOo ooOoo oOooo);
# spinner=( '|' '/' '-' '\' )

count(){
  echo -n "Copying files"
  spin &
  pid=$!

  for i in `seq 1 10`
  do
    sleep 1;
  done

  kill $pid
  echo ""
}

spin()
{
  pid=$!
  local delay=0.2
  while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
    for i in "${spinner[@]}"
    do
      echo -ne "\r$i";
      sleep $delay
    done;
  done
}

count
