#!/bin/bash

while true
do
  slabtop -o | grep -i dentry
  sleep 2
done
