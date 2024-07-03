#!/bin/bash

set -ex -o pipefail

# jscpd:ignore-start
function _apt_update {
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

function _protect_chroot {
    # Ensure chroot does not detect the host's grub
    if [ -d /boot/efi ]; then
        find /boot/efi -mindepth 1 -maxdepth 1 -exec rm -rf {} \;
    fi
    mount | grep -E 'on /boot[^ ]* ' | cut -f3 -d' ' | xargs -I {} umount {}
    # shellcheck disable=SC2114
    rm -rf /boot

    # Ensure host snapd does not interfere with the chroot
    systemctl disable --now snapd.service snapd.socket
    systemctl mask snapd.service snapd.socket
}

function _mount_img {
    local DEV
    losetup -rP "$LOOPDEV" "$1"

    for DEV in "$LOOPDEV"*; do
        if file -s "$DEV" | grep -qiE 'ext[2-4] filesystem'; then
            sudo mount -o ro "$DEV" "$2"
            break
        fi
    done

    if ! mount | grep -q "$2"; then
        echo "No ext filesystem found!"
        exit 1
    fi
}

function _mount_fs {
    local DEV

    if [ "$VERSION_MAJOR" -lt 14 ]; then
        echo ext2
        return
    fi

    for DEV in "$LOOPDEV"*; do
        if file -s "$DEV" | grep -qiE 'ext[2-4] filesystem'; then
            file -s "$DEV" | grep -oP 'ext[2-4]'
            return
        fi
    done

    return 1
}

function _use_old_apt_host {
    sed -i "s|://ports.ubuntu.com|://old-releases.ports.ubuntu.com|" /mnt/chroot/etc/apt/sources.list
    sed -i "s|://archive.ubuntu.com|://old-releases.ubuntu.com|" /mnt/chroot/etc/apt/sources.list
    sed -i "s|://security.ubuntu.com|://old-releases.ubuntu.com|" /mnt/chroot/etc/apt/sources.list
}

function _setup_efi {
    local _fs

    _fs=$(_mount_fs)

    parted --script "$INSTALL_DEV" mklabel gpt
    parted --script "$INSTALL_DEV" mkpart primary fat32 1MiB 513MiB
    parted --script "$INSTALL_DEV" set 1 esp on
    parted --script "$INSTALL_DEV" mkpart primary "$_fs" 513MiB 100%

    partprobe "$INSTALL_DEV"
    sleep 5

    mkfs.fat -F32 -n EFI "${INSTALL_DEV}p1"
    "mkfs.$_fs" -L cloudimg-rootfs "${INSTALL_DEV}p2"

    mount "${INSTALL_DEV}p2" "$2"
    mkdir -p "$2/boot/efi"
    mount "${INSTALL_DEV}p1" "$2/boot/efi"

    rsync -aAHX "$1/" "$2/"

    cat /dev/null >"$2/etc/fstab"
    echo "LABEL=cloudimg-rootfs / $_fs defaults 0 0" >>"$2/etc/fstab"
    echo "LABEL=EFI /boot/efi vfat defaults 0 0" >>"$2/etc/fstab"
}

function _setup_legacy {
    local _fs

    _fs=$(_mount_fs)
    parted --script "$INSTALL_DEV" mklabel msdos
    parted --script "$INSTALL_DEV" mkpart primary "$_fs" 1MiB 100%

    partprobe "$INSTALL_DEV"
    sleep 5

    "mkfs.$_fs" -L cloudimg-rootfs "${INSTALL_DEV}p1"

    sync
    mount "${INSTALL_DEV}p1" "$2"

    rsync -aAHX "$1/" "$2/"

    cat /dev/null >"$2/etc/fstab"
    echo "LABEL=cloudimg-rootfs / $_fs defaults 0 0" >>"$2/etc/fstab"
}

##
## Entry
##
export DEBIAN_FRONTEND=noninteractive

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <boot-mode>"
    exit 1
fi

BOOT_MODE=$1

# Find the first available unmounted disk
for dev in /dev/nvme*n1; do
    if ! mount | grep -q "$dev"; then
        INSTALL_DEV=$dev
        break
    fi
done
if [ -z "$INSTALL_DEV" ]; then
    echo "No available disk found"
    exit 1
fi

# Find the first available loop device
LOOPDEV=$(sudo losetup -f)

# Provisioning dependencies
_apt_update
_apt_get install arch-install-scripts parted rsync

# Ensure the host does not interfere with the chroot
_protect_chroot

# Mount the cloud image and determine the architecture
mkdir /mnt/chroot /mnt/cloudimg
_mount_img /setup/cloud-image.img /mnt/cloudimg
case "$(file -L /mnt/cloudimg/bin/sh | cut -f2 -d, | cut -f2- -d' ')" in
    x86-64)
        INSTALL_ARCH=x86_64
        ;;
    *80386)
        INSTALL_ARCH=i386
        ;;
    *aarch64)
        INSTALL_ARCH=arm64
        ;;
    *)
        echo "Unknown architecture" >&2
        exit 1
        ;;
esac

# Determine the OS version info
if [ -f /mnt/cloudimg/etc/os-release ]; then
    # shellcheck disable=SC1091
    . /mnt/cloudimg/etc/os-release
    VERSION_MAJOR="$(echo "$VERSION_ID" | cut -f1 -d.)"
    VERSION_MINOR="$(echo "$VERSION_ID" | cut -f2 -d.)"
elif [ -f /mnt/cloudimg/etc/lsb-release ]; then
    # shellcheck disable=SC1091
    . /mnt/cloudimg/etc/lsb-release
    VERSION_MAJOR="$(echo "$DISTRIB_RELEASE" | cut -f1 -d.)"
    VERSION_MINOR="$(echo "$DISTRIB_RELEASE" | cut -f2 -d.)"
else
    echo "Unable to determine OS version"
    exit 1
fi

# shellcheck disable=SC2034
VERSION="$VERSION_MAJOR.$VERSION_MINOR"

if [ "$((VERSION_MAJOR % 2))" -eq 0 ] && [ "$VERSION_MINOR" -eq 4 ]; then
    RELEASE_TYPE=lts
else
    RELEASE_TYPE=interim
fi

# Determine the INSTALL_MODE and setup the chroot environment
if [ "$BOOT_MODE" = "uefi" ] && [ "$INSTALL_ARCH" = "arm64" ]; then
    INSTALL_MODE=arm64-efi
elif [ "$BOOT_MODE" = "uefi" ] && [ "$INSTALL_ARCH" = "x86_64" ]; then
    INSTALL_MODE=x86_64-efi
elif [ "$BOOT_MODE" = "legacy-bios" ]; then
    INSTALL_MODE=i386-pc
else
    echo "Unknown grub mode" >&2
    exit 1
fi

if [ "$INSTALL_MODE" = "x86_64-efi" ] || [ "$INSTALL_MODE" = "arm64-efi" ]; then
    _setup_efi /mnt/cloudimg /mnt/chroot
else
    _setup_legacy /mnt/cloudimg /mnt/chroot
fi

# Cleanup the loop device
umount /mnt/cloudimg
losetup -d "$LOOPDEV"

# Ensure the chroot is using the correct apt sources
if [ "$VERSION_MAJOR" -lt 14 ] || { [ "$VERSION_MAJOR" -lt 23 ] && [ "$RELEASE_TYPE" = "interim" ]; }; then
    _use_old_apt_host
fi

# The chroot resolve.conf may not be functional, so use the host's
mv /mnt/chroot/etc/resolv.conf /mnt/chroot/etc/resolv.conf.bak || true
cat /etc/resolv.conf >/mnt/chroot/etc/resolv.conf

# Copy the setup scripts into the chroot and prepare them to execute
mkdir -p /mnt/chroot/run /mnt/chroot/setup
rm /setup/files/cloud-config*.txt
mv /setup/files/* /mnt/chroot/setup/
chmod +x /mnt/chroot/setup/*
sync

# Run the provisioning scripts
arch-chroot /mnt/chroot /bin/bash /setup/10-update-os.sh
arch-chroot /mnt/chroot /bin/bash /setup/40-ssm-agent.sh
arch-chroot /mnt/chroot /bin/bash /setup/90-bootloader.sh "$INSTALL_MODE" "$INSTALL_DEV"
arch-chroot /mnt/chroot /bin/bash /setup/99-clean.sh

# Restore the chroot's resolve.conf
rm /mnt/chroot/etc/resolv.conf
mv /mnt/chroot/etc/resolv.conf.bak /mnt/chroot/etc/resolv.conf
