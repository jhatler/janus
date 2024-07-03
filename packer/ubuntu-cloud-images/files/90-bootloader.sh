#!/bin/bash

set -ex -o pipefail

# jscpd:ignore-start
function _apt_update() {
    local RETRIES
    RETRIES=5
    until apt-get update; do
        RETRIES=$((RETRIES - 1))
        if [ $RETRIES -eq 0 ]; then
            exit 1
        fi
        sleep 5
    done
}
# jscpd:ignore-end

function _apt_get {
    apt-get --assume-yes --no-install-recommends --option=Dpkg::Options::=--force-confold "$@"
}

function _install_grub() {
    local _partuuid _grub_partuuid _grub_cmdline _grub_hidden

    case "$INSTALL_MODE" in
        x86_64-efi)
            _apt_get install --reinstall --fix-broken grub-efi-amd64 efibootmgr initramfs-tools
            _apt_get remove --purge os-prober

            grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=ubuntu --recheck --no-floppy
            ;;
        arm64-efi)
            _apt_get install --reinstall --fix-broken grub-efi-arm64 efibootmgr initramfs-tools
            _apt_get remove --purge os-prober
            grub-install --target=arm64-efi --efi-directory=/boot/efi --bootloader-id=ubuntu --recheck --no-floppy
            ;;
        i386-pc)
            _apt_get install --reinstall --fix-broken grub-pc initramfs-tools
            _apt_get remove --purge os-prober
            if [ "$VERSION_MAJOR" -gt 12 ]; then
                grub-install --target=i386-pc --recheck --no-floppy "$INSTALL_DEV"
            else
                grub-install --recheck --no-floppy "$INSTALL_DEV"
            fi
            ;;
        *)
            echo "Unknown INSTALL_MODE: $INSTALL_MODE"
            exit 1
            ;;
    esac

    apt-get autoremove --assume-yes --purge

    if [ "$INSTALL_MODE" = "i386-pc" ]; then
        _partuuid=$(blkid -s PARTUUID -o value "$INSTALL_DEV"p1)
    else
        _partuuid=$(blkid -s PARTUUID -o value "$INSTALL_DEV"p2)
    fi

    _grub_partuuid="GRUB_FORCE_PARTUUID=$_partuuid"
    _grub_cmdline='GRUB_CMDLINE_LINUX_DEFAULT="console=ttyS0 nvme_core.io_timeout=4294967295"'
    _grub_hidden='GRUB_HIDDEN_TIMEOUT=0.1'

    if [ -d /etc/default/grub.d ]; then
        rm -f /etc/default/grub.d/*-force-partuuid.cfg /etc/default/grub.d/*-cloudimg-settings.cfg
        echo "$_grub_partuuid" >/etc/default/grub.d/40-force-partuuid.cfg
        {
            echo "$_grub_cmdline"
            echo "$_grub_hidden"
        } >/etc/default/grub.d/50-cloudimg-settings.cfg
    else
        sed -i "/^GRUB_CMDLINE_LINUX_DEFAULT=.*/d" /etc/default/grub
        {
            echo "$_grub_cmdline"
            echo "$_grub_partuuid"
            echo "$_grub_hidden"
        } >/etc/default/grub
    fi
}

if [ $# -ne 2 ]; then
    echo "Usage: $0 INSTALL_MODE INSTALL_DEV"
    exit 1
fi

INSTALL_MODE=$1
INSTALL_DEV=$2

# jscpd:ignore-start
if [ -f /etc/os-release ]; then
    # shellcheck disable=SC1091
    . /etc/os-release
    VERSION_MAJOR="$(echo "$VERSION_ID" | cut -f1 -d.)"
    VERSION_MINOR="$(echo "$VERSION_ID" | cut -f2 -d.)"
elif [ -f /etc/lsb-release ]; then
    # shellcheck disable=SC1091
    . /etc/lsb-release
    VERSION_MAJOR="$(echo "$DISTRIB_RELEASE" | cut -f1 -d.)"
    VERSION_MINOR="$(echo "$DISTRIB_RELEASE" | cut -f2 -d.)"
else
    echo "Unable to determine OS version"
    exit 1
fi

# shellcheck disable=SC2034
VERSION="$VERSION_MAJOR.$VERSION_MINOR"
# jscpd:ignore-end

_apt_update
_install_grub

echo nvme >>/etc/initramfs-tools/modules
echo nvme_core >>/etc/initramfs-tools/modules

update-initramfs -u -k all

update-grub
