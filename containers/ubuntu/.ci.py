#!/usr/bin/env python3

import json
import os
import random

from itertools import product


def ubuntu_version(release):
    lookup = {
        'hardy': '8.04',
        'lucid': '10.04',
        'maverick': '10.10',
        'natty': '11.04',
        'oneiric': '11.10',
        'precise': '12.04',
        'quantal': '12.10',
        'raring': '13.04',
        'saucy': '13.10',
        'trusty': '14.04',
        'utopic': '14.10',
        'vivid': '15.04',
        'wily': '15.10',
        'xenial': '16.04',
        'yakkety': '16.10',
        'zesty': '17.04',
        'artful': '17.10',
        'bionic': '18.04',
        'cosmic': '18.10',
        'disco': '19.04',
        'eoan': '19.10',
        'focal': '20.04',
        'groovy': '20.10',
        'hirsute': '21.04',
        'impish': '21.10',
        'jammy': '22.04',
        'kinetic': '22.10',
        'lunar': '23.04',
        'mantic': '23.10',
        'noble': '24.04'
    }

    if release.endswith('-minimal'):
        release = release[:-8]

    return lookup[release]


def permute_flags(releases):
    flag_update_from = [True, False]

    flags = list(product(
        releases,
        flag_update_from
    ))

    for flag in flags:
        yield flag


def build_flags_string(release, update_from):
    ret = []
    if update_from:
        ret.append(f'CONTAINER_IMAGE=ghcr.io/jhatler/ubuntu-cloudimg:{release}')

    return '\n'.join(ret) + '\n'


def main():
    git_root = os.popen("git rev-parse --show-toplevel").read().strip()

    # get all release dirs in ubuntu_root
    ubuntu_root = os.path.join(git_root, 'containers', 'ubuntu')
    releases = [d for d in os.listdir(ubuntu_root) if os.path.isdir(
        os.path.join(ubuntu_root, d)) and not d.startswith('_')]

    runners_per_arch = 4
    output = {
        "ci": {
            "needed": True,
            "matrix": {
                "include": []
            }
        },
        "post": {
            "needed": True,
            "matrix": {
                "include": []
            }
        }
    }

    container_name = 'ubuntu'
    for release, update_from in permute_flags(releases):
        container_context = os.path.relpath(os.path.join(ubuntu_root, release), git_root)

        id = f'ci-{release}'
        if update_from:
            id = f'{id}-cloudimg'

        version = float(ubuntu_version(release))
        version_major = int(ubuntu_version(release).split('.')[0])
        version_minor = int(ubuntu_version(release).split('.')[1])

        version_type = 'lts' if version_major % 2 == 0 and version_minor == 4 else 'interim'

        aches = ['amd64']
        if release.endswith('-minimal'):
            if version >= 23.10:
                aches.append('arm64')
        else:
            if version < 20.04:
                aches.append('i386')
            if version >= 23.04 or (version >= 14.04 and version_type == 'lts'):
                aches.append('arm64')

        output["post"]["matrix"]["include"].append({
            "name": container_name,
            "id": id,
            "runs-on": ["aws:ec2launchtemplate:runner-arm64"],
            "container": {"enable": True},
            "devcontainer": {"enable": False}
        })

        for arch in aches:
            output["ci"]["matrix"]["include"].append({
                "name": container_name,
                "id": f'{id}-{arch}',
                "platform": f"linux/{arch}",
                "runs-on": ["aws:ec2launchtemplate:runner-arm64"] if arch == "arm64" else ["aws:ec2launchtemplate:runner-amd64"],
                "context": container_context,
                "container": {
                    "enable": True,
                    "args": build_flags_string(release, update_from)
                },
                "devcontainer": {
                    "enable": False
                }
            })

    print(json.dumps(output))


if __name__ == '__main__':
    main()
