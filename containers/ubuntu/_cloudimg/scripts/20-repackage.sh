#!/bin/bash

set -ex -o pipefail

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <stem>"
    exit 1
fi

STEM=$1

tar -cf "$STEM.tar" \
    --xattrs-exclude=security.capability \
    --numeric-owner -pS \
    --exclude='dev/*' \
    --exclude='boot/*' \
    --exclude='var/run/klogd/*' \
    --exclude='etc/kernel/postrm.d/zz-update-grub' \
    --exclude='etc/cloud' \
    --exclude='/etc/ssh/sshd_config.d' \
    -C src .
