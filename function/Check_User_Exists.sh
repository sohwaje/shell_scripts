#!/bin/bash
check_group()
{
  if getent group "$1" >/dev/null 2>&1; then
    echo "group already exist"
  else
    echo "not exist group"
  fi
}

check_user()
{
  if getent passwd "$1" >/dev/null 2>&1; then
    echo "user already exist"
  else
    echo "not exist user"
  fi
}
# usage : check_user $USER

check_group ${TOMCAT_USER}
check_user ${TOMCAT_USER}
