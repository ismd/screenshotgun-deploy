#!/usr/bin/env bash
if [[ -z "${VERSION}" ]]; then
  echo "No VERSION variable"
  exit 1
fi

docker run --privileged --rm -v /proc:/proc -e VERSION=$VERSION -v $(pwd)/keys:/keys:ro ismd/screenshotgun-launchpad
