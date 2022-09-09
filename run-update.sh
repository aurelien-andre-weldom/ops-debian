#!/bin/bash
set -Eeuo pipefail

# wget -qO ".jq-template.awk" 'https://github.com/docker-library/bashbrew/raw/9f6a35772ac863a0241f147c820354e4008edf38/scripts/jq-template.awk'

[ -f versions.json ] # run "versions.sh" first

jqt='.jq-template.awk'

if [ "$#" -eq 0 ]; then

  versions="$(jq -r 'keys | map(@sh) | join(" ")' versions.json)"

  eval "set -- $versions"

fi

generated_warning() {
	cat <<-EOH
#
# OPS LINUX
#
# PLEASE DO NOT EDIT IT DIRECTLY.
#
# @see https://github.com/aurelien-andre-weldom/ops-debian
#
	EOH
}

rm -rf "image"

for version; do

  export version

  variants="$(jq -r '.[env.version].variants | map(@sh) | join(" ")' versions.json)"

  eval "variants=( $variants )"

  for variant in "${variants[@]}"; do

    export variant

    from="debian:$variant-slim"

    export from

    mkdir -p "image/$version/$variant"

    echo "processing ops-debian/debian:$version-$variant ..."

    {
      generated_warning

      gawk -f "$jqt" 'dockerfile.template'

    } > "image/$version/$variant/Dockerfile"

    mkdir -p "image/$version/$variant/system"

    cp -a system/* "image/$version/$variant/system"

  done

done
