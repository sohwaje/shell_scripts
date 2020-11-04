#!/bin/bash
# example 1
if [[ conditino1 ]]
then
  if [[ condition2 ]]
  then
    do-something  # "conditino1"과 "condition2"가 모두 참일 경우에만
  fi
fi

# example 2
if [[ conditino1 ]] && [[ condition2 ]]
then
  do-something
fi
