#!/usr/bin/env bash
if [[ -z "${VERSION}" ]]; then
  echo "No VERSION variable"
  exit 1
fi

AUR_VERSION=$(echo $VERSION | sed 's/-/_/g')
docker run -v $(pwd)/keys:/keys:ro -e VERSION=$VERSION -e AUR_VERSION=$AUR_VERSION --rm ismd/screenshotgun-aur
