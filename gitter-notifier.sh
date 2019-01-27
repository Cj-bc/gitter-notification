#!/usr/bin/env bash
#
# Copyright 2019 (c) Cj-bc
# This software is released under MIT License
#
# @(#) version -


main() {
  local fifo="$1"
  local date time user line
  while read date time user line; do
    user="${user//[():]/}";
    terminal-notifier -message "$line" -title "GITTER" -subtitle "$user";
  done < $fifo
}

main $@
