#!/bin/bash
set -e

counter=1

while [ $counter -le 3 ]; do

  exit=0

  while IFS= read -r health; do

    if [ -f "/usr/bin/$health" ]; then

      exit=$(bash "$health" "$@")

      if [ "$exit" != "0" ]; then

        break

      fi

    fi

  done < <(grep -v '^ *#' < '/docker-health.list')

  counter=$((counter+1))

  if [ "$exit" != "0" ]; then

    sleep 0.2

  fi

done

exit "$exit"