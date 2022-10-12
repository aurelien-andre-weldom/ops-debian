#!/bin/bash
set -e

counter=1

while [ $counter -le 3 ]; do

  exit=0

  while IFS= read -r script; do

    if [ -f "/usr/bin/$script" ]; then

      exit=$(bash "$script" "$@")

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