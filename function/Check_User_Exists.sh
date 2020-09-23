#!/bin/bash

check_group()
{
  if getent group "$1" >/dev/null 2>&1; then
    echo -e "\e[1;33;40m [TOMCAT group already exist] \e[0m"
  else
    echo -e "\e[1;33;40m [Create TOMCAT group] \e[0m"
  fi
}

check_user()
{
  if getent passwd "$1" >/dev/null 2>&1; then
    echo -e "\e[1;33;40m [TOMCAT user already exist] \e[0m"
  else
    echo -e "\e[1;33;40m [Create TOMCAT user] \e[0m"
  fi
}
# usage : check_user $USER

check_group ${TOMCAT_USER}
check_user ${TOMCAT_USER}
