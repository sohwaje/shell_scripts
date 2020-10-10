#!/bin/bash
BOOTUP=color
RES_COL=60
MOVE_TO_COL="echo -en \\033[${RES_COL}G"
SETCOLOR_SUCCESS="echo -en \\033[1;32m"
SETCOLOR_FAILURE="echo -en \\033[1;31m"
SETCOLOR_WARNING="echo -en \\033[1;33m"
SETCOLOR_NORMAL="echo -en \\033[0;39m"
  echo_failure() {
      [ "$BOOTUP" = "color" ] && $MOVE_TO_COL
      echo -n "["
      [ "$BOOTUP" = "color" ] && $SETCOLOR_FAILURE
      echo -n $"FAILED"
      [ "$BOOTUP" = "color" ] && $SETCOLOR_NORMAL
      echo -n "]"
      echo -ne "\r"
      return 1
  }

  echo_success() {
      [ "$BOOTUP" = "color" ] && $MOVE_TO_COL
      echo -n "["
      [ "$BOOTUP" = "color" ] && $SETCOLOR_SUCCESS
      echo -n $"  OK  "
      [ "$BOOTUP" = "color" ] && $SETCOLOR_NORMAL
      echo -n "]"
      echo -ne "\r"
      return 0
  }

  echo_passed() {
      [ "$BOOTUP" = "color" ] && $MOVE_TO_COL
      echo -n "["
      [ "$BOOTUP" = "color" ] && $SETCOLOR_WARNING
      echo -n $"PASSED"
      [ "$BOOTUP" = "color" ] && $SETCOLOR_NORMAL
      echo -n "]"
      echo -ne "\r"
      return 1
  }

  echo_warning() {
      [ "$BOOTUP" = "color" ] && $MOVE_TO_COL
      echo -n "["
      [ "$BOOTUP" = "color" ] && $SETCOLOR_WARNING
      echo -n $"WARNING"
      [ "$BOOTUP" = "color" ] && $SETCOLOR_NORMAL
      echo -n "]"
      echo -ne "\r"
      return 1
  }

echo_failure
#                              [FAILED]
echo_success
#                              [  OK  ]
echo_passed
#                              [PASSED]
echo_warning
#                              [WARNING]
