#!/bin/sh

function make_dirc
{
  local dirc=$1
  local content=$2
  cd - >& /dev/null; cd $content; sudo mkdir ./$dirc
}

make_dirc b
