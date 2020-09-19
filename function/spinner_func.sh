#!/bin/sh
# usage:
:<<'END'
start & # excute background
echo -n "\t\t     Installing......"
spin    # call spin function
echo ""
END

spinner=( Ooooo oOooo ooOoo oooOo ooooO oooOo ooOoo oOooo);
# spinner=( '|' '/' '-' '\' )
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
