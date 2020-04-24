#!/bin/sh

#
# https://github.com/x70b1/polybar-scripts/tree/master/polybar-scripts/info-pingrtt
#
HOST=1.1.1.1

if ! ping=$(ping -n -c1 $HOST); then
  echo ""
else
  rtt=$(echo "$ping" | sed -rn 's/.*time=([0-9]{1,})\.?[0-9]{0,} ms.*/\1/p')
  echo "${rtt}ms"
fi
