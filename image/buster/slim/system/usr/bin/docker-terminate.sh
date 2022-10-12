#!/bin/bash
set -e

while IFS= read -r script; do

  if [ -f "/usr/bin/$script" ]; then

    bash "$script" "$@"

  fi

done < <(grep -v '^ *#' < '/docker-terminate.list')

exit 0
