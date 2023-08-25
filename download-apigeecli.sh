#!/bin/bash

set -e
export APIGEECLI_VERSION="v1.123.2-beta"

echo "*** Downloading apigeecli (version: ${APIGEECLI_VERSION})"
export APIGEECLI_DIR="apigeecli_${APIGEECLI_VERSION}_$(uname -s)_$(uname -m)"
curl -o apigeecli.zip -sfL "https://github.com/apigee/apigeecli/releases/download/${APIGEECLI_VERSION}/${APIGEECLI_DIR}.zip"

echo "*** Extracting apigeecli ***"
unzip -o -p ./apigeecli.zip "${APIGEECLI_DIR}/apigeecli" > ./apigeecli
rm -f ./apigeecli.zip
chmod a+x ./apigeecli
