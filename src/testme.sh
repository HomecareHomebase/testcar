#!/bin/bash

: "${TESTFILESDIR:?Please set the TESTFILESDIR environment variable}"

docker build . -t testcar
./prep-secrets.sh
docker run --rm -it \
 -e "pkpassphrase=correct horse battery staple" \
 --mount type=bind,source="$(pwd)"/target,target=/opt/ca,readonly \
 --mount type=bind,source=$TESTFILESDIR,target=/etc/testcar/tests/,readonly \
 --name tct testcar

