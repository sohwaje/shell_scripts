#!/bin/bash
set_variables_if_it_no_exists()
{
  if test -z "$basedir"                   # if null is True
  then
    basedir=/usr/local/mysql
    bindir=/usr/local/mysql/bin
    if test -z "$datadir"                 # also if null is True
    then
      datadir=/usr/local/mysql/data
    fi
    sbindir=/usr/local/mysql/bin
    libexecdir=/usr/local/mysql/bin
  else
    bindir="$basedir/bin"                 # if not null is True
    if test -z "$datadir"
    then
      datadir="$basedir/data"
    fi
    sbindir="$basedir/sbin"
    libexecdir="$basedir/libexec"
  fi
}
