#!/bin/bash
# introduce function example
main1()
{
  echo "function test 1"
}
main2()
{
  echo "function test 2"
}
main3()
{
  echo "function is $1"
  echo "$1 is function"
}
main4()
{
  echo "function is $1"
  echo "$2 is function"
  echo "$2 is function, but not person $1"
}

main1
# function test 1
main2
# function test 2
main3 TOM
# function is TOM
# TOM is function
main4 function Merry
# function is function
# Merry is function
# Merry is function
# Merry is function, but not person function
