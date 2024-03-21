#!/bin/bash

cd "$(dirname "$0")"

if [ -n "$1" ]; then
    # This path doesn't work:
    if [ ! -f "$1" ]; then
        echo "ERROR: usage: $0 [viewer.jnlp]" > /dev/stderr
        exit 1
    fi
    eval "$(xmllint --xpath '//argument/text()' "$1")"
    bfn="$(basename "$1")"
    if [[ "${bfn}" =~ viewer.jnlp ]]; then
        rm "$1"
    fi
else
    user=root
    read -s -p "Enter iDRAC password: " passwd
fi

docker container rm domistyle-idrac6
docker container stop domistyle-idrac6
docker run -d \
  -p 5800:5800 \
  -p 5900:5900 \
  -e IDRAC_HOST=10.1.10.143 \
  -e IDRAC_USER="${user}" \
  -e IDRAC_PASSWORD="${passwd}" \
  --name domistyle-idrac6 \
  domistyle-idrac6
sleep 2
vncviewer localhost:0
docker container stop domistyle-idrac6
docker container rm domistyle-idrac6
