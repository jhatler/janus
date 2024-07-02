#!/bin/bash

set -ex -o pipefail

# TODO: pull from SSM param store
# Ensure all the runner scripts and unit files are present
test -f /etc/systemd/system/actions.runner.service

test -L /usr/local/bin/actions.runner.service.pre.sh
test -x /usr/local/bin/actions.runner.service.hook.sh
test -L /usr/local/bin/actions.runner.service.post.sh

test -x /usr/local/bin/actions.runner.job.started.sh
test -x /usr/local/bin/actions.runner.job.completed.sh

test -x /usr/local/bin/actions.runner.service.watchdog.sh

# Ensure the code user has been created and configured
id code
groups code | grep -q docker
grep '^code:' /etc/passwd | cut -d: -f7 | grep -q /bin/bash
grep '^code:' /etc/passwd | cut -d: -f6 | grep -q /__w

# Check that the runner dependencies and tools are installed
jq --version
unzip -v
uuid
groff --version

aws --version
go version
packer version
terraform version

sudo -i -u code nvm --version
sudo -i -u code node --version
sudo -i -u code devcontainer --version
sudo -i -u code cosign version

dpkg -l | grep -E '^ii  docker-ce '
dpkg -l | grep -E '^ii  docker-ce-cli '
dpkg -l | grep -E '^ii  containerd.io '
dpkg -l | grep -E '^ii  docker-buildx-plugin '
dpkg -l | grep -E '^ii  docker-compose-plugin '

# Ensure docker has been configured
test -f /etc/docker/daemon.json
test -f /etc/containerd/config.toml
