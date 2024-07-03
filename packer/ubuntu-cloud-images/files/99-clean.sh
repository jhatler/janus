#!/bin/bash -ex

set -ex -o pipefail

if [ -f /etc/machine-id ]; then
    echo "uninitialized" >/etc/machine-id
fi

if [ -f /var/lib/systemd/random-seed ]; then
    rm /var/lib/systemd/random-seed
fi

rm -f /etc/sudoers.d/90-cloud-init-users

apt-get clean
rm -rf /var/lib/apt/lists/* /etc/apt/sources.list /etc/apt/sources.list.d/ubuntu.sources
find /var/cache/apt -type f -print0 | xargs -0 rm -f
touch -d '1970-01-01 0:00:00' /var/lib/apt/lists

# Stop the journal, clear machine-specific logs, and truncate the rest
rm -rf /var/log/journal/* /var/log/amazon/ssm/audits/* /var/log/apt/*
find /var/log -type f -print0 | xargs -0 truncate --size=0

# Clear the tmp directories
find /var/tmp /tmp -mindepth 1 -maxdepth 1 -type d -exec rm -rf {} \;

# Recommended by systemd for imaging
rm -f /var/lib/systemd/random-seed /etc/hostname

# Clean AWS SSM Agent
rm -rf /var/lib/amazon/ssm

# Prevent known host issues
rm -f /etc/ssh/ssh_host_*

# Clean Setup
rm -rf /setup
