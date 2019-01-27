#!/usr/bin/env bash
#
# Copyright 2019 (c) Cj-bc
# This software is released under MIT License
#
# @(#) version -
# _daemon(): pull new gitter post {{{2
# @param <string room_name>
# @return <string daemon_PID>
_daemon() {
  local room="$1"
  mkfifo "$gitter_notifier_fifo_name"
  gitter-cli s --room "$room" > $gitter_notifier_fifo_name &
  daemon_pid="$!"
}
# }}}
}
# }}}


main() {
  local fifo="$1"
  local date time user line
  while read date time user line; do
    user="${user//[():]/}";
    terminal-notifier -message "$line" -title "GITTER" -subtitle "$user";
  done < $fifo
}

main $@
