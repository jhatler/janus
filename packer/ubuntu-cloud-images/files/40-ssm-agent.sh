#!/bin/bash

set -ex -o pipefail

function _seed_snapd() {
    local _snap _assert _classic _retries
    _classic='false'

    if [ "$2" = 'true' ]; then
        _classic='true'
    fi

    _retries=5
    until snap download "$1"; do
        _retries=$((_retries - 1))
        if [ $_retries -eq 0 ]; then
            exit 1
        fi
        sleep 5
    done

    _snap=$(ls -1 "$1"_*.snap)
    _assert=$(ls -1 "$1"_*.assert)

    mv "$_snap" /var/lib/snapd/seed/snaps/
    mv "$_assert" /var/lib/snapd/seed/assertions/

    printf '  -\n    name: %s\n    channel: %s\n    file: %s\n    classic: %s\n' \
        "$1" \
        'stable' \
        "$_snap" \
        "$_classic" \
        >>/var/lib/snapd/seed/seed.yaml
}

function _init_snapd_seeds() {
    if [ -d /var/lib/snapd/seed ]; then
        return
    fi

    mkdir -p /var/lib/snapd/seed/{snaps,assertions}
    printf 'snaps:\n' >/var/lib/snapd/seed/seed.yaml

    _seed_snapd "bare"
    _seed_snapd "core$(echo "$VERSION" | cut -f1 -d.)"
    _seed_snapd "snapd"
}

function _install_ssm_deb() {
    local _url _deb _arch
    _arch=$(dpkg --print-architecture)
    _url="https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/debian_${_arch}/amazon-ssm-agent.deb"
    _deb='/tmp/amazon-ssm-agent.deb'

    curl -sL "$_url" -o "$_deb"
    dpkg -i "$_deb"
}

function _install_ssm_rc_local() {
    local _url _deb _arch
    _arch=$(dpkg --print-architecture)
    _url="https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/debian_${_arch}/amazon-ssm-agent.deb"
    _deb='/tmp/amazon-ssm-agent.deb'

    cat <<EOF >/etc/rc.local
#!/bin/sh -e
curl -sL "$_url" -o "$_deb"
dpkg -i "$_deb"
rm -f "$_deb"

echo '#!/bin/sh -e' > /etc/rc.local
echo 'exit 0' >> /etc/rc.local

exit 0
EOF

    chmod +x /etc/rc.local
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

if [[ "$VERSION" =~ [12][0-9]\.10 ]] || [[ "$VERSION" =~ [12][13579]\.04 ]]; then
    echo "SSM Agent is only supported on LTS versions of Ubuntu"
    exit 0
fi

if [ "$VERSION_MAJOR" -eq 14 ]; then
    _install_ssm_rc_local
elif [ "$VERSION_MAJOR" -eq 16 ]; then
    _install_ssm_deb
    if [ -n "$(which systemctl 2>/dev/null)" ]; then
        systemctl enable amazon-ssm-agent
    else
        update-rc.d amazon-ssm-agent defaults
    fi
else
    _init_snapd_seeds
    _seed_snapd "core18"
    _seed_snapd "amazon-ssm-agent" 'true'

    # snapd will automatically reseed if the state is removed
    rm -f /var/lib/snapd/state.*
fi

groupadd -g 9999 ssm-user
useradd -u 9999 -g ssm-user -d /home/ssm-user -s /bin/bash -m ssm-user

cat <<EOF >/etc/sudoers.d/ssm-agent-users
# User rules for ssm-user
ssm-user ALL=(ALL) NOPASSWD:ALL
EOF
