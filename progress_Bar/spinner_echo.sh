#!/bin/bash
clear
# spinner=( Ooooo oOooo ooOoo oooOo ooooO oooOo ooOoo oOooo);
spinner=( '|' '/' '-' '\' )

count(){
  echo -en "\t Copying files"
  spin &
  pid=$!

  for i in `seq 1 10`
  do
    sleep 1;
  done
  kill $pid
}

spin(){
  while [ 1 ]
  do
    for i in "${spinner[@]}"
    do
      echo -ne "\r[$i]";
      sleep 0.2;
    done
  done
}
count
