#!/usr/bin/env bash
# jscpd:ignore-start
#-------------------------------------------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See https://go.microsoft.com/fwlink/?linkid=2090316 for license information.
#-------------------------------------------------------------------------------------------------------------

USERNAME=${USERNAME:-"code"}

set -eux

if [ "$(id -u)" -ne 0 ]; then
    echo -e 'This script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile.'
    exit 1
fi

# Ensure that login shells get the correct path if the user updated the PATH using ENV.
rm -f /etc/profile.d/00-restore-env.sh
echo "export PATH=${PATH//$(sh -lc 'echo $PATH')/\$PATH}" >/etc/profile.d/00-restore-env.sh
chmod +x /etc/profile.d/00-restore-env.sh

# jscpd:ignore-end

npm install -g @devcontainers/cli@0.62.0

echo "Done!"
