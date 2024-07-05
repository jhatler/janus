#!/usr/bin/env python3
"Generate the CI matrix for the ubuntu containers."

import json
import os
from itertools import product


def ubuntu_version(release):
    "Return the numeric version of the Ubuntu release as a string."
    lookup = {
        "hardy": "8.04",
        "lucid": "10.04",
        "maverick": "10.10",
        "natty": "11.04",
        "oneiric": "11.10",
        "precise": "12.04",
        "quantal": "12.10",
        "raring": "13.04",
        "saucy": "13.10",
        "trusty": "14.04",
        "utopic": "14.10",
        "vivid": "15.04",
        "wily": "15.10",
        "xenial": "16.04",
        "yakkety": "16.10",
        "zesty": "17.04",
        "artful": "17.10",
        "bionic": "18.04",
        "cosmic": "18.10",
        "disco": "19.04",
        "eoan": "19.10",
        "focal": "20.04",
        "groovy": "20.10",
        "hirsute": "21.04",
        "impish": "21.10",
        "jammy": "22.04",
        "kinetic": "22.10",
        "lunar": "23.04",
        "mantic": "23.10",
        "noble": "24.04",
    }

    if release.endswith("-minimal"):
        release = release[:-8]

    return lookup[release]


def permute_flags(releases):
    "Generate all possible flag permutations for the given releases."
    flag_update_from = [True, False]

    yield from list(product(releases, flag_update_from))


def build_flags_string(release, update_from):
    "Build the string of build flags for the given release."
    ret = []
    if update_from:
        ret.append(f"CONTAINER_IMAGE=ghcr.io/jhatler/ubuntu-cloudimg:{release}")

    return "\n".join(ret) + "\n"


def _git_root():
    "Return the root of the git repository."
    return os.popen("git rev-parse --show-toplevel").read().strip()


def _ubuntu_root():
    "Return the root of the ubuntu container directory."
    git_root = _git_root()
    return os.path.join(git_root, "containers", "ubuntu")


def find_releases():
    "Find all the ubuntu releases in the containers/ubuntu directory."
    return [
        d
        for d in os.listdir(_ubuntu_root())
        if os.path.isdir(os.path.join(_ubuntu_root(), d)) and not d.startswith("_")
    ]


def main():
    "Generate the CI matrix for the ubuntu containers."
    # pylint: disable=too-many-locals,duplicate-code
    releases = find_releases()

    output = {
        "ci": {"needed": True, "matrix": {"include": []}},
        "post": {"needed": True, "matrix": {"include": []}},
    }

    container_name = "ubuntu"
    for release, update_from in permute_flags(releases):
        container_context = os.path.relpath(
            os.path.join(_ubuntu_root(), release), _git_root()
        )

        ci_id = f"ci-{release}"
        if update_from:
            ci_id = f"{ci_id}-cloudimg"

        version = float(ubuntu_version(release))
        version_major = int(ubuntu_version(release).split(".")[0])
        version_minor = int(ubuntu_version(release).split(".")[1])

        version_type = (
            "lts" if version_major % 2 == 0 and version_minor == 4 else "interim"
        )

        aches = ["amd64"]
        if release.endswith("-minimal"):
            if version >= 23.10:
                aches.append("arm64")
        else:
            if version < 20.04:
                aches.append("i386")
            if version >= 23.04 or (version >= 14.04 and version_type == "lts"):
                aches.append("arm64")

        output["post"]["matrix"]["include"].append(
            {
                "name": container_name,
                "id": ci_id,
                "runs-on": ["aws:ec2launchtemplate:runner-arm64"],
                "container": {"enable": True},
                "devcontainer": {"enable": False},
            }
        )

        for arch in aches:
            if arch == "arm64":
                runs_on = ["aws:ec2launchtemplate:runner-arm64"]
            else:
                runs_on = ["aws:ec2launchtemplate:runner-amd64"]

            output["ci"]["matrix"]["include"].append(
                {
                    "name": container_name,
                    "id": f"{ci_id}-{arch}",
                    "platform": f"linux/{arch}",
                    "runs-on": runs_on,
                    "context": container_context,
                    "container": {
                        "enable": True,
                        "args": build_flags_string(release, update_from),
                    },
                    "devcontainer": {"enable": False},
                }
            )

    print(json.dumps(output))


if __name__ == "__main__":
    main()
