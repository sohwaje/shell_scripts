#!/bin/bash
count_chars() {
  wc -m < "$1" | tr -d ' '
}

count_chars $1
