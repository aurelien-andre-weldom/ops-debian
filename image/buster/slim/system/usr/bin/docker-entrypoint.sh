#!/bin/bash
set -e

if [ "$1" = 'supervisord' ]; then

  while IFS= read -r entrypoint; do

    if [ -f "/usr/bin/$entrypoint" ]; then

      bash "$entrypoint" "$@"

    fi

  done < <(grep -v '^ *#' < '/docker-entrypoint.list')

fi

exec "$@"