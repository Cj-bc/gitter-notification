#!/usr/bin/env bash
#
# Copyright 2019 (c) Cj-bc
# This software is released under MIT License
#
# @(#) version -

gitter_notifier_fifo_name=".gitter_notifier_$(date +%Y%m%d%H%M).fifo"

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


# _cleanup: clean up after execution.called from trap {{{2
# @param <string daemon_pid>
function _cleanup()
{
  kill $1
  rm "$gitter_notifier_fifo_name"
  trap SIGINT
  trap SIGTERM
}
# }}}


main() {
  # TODO: check whether room is available
  _daemon "$1"
  trap "_cleanup $daemon_pid" SIGINT
  trap "_cleanup $daemon_pid" SIGTERM
  local date time user line
  while read date time user line; do
    user="${user//[():]/}";
    terminal-notifier -message "$line" -title "GITTER" -subtitle "$user";
  done < "$gitter_notifier_fifo_name"
}
case "$1" in
  "-h"|"help"|"--help") _help;;
  *) main $@;;
esac

