#!/usr/bin/env bash
#
# Copyright 2019 (c) Cj-bc
# This software is released under MIT License
#
# @(#) version -


local fifo="$1"
local date time user line
while read date time user line; do
  user="${user//[():]/}";
  echo "$user";
  terminal-notifier -message "$line" -title "GITTER" -subtitle "$user";
done < $fifo

