#!/bin/bash
export SXHKD_FIFO=/tmp/sxhkd-fifo
wait
[ -e "$SXHKD_FIFO" ] && rm -rf "$SXHKD_FIFO"
wait
mkfifo "$SXHKD_FIFO"
wait
/usr/bin/sxhkd -s "$SXHKD_FIFO" & /home/mikl/programs/sxhkd_notify "$SXHKD_FIFO" &
exit 0
