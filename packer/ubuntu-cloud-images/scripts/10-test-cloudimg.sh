#!/bin/bash

set -ex -o pipefail

id
dpkg -l

RETRIES=5
until apt-get update; do
    RETRIES=$((RETRIES - 1))
    if [ $RETRIES -eq 0 ]; then
        exit 1
    fi
    sleep 5
done

apt-get dist-upgrade -y
