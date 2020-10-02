#!/bin/bash
count_lines() {
  wc -l < "$1" | tr -d ' '
}

count_lines $1
