#!/bin/bash
set -Eeuo pipefail

: "${project:=adeo}"

# wget -qO ".jq-template.awk" 'https://github.com/docker-library/bashbrew/raw/9f6a35772ac863a0241f147c820354e4008edf38/scripts/jq-template.awk'

[ -f versions.json ] # run "versions.sh" first

jqt='.jq-template.awk'

if [ "$#" -eq 0 ]; then

  versions="$(jq -r 'keys | map(@sh) | join(" ")' versions.json)"

  eval "set -- $versions"

fi

root="$PWD"

for version; do

  export version

  variants="$(jq -r '.[env.version].variants | map(@sh) | join(" ")' "$root/versions.json")"

  eval "variants=( $variants )"

  for variant in "${variants[@]}"; do

    export variant

    cd "$root/image/$version/$variant"

    echo "build $project/ops-debian/$version:$variant ..."

    docker build . -t "$project/ops-debian/$version:$variant" >/dev/null

  done

done
