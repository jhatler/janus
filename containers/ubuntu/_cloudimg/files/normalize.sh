#!/bin/bash
# shellcheck disable=SC2207

set -ex -o pipefail

export DEBIAN_FRONTEND=noninteractive
export SUDO_FORCE_REMOVE=yes

function _setup_locale {
    echo "Setting up locale" >&2
    echo "LANG=C.UTF-8" >/etc/default/locale
    rm -f /etc/localtime /etc/timezone
}

function _use_old_apt_host {
    echo "Setting up old apt host" >&2
    sed -i "s|://ports.ubuntu.com|://old-releases.ports.ubuntu.com|" /etc/apt/sources.list
    sed -i "s|://archive.ubuntu.com|://old-releases.ubuntu.com|" /etc/apt/sources.list
    sed -i "s|://security.ubuntu.com|://old-releases.ubuntu.com|" /etc/apt/sources.list
}

function _update_apt_sources {
    local _release_type _retries
    if [ "$((VERSION_MAJOR % 2))" -eq 0 ] && [ "$VERSION_MINOR" -eq 4 ]; then
        _release_type=lts
    else
        _release_type=interim
    fi

    if [ "$VERSION_MAJOR" -lt 14 ] || { [ "$VERSION_MAJOR" -lt 23 ] && [ "$_release_type" = "interim" ]; }; then
        _use_old_apt_host
    fi

    echo "Running apt-get update" >&2
    _retries=5
    until apt-get update; do
        _retries=$((_retries - 1))
        if [ $_retries -eq 0 ]; then
            exit 1
        fi
        sleep 5
    done
}

function _stash_dns {
    if [ -e /run/resolvconf ]; then
        echo "Stashing /run/resolvconf" >&2
        mv /run/resolvconf /run/resolvconf.orig
        cp -a /run/resolvconf.orig /run/resolvconf
    fi

    echo "Stashing /etc/resolv.conf" >&2
    if mv /etc/resolv.conf /etc/resolv.conf.orig >&/dev/null; then
        # resolv.conf is not bind mounted
        cp -a /etc/resolv.conf.orig /etc/resolv.conf
    else
        # resolv.conf is bind mounted
        cp -a /etc/resolv.conf /etc/resolv.conf.orig
    fi

    if [ -L /etc/resolv.conf ]; then
        cat /etc/resolv.conf >/etc/resolv.conf.cat
    fi
}

function _unstash_dns {
    if [ -e /run/resolvconf.orig ]; then
        echo "Unstashing /run/resolvconf" >&2
        rm -rf /run/resolvconf
        cp -a /run/resolvconf.orig /run/resolvconf
    fi

    if [ -f /etc/resolv.conf.cat ] && [ -f /etc/resolv.conf ]; then
        # resolv.conf was a symlink, and still resolves (or is a file), restore it
        cat /etc/resolv.conf.cat >/etc/resolv.conf
    elif [ -f /etc/resolv.conf.cat ] && [ -L /etc/resolv.conf ]; then
        # resolv.conf was a symlink and no longer resolves, replace the target
        mkdir -p "$(dirname "$(readlink -f /etc/resolv.conf)")"
        cat /etc/resolv.conf.cat >"$(readlink -f /etc/resolv.conf)"
    elif [ -f /etc/resolv.conf.cat ] && [ ! -e /etc/resolv.conf ]; then
        # resolv.conf was a symlink, and no longer exists, restore it as a file
        cat /etc/resolv.conf.cat >/etc/resolv.conf
    else
        # resolv.conf was a file, restore it
        cat /etc/resolv.conf.orig >/etc/resolv.conf
    fi
}

function _clean_dns {
    if [ -e /run/resolvconf.orig ]; then
        echo "Cleaning /run/resolvconf stash" >&2
        rm -rf /run/resolvconf
        mv /run/resolvconf.orig /run/resolvconf
    fi

    # /etc/resolv.conf is a bind mount, so we need to be careful

    if [ -f /etc/resolv.conf.cat ] && [ -L /etc/resolv.conf ]; then
        # resolv.conf was a symlink and still is

        if [ "$(readlink /etc/resolv.conf)" != "$(readlink -f /etc/resolv.conf.orig)" ]; then
            # resolv.conf was a symlink, still is, but the target changed

            # -f will only fail if the file exists but cannot be removed
            if ! rm -f "$(readlink -f /etc/resolv.conf.orig)" >&/dev/null; then
                # target is a bind mount, convert resolv.conf to a file
                rm /etc/resolv.conf /etc/resolv.conf.orig
                mv /etc/resolv.conf.cat /etc/resolv.conf
                return
            fi

            ln -sf "$(readlink -f /etc/resolv.conf)" /etc/resolv.conf.orig
        fi

        rm /etc/resolv.conf
    fi

    if [ -f /etc/resolv.conf.cat ] && [ ! -e /etc/resolv.conf ]; then
        mv /etc/resolv.conf.orig /etc/resolv.conf

        mkdir -p "$(dirname "$(readlink -f /etc/resolv.conf)")"
        if ! mv /etc/resolv.conf.cat "$(readlink -f /etc/resolv.conf)"; then
            # target is a bind mount
            cat /etc/resolv.conf.cat >"$(readlink -f /etc/resolv.conf)"
            rm /etc/resolv.conf.cat
        fi

        return
    fi

    # resolv.conf was a file, restore it
    if rm /etc/resolv.conf; then
        # resolv.conf is not a bind mount
        mv /etc/resolv.conf.orig /etc/resolv.conf
    else
        # resolv.conf is a bind mount
        cat /etc/resolv.conf.orig >/etc/resolv.conf
        rm /etc/resolv.conf.orig
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

    # jscpd:ignore-start
    for _regex in "${_kernels[@]}" "${_bootloaders[@]}"; do
        if [[ " ${_pkgs[*]} " =~ [[:space:]]${_regex}[[:space:]] ]]; then
            _removals+=($(echo "${_pkgs[@]}" | tr ' ' '\n' | grep -E "^${_regex}$"))
        fi
    done

    _removals=($(echo "${_removals[@]}" | sort -u))
    # jscpd:ignore-end

    if [ ${#_removals[@]} -ne 0 ]; then
        _dpkg_purge "${_removals[@]}"
        # _apt_get purge "${_removals[@]}"
        _apt_autoremove --purge
    fi

    for D in /usr/src /lib/modules /boot /var/lib/initramfs-tools; do
        if [ -d "$D" ]; then
            find "$D" -maxdepth 1 -mindepth 1 -print0 | xargs -0 rm -rf
        fi
    done

    rm -f /usr/sbin/grub-set-default*
}
# jscpd:ignore-end

function _uninstall_regex {
    local _pkgs _regex _removals

    if [ "$#" -ne 1 ]; then
        echo "Usage: $0 <regex>"
        exit 1
    fi

    _regex=$1
    _pkgs=($(_dpkg_list))

    if [[ ! " ${_pkgs[*]} " =~ [[:space:]]${_regex}[[:space:]] ]]; then
        return
    fi

    _removals=($(echo "${_pkgs[@]}" | tr ' ' '\n' | grep -E "^${_regex}$"))
    _removals=($(echo "${_removals[@]}" | sort -u))

    if [ ${#_removals[@]} -eq 0 ]; then
        return
    fi

    _dpkg_purge "${_removals[@]}"
}

function _uninstall_regex_list {
    local _list _pkgs _regex _removals
    if [ "$#" -ne 1 ]; then
        echo "Usage: $0 <file>"
        exit 1
    fi

    # jscpd:ignore-start
    _list=$1
    _pkgs=($(_dpkg_list))
    _removals=()

    # shellcheck disable=SC2013
    for _regex in $(cat "$_list"); do
        if [[ " ${_pkgs[*]} " =~ [[:space:]]${_regex}[[:space:]] ]]; then
            _removals+=($(echo "${_pkgs[@]}" | tr ' ' '\n' | grep -E "^${_regex}$"))
        fi
    done

    _removals=($(echo "${_removals[@]}" | sort -u))
    # jscpd:ignore-end

    if [ ${#_removals[@]} -eq 0 ]; then
        return
    fi

    _dpkg_purge "${_removals[@]}"
}

function _try_uninstall_regex_list {
    local _list _pkgs _regex _removals _skips
    if [ "$#" -ne 1 ]; then
        echo "Usage: $0 <file>"
        exit 1
    fi

    _list=$1
    _pkgs=($(_dpkg_list))
    _removals=()
    _skips=()

    # shellcheck disable=SC2013
    for _regex in $(cat "$_list"); do
        if [[ " ${_pkgs[*]} " =~ [[:space:]]${_regex}[[:space:]] ]]; then
            _removals+=($(echo "${_pkgs[@]}" | tr ' ' '\n' | grep -E "^${_regex}$"))
        fi
    done

    _removals=($(echo "${_removals[@]}" | sort -u))
    if [ ${#_removals[@]} -eq 0 ]; then
        return
    fi

    for _pkg in "${_removals[@]}"; do
        # check if new packages are going to be installed
        if _apt_get purge --simulate "$_pkg" 2>&1 | grep -q 'The following NEW packages will be installed:'; then
            _skips+=("$_pkg")
            continue
        fi

        # try to remove the package
        if ! _apt_get purge "$_pkg" 2>&1; then
            _skips+=("$_pkg")
        fi
    done

    if [ ${#_skips[@]} -ne 0 ]; then
        echo "Failed to remove: ${_skips[*]}" >&2
    fi
}

function _clean_system {
    echo "Cleaning up apt" >&2
    find /var/lib/apt/lists -type f -print0 | xargs -0 rm
    find /var/cache/apt -type f -print0 | xargs -0 rm
    rm -f /var/cache/debconf/*-old /var/lib/dpkg/*-old /boot/*

    echo "Cleaning logs" >&2
    rm -rf /var/log/journal/* /var/log/amazon/ssm/audits/* /var/log/apt/*
    find /var/log -type f -print0 | while read -r -d $'\0' _file; do
        cat /dev/null >"$_file"
    done

    echo "Cleaning tmp" >&2
    for D in /var/tmp /tmp; do
        find $D -mindepth 1 -maxdepth 1 -exec rm -rf {} \; || true
    done

    if ! _dpkg_list | grep -q '^systemd$'; then
        echo "Cleaning up systemd" >&2
        rm -rf /etc/systemd /lib/systemd /usr/lib/systemd /var/lib/systemd
    fi

    if ! _dpkg_list | grep -q '^apparmor$'; then
        echo "Cleaning up apparmor" >&2
        rm -rf /etc/apparmor.d /etc/apparmor /usr/lib/apparmor /var/lib/apparmor
    fi

    if ! _dpkg_list | grep -q '^udev$'; then
        echo "Cleaning up udev" >&2
        rm -rf /etc/udev /lib/udev /usr/lib/udev /var/lib/udev
    fi

    if ! _dpkg_list | grep -q '^locales$'; then
        echo "Cleaning up locales" >&2
        rm -rf /usr/lib/locale
    fi

    echo "Cleaning /etc" >&2
    for D in console-setup default/grub{,.d} lxc newt sgml ssh/sshd_config.d sudoers.d sysctl.d ufw; do
        rm -rf "/etc/${D:?}"
    done

    echo "Cleaning /lib" >&2
    for D in recovery-mode tmpfiles.d; do
        rm -rf "/lib/${D:?}"
    done

    echo "Cleaning /var/lib" >&2
    for D in command-not-found update-manager update-notifier; do
        rm -rf "/var/lib/${D:?}"
    done

    echo "Cleaning /usr/lib" >&2
    for D in {aarch64,i386,x86_64}-linux-gnu; do
        rm -rf "/usr/lib/${D:?}/gio/modules"
    done
}

function _dpkg_excludes {
    local _lines

    _lines+=("path-exclude=/usr/share/man/*")
    _lines+=("path-exclude=/usr/share/locale/*/LC_MESSAGES/*.mo")
    _lines+=("path-exclude=/usr/share/doc/*")
    _lines+=("path-include=/usr/share/doc/*/copyright")
    _lines+=("path-include=/usr/share/doc/*/changelog.*")

    printf '%s\n' "${_lines[@]}"
}

function _mimic_apt_excludes {
    echo "Mimicking apt excludes by cleaning docs" >&2
    rm -rf /usr/share/man/*
    rm -rf /usr/share/locale/*/LC_MESSAGES/*.mo
    rm -rf /usr/share/doc/*
    rm -rf /usr/share/doc/*/copyright
    rm -rf /usr/share/doc/*/changelog.*
}

function _setup_apt_excludes {
    echo "Setting up apt excludes" >&2

    # set up dpkg filters to skip installing docs on minimized system
    mkdir -p /etc/dpkg/dpkg.cfg.d
    _dpkg_excludes >/etc/dpkg/dpkg.cfg.d/excludes

    # Remove docs installed by bootstrap
    dpkg-query -f '${binary:Package}\n' -W | grep -vF makedev | xargs -L1 apt-get install \
        --option=Dpkg::Options::=--force-confold \
        --assume-yes \
        --no-install-recommends \
        --quiet \
        --reinstall
}

function _setup_diversion {
    echo "Setting up diversion for $1" >&2

    dpkg-divert --quiet --divert "$2" --rename --add "$1"
    if [ ! -e "$1" ]; then
        ln -s "$(which true)" "$1"
    fi
}

function _main {
    local _image_type
    if [ "$#" -ne 1 ]; then
        echo "Usage: $0 <type>"
        exit 1
    fi

    _image_type=$1

    _setup_locale
    _update_apt_sources

    # Cannot update makdev in unpriviledged container on 16.04
    if [ "$VERSION_MAJOR" -eq 16 ] && dpkg -l | awk '{print $2}' | cut -f1 -d: | grep -q '^makedev$'; then
        echo "Holding updates: makedev" >&2
        echo "makedev hold" | dpkg --set-selections
    fi

    [ "$VERSION_MAJOR" -lt 12 ] && _setup_diversion /usr/sbin/update-grub{,.REAL}
    [ "$_image_type" = "minimal" ] && _setup_diversion /usr/bin/man{,.REAL}
    [ -e /usr/sbin/invoke-rc.d ] && _setup_diversion /usr/sbin/invoke-rc.d{,.REAL}

    # removing systemd-resolved or resolvconf will break networking
    _stash_dns

    # Remove the meta packages first since they depend on so many other packages
    _uninstall_regex 'ubuntu-(cloud-minimal|minimal|server|standard|serverguide)'

    # Remove grub before removing other packages, it's fragile and slows down the process
    _uninstall_boot

    # Remove openssh-server before removing other packages, it's fragile too
    _uninstall_regex 'openssh-(server|sftp-server)'

    # autoremove here dramatically reduces the number of packages to remove in the next steps
    _apt_autoremove

    # systemd needs removed before other packages to avoid breaking post-remove scripts
    if [ "$VERSION" = "8.04" ]; then
        _uninstall_regex_list <(cat /setup/blocklist/{init/common,codename/hardy}.txt)
    elif [ "$VERSION" = "10.04" ]; then
        _uninstall_regex_list <(cat /setup/blocklist/{init/common,codename/lucid}.txt)
    elif [ "$VERSION" = "10.10" ]; then
        _uninstall_regex_list <(cat /setup/blocklist/{init/common,codename/maverick}.txt)
    elif [ "$VERSION" = "11.04" ]; then
        _uninstall_regex_list <(cat /setup/blocklist/{init/common,codename/natty}.txt)
    elif [ "$VERSION_MAJOR" -lt 14 ]; then
        _uninstall_regex_list <(cat /setup/blocklist/{init/common,init/legacy}.txt)
    elif [ "$VERSION_MAJOR" -lt 15 ]; then
        _uninstall_regex_list <(cat /setup/blocklist/{init/common,init/upstart}.txt)
    elif [ "$VERSION_MAJOR" -lt 17 ] && [ "$VERSION" != "16.10" ]; then
        _uninstall_regex_list <(cat /setup/blocklist/{init/common,init/systemd_legacy}.txt)
    else
        _uninstall_regex_list <(cat /setup/blocklist/{init/common,init/systemd_modern}.txt)
    fi

    # autoremove, then purge the rest
    _apt_autoremove
    _uninstall_regex_list /setup/blocklist/misc.txt
    _apt_autoremove

    # removing systemd-resolved or resolvconf will break networking, fix that
    _unstash_dns

    # try removing the rest of the blocklist, twice (just in case)
    _try_uninstall_regex_list /setup/blocklist/try.txt
    _try_uninstall_regex_list /setup/blocklist/try.txt

    # Exclude man pages and docs from being installed
    [ "$_image_type" = "minimal" ] && _setup_apt_excludes

    echo "Running apt-get upgrade" >&2
    _apt_get upgrade

    echo "Running apt-get dist-upgrade" >&2
    _apt_get dist-upgrade

    echo "Ensuring bash is installed" >&2
    _apt_get install bash

    _apt_autoremove

    # Remove any remaining man pages and docs if they were installed
    [ "$_image_type" = "minimal" ] && _mimic_apt_excludes

    _clean_dns
    _clean_system
}

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

VERSION="$VERSION_MAJOR.$VERSION_MINOR"
# jscpd:ignore-end

_main "$@"
