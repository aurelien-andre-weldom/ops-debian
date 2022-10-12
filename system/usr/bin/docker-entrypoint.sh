#!/bin/bash
set -e

if [ "$1" = 'supervisord' ]; then

  while IFS= read -r script; do

    if [ -f "/usr/bin/$script" ]; then

      bash "$script" "$@"

    fi

  done < <(grep -v '^ *#' < '/docker-entrypoint.list')

fi

exec "$@"