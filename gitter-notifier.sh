#!/usr/bin/env bash
#
# gitter-notifier -- pop up notification when you get new post in gitter
#
# Copyright 2019 (c) Cj-bc
# This software is released under MIT License
#
# @(#) version 0.1.0

gitter_notifier_fifo_name=".gitter_notifier_$(date +%Y%m%d%H%M).fifo"

# _help: echo help messages {{{2
function _help()
{
  local README="README.md"
  local usage_with_padding
  usage_with_padding="$(sed -n -e '/## usage/, /## .*/ p' -e '/## .*/d' "$README")"
  echo "$(echo "$usage_with_padding")"
}
# }}}

# _daemon(): pull new gitter post {{{2
# @param <string room_name>
# @return <string daemon_PID>
_daemon() {
  local room="$1"
  echo -n "Daemon: making fifo..."
  mkfifo "$gitter_notifier_fifo_name"
  echo " ok"
  echo -n "starting gitter-cli..."
  gitter-cli s --room "$room" > $gitter_notifier_fifo_name &
  daemon_pid="$!"
  echo " ok"
}
# }}}


# _cleanup: clean up after execution.called from trap {{{2
# @param <string daemon_pid>
function _cleanup()
{
  echo "Detect Quit code."
  echo -n "kill daemon..."
  kill $1
  echo " ok"
  echo -n "Remove fifo..."
  rm "$gitter_notifier_fifo_name"
  echo " ok"

  echo -n "Untrap..."
  trap SIGINT
  trap SIGTERM
  echo " ok"
  echo "Done."
}
# }}}


# main(): main loop to pop up notifications {{{2
main() {
  # TODO: check whether room is available
  echo -n "starting daemon..."
  _daemon "$1"
  echo "daemon PID: $daemon_pid"
  echo -n "setting traps..."
  trap "_cleanup $daemon_pid" SIGINT
  trap "_cleanup $daemon_pid" SIGTERM
  echo " ok"

  echo "Start main loop... go ahead"
  local date time user line
  while read date time user line; do
    user="${user//[():]/}";
    terminal-notifier -message "$line" -title "GITTER" -subtitle "$user";
  done < "$gitter_notifier_fifo_name"
}
# }}}

case "$1" in
  "-h"|"help"|"--help") _help;;
  *) main $@;;
esac

