#!/bin/bash
# Convert string to lowercase:
################################################################################
#### example
# to_lowercase.sh ARG1
# -> arg1
# echo ARG1 ARG2 | to_lowercase
# -> return arg1 arg2
################################################################################
help()
{
  echo "Usage: $0 [ARG]...[ARG-N]"
}

to_lowercase() {
  local input="$([[ -p /dev/stdin ]] && cat - || echo "$@")"
  [[ -z "$input" ]] && return 1
  echo "$input" | tr '[:upper:]' '[:lower:]'
}

arg_check()
{
  if [[ $# -eq 0 ]];then
    help
    exit 0
  fi
}

arg_check $@ && to_lowercase $@
