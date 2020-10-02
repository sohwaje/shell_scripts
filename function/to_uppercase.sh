#!/bin/bash
# Convert string to uppercase
################################################################################
#### example
# to_uppercase.sh arg1
# -> ARG1
# echo arg1 arg2 | to_uppercase
# -> return ARG1 ARG2
################################################################################
help()
{
  echo "Usage: $0 [arg]...[arg]...n"
}

to_uppercase() {
  local input="$([[ -p /dev/stdin ]] && cat - || echo "$@")"
  [[ -z "$input" ]] && return 1
  echo "$input" | tr '[:lower:]' '[:upper:]'
}

arg_check()
{
  if [[ $# -eq 0 ]];then
    help
    exit 0
  fi
}

arg_check $@ && to_uppercase $@
