#!/bin/bash
set -e

files="
/etc/supervisor/supervisord.conf
"

for file in $files; do

  if [ -f "$file" ]; then

    for e in "${!SUPERVISOR_@}"; do

        sed -i -e 's!__'"$e"'__!'"$(printenv "$e")"'!g' "$file"

    done

  fi

done
