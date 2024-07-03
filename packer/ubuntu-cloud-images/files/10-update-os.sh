#!/bin/bash
# shellcheck disable=SC2207

set -ex -o pipefail

function _stash_initctl() {
    if [ "$VERSION_MAJOR" -lt 14 ] && [ "$VERSION_MAJOR" -gt 10 ]; then
        dpkg-divert --local --rename --add /sbin/initctl
        ln -s /bin/true /sbin/initctl
    fi
}

function _unstash_initctl() {
    if [ "$VERSION_MAJOR" -lt 14 ] && [ "$VERSION_MAJOR" -gt 10 ]; then
        rm -f /sbin/initctl
        dpkg-divert --local --rename --remove /sbin/initctl
    fi
}

# jscpd:ignore-start
function _apt_get {
    apt-get --assume-yes --no-install-recommends --option=Dpkg::Options::=--force-confold "$@"
}

function _apt_autoremove {
    echo "Running apt-get autoremove" >&2
    _apt_get autoremove --purge
}

function _dpkg_list {
    dpkg -l | grep '^ii' | awk '{print $2}' | cut -f1 -d:
}

function _dpkg {
    if [ "$VERSION_MAJOR" -le 20 ] && [ "$VERSION" != "20.10" ]; then
        dpkg --force-remove-essential "$@"
    else
        dpkg --force-remove-protected --force-remove-essential "$@"
    fi
}

function _dpkg_remove {
    echo "Dpkg Removing:" "$@" >&2
    _dpkg -r "$@"
}

function _dpkg_purge {
    echo "Dpkg Purging:" "$@" >&2
    _dpkg -P "$@"
}

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

function _uninstall_boot {
    local _pkgs _bootloaders _kernels _removals

    _bootloaders=(
        efibootmgr
        grub2.*
        grub-.*
        os-prober
        shim-signed
    )
    _kernels=(
        linux{,-image,-headers,-tools,-modules-extra}{,"-[0-9.-]+"}{,-virtual,-generic,-kvm,-ec2,-aws,-xen}
        linux{,-restricted,-ubuntu}-modules{,"-[0-9.-]+"}{,-virtual,-generic,-kvm,-ec2,-aws,-xen}
        linux{,-virtual,-generic,-kvm,-ec2,-aws,-xen}-headers-"[0-9.-]+"
        linux-firmware
    )

    _removals=()
    _pkgs=($(_dpkg_list))

    if [[ " ${_pkgs[*]} " =~ [[:space:]]grub-legacy-ec2[[:space:]] ]]; then
        # grub-legacy-ec2 has a bug in purge, so we need to remove it first
        if [ ! -e /usr/sbin/grub-set-default.real ]; then
            touch /usr/sbin/grub-set-default
            if ! dpkg-divert --quiet --rename \
                --package grub-legacy-ec2 \
                --divert /usr/sbin/grub-set-default.real \
                --add /usr/sbin/grub-set-default; then

                touch /usr/sbin/grub-set-default.real

            fi
        fi
        _dpkg_remove grub-legacy-ec2

        if [ ! -e /usr/sbin/grub-set-default.real ]; then
            touch /usr/sbin/grub-set-default
            if ! dpkg-divert --quiet --rename \
                --package grub-legacy-ec2 \
                --divert /usr/sbin/grub-set-default.real \
                --add /usr/sbin/grub-set-default; then

                touch /usr/sbin/grub-set-default.real

            fi
        fi

        # This will fail on ubuntu 10.x, but that's fine
        if [ "$VERSION_MAJOR" -eq 10 ]; then
            _dpkg_purge grub-legacy-ec2 || true
        else
            _dpkg_purge grub-legacy-ec2
        fi

        if [ -e /usr/sbin/grub-set-default.real ]; then
            if ! dpkg-divert --quiet --rename --remove /usr/sbin/grub-set-default; then
                rm /usr/sbin/grub-set-default.real
            fi
        fi
        if [ -e /usr/sbin/grub-set-default ]; then
            rm /usr/sbin/grub-set-default
        fi

        _pkgs=($(_dpkg_list))
    fi

    for _regex in "${_kernels[@]}" "${_bootloaders[@]}"; do
        if [[ " ${_pkgs[*]} " =~ [[:space:]]${_regex}[[:space:]] ]]; then
            _removals+=($(echo "${_pkgs[@]}" | tr ' ' '\n' | grep -E "^${_regex}$"))
        fi
    done

    _removals=($(echo "${_removals[@]}" | sort -u))

    if [ ${#_removals[@]} -ne 0 ]; then
        _dpkg_purge "${_removals[@]}"
        # _apt_get purge "${_removals[@]}"
        _apt_autoremove --purge
    fi

    find /boot -maxdepth 1 -mindepth 1 -not -path /boot/efi -print0 | xargs -0 rm -rf
    for D in /usr/src /lib/modules /boot/efi /var/lib/initramfs-tools; do
        if [ -d "$D" ]; then
            find "$D" -maxdepth 1 -mindepth 1 -print0 | xargs -0 rm -rf
        fi
    done

    rm -f /usr/sbin/grub-set-default*
}
# jscpd:ignore-end

function _install_kernel() {
    local _install_pkgs

    _install_pkgs=(cloud-init linux-base linux-firmware)
    if apt-cache show linux-modules-extra-aws >&/dev/null; then
        _install_pkgs+=(linux-aws linux-image-aws linux-headers-aws linux-modules-extra-aws)
    elif apt-cache show linux-aws >&/dev/null; then
        _install_pkgs+=(linux-aws linux-image-aws linux-headers-aws)
    elif apt-cache show linux-ec2 >&/dev/null; then
        _install_pkgs+=(linux-ec2 linux-image-ec2 linux-headers-ec2)
    elif apt-cache show linux "linux-generic-hwe-${VERSION}" >&/dev/null; then
        _install_pkgs+=(
            "linux-generic-hwe-${VERSION}"
            "linux-image-generic-hwe-${VERSION}"
            "linux-headers-generic-hwe-${VERSION}"
        )

        if apt-cache show "linux-modules-extra-${VERSION}-generic" >&/dev/null; then
            _install_pkgs+=("linux-image-extra-${VERSION}-generic")
        fi
    elif apt-cache show linux-generic >&/dev/null; then
        _install_pkgs+=(linux-generic linux-image-generic linux-headers-generic)
    fi

    _apt_get install "${_install_pkgs[@]}"
}

export DEBIAN_FRONTEND=noninteractive
export LANG=C.UTF-8
export LC_ALL=C

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

VERSION="$VERSION_MAJOR.$VERSION_MINOR"

_stash_initctl

_apt_update

_uninstall_boot
_apt_get dist-upgrade
_install_kernel

_apt_autoremove
