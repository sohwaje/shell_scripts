#!/bin/bash
count_words() {
  wc -w < "$1" | tr -d ' '
}

count_words $1
