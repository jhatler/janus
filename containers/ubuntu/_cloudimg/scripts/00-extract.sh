#!/bin/bash

set -ex -o pipefail

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <image> <stem>"
    exit 1
fi

IMAGE=$1
STEM=$2

mkdir src
if [[ "$IMAGE" =~ -root\.tar\.gz$ ]] || [[ "$IMAGE" =~ -root\.tar\.xz$ ]]; then
    tar -xf "$IMAGE" -C src
    rm -f "$IMAGE"
    exit 0
elif [[ "$IMAGE" =~ \.tar\.gz$ ]]; then
    tar -xf "$IMAGE" --wildcards "*.img"
    rm -f "$IMAGE"
fi

mv ./*.img "$STEM".orig
qemu-img convert -O raw "$STEM".orig "$STEM".img

losetup -frP "$STEM".img
sync
sleep 5

mkdir mnt
mount -o ro "$(blkid | grep -E 'loop.*:.*cloudimg-rootfs' | cut -f1 -d:)" mnt

rsync -aAHX mnt/ src/

umount mnt
losetup -d "$(losetup -l | grep "$STEM".img | awk '{print $1}')"
rm -rf mnt
