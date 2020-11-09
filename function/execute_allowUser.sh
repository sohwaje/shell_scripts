#!/bin/bash
#/************************************/
#/* 허가된 사용자만 스크립트 실행하기 */
#/************************************/

allow_exec_user_check()
{
  local script_user="sigongweb"
  if [ $(id -nu) = "$script_user" ];then
     return 0
  else
     echo "[ERROR] cannot execute $0. permission denied"
     exit 1
  fi
}

allow_exec_user_check
