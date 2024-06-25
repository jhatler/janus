#!/bin/bash

set -ex -o pipefail

# Ensure the code user has been created and configured
id code
grep '^code:' /etc/passwd | cut -d: -f7 | grep -q /bin/bash
grep '^code:' /etc/passwd | cut -d: -f6 | grep -q /__w

# Check that the runner dependencies and tools are installed
jq --version
unzip -v
uuid
groff --version

aws --version
