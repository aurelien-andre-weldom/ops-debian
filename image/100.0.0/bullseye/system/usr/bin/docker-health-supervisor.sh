#!/bin/bash
set -e

exit=0

if [ -f "/var/pid/supervisord.pid" ]; then

  exit=1

else

  programs=$(supervisorctl pid all)

  for pid in $programs; do

    if [ "$pid" = "0" ]; then

      exit=1

      break

    fi

  done

fi

echo $exit