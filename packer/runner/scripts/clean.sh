#!/bin/bash

set -ex -o pipefail

cloud-init clean --logs --machine-id --configs all
rm -f /etc/sudoers.d/90-cloud-init-users

apt-get clean
rm -rf /var/lib/apt/lists/*
find /var/cache/apt -type f -print0 | xargs -0 rm -f
touch -d '1970-01-01 0:00:00' /var/lib/apt/lists

# Stop the journal, clear machine-specific logs, and truncate the rest
systemctl stop systemd-journald.service systemd-journald{,-dev-log,-audit}.socket
rm -rf /var/log/journal/* /var/log/amazon/ssm/audits/* /var/log/apt/*
find /var/log -type f -print0 | xargs -0 truncate --size=0

# Clear the tmp directories
find /var/tmp /tmp -mindepth 1 -maxdepth 1 -type d -exec rm -rf {} \;

# Recommended by systemd for imaging
rm -f /var/lib/systemd/random-seed /etc/hostname

# Prevent known host or key issues
rm -f /etc/ssh/ssh_host_* /root/.ssh/authorized_keys

# Clean AWS SSM Agent
rm -rf /var/lib/amazon/ssm

# Delete the setup files
rm -rf /setup

# Deletes the ubuntu group too
# No sudo after this, including in packer provisioners
userdel -rf ubuntu
