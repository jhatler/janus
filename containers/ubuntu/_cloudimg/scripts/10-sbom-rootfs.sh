#!/bin/bash

set -ex -o pipefail

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <stem>"
    exit 1
fi

STEM=$1

mkdir -p run
arch-chroot . /bin/bash -c 'dpkg -l' >"$GITHUB_WORKSPACE/$STEM.dpkg"
find . -printf '%Y %4U %4G %#5m %C@ %T@ %16s %P\t%l\n' >"$GITHUB_WORKSPACE/$STEM.files"
find . -type f -printf '%P\0' | xargs -0 sha256sum >"$GITHUB_WORKSPACE/$STEM.files.SHA256SUMS"
