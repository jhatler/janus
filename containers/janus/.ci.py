#!/usr/bin/env python3
"Generate the CI matrix for Janus containers."

# pylint: disable=duplicate-code

import json
import os
import random
from itertools import product


def permute_flags():
    "Generate all possible build flag permutations."
    flag_update_from = [True, False]
    flag_update_os_deps = [True, False]
    flag_update_app_deps = [True, False]
    flag_update_app_pkgs = [True, False]
    flag_update_app = [True, False]

    flags = list(
        product(
            flag_update_from,
            flag_update_os_deps,
            flag_update_app_deps,
            flag_update_app_pkgs,
            flag_update_app,
        )
    )

    for flag in flags:
        _, _, _, update_app_pkgs, update_app = flag
        if update_app_pkgs and not update_app:
            continue
        yield flag


def build_flags_string(
    update_from, update_os_deps, update_app_deps, update_app_pkgs, update_app
):
    "Build the string of build flags for the given release."
    ret = []
    if update_from:
        ret.append("CONTAINER_IMAGE=ubuntu:22.04")

    if update_os_deps:
        ret.extend(
            [
                "OS_DEP_BUILD_ESSENTIAL=",
                "OS_DEP_CA_CERTIFICATES=",
                "OS_DEP_CONTAINERD_IO=",
                "OS_DEP_CURL=",
                "OS_DEP_DIRMNGR=",
                "OS_DEP_DOCKER_BUILDX_PLUGIN=",
                "OS_DEP_DOCKER_COMPOSE_PLUGIN=",
                "OS_DEP_GIT=",
                "OS_DEP_GNUPG=",
                "OS_DEP_JQ=",
                "OS_DEP_LIBATOMIC1=",
                "OS_DEP_LIBBLUETOOTH_DEV=",
                "OS_DEP_LIBBZ2_DEV=",
                "OS_DEP_LIBDB_DEV=",
                "OS_DEP_LIBLZMA_DEV=",
                "OS_DEP_LIBMPDEC_DEV=",
                "OS_DEP_LIBFFI_DEV=",
                "OS_DEP_LIBREADLINE_DEV=",
                "OS_DEP_LIBSQLITE3_DEV=",
                "OS_DEP_LIBSSL_DEV=",
                "OS_DEP_LIBTINFO_DEV=",
                "OS_DEP_LSB_RELEASE=",
                "OS_DEP_PIGZ=",
                "OS_DEP_TK_DEV=",
                "OS_DEP_UUID_DEV=",
                "OS_DEP_WGET=",
                "OS_DEP_XZ_UTILS=",
            ]
        )

    if update_app_deps:
        ret.extend(
            [
                "APP_DEP_APT=",
                "APP_DEP_DOCKER=",
                "APP_DEP_PIP=",
                "APP_DEP_PYTHON=",
                "APP_DEP_NODE=",
                "APP_DEP_YARN=",
            ]
        )

    if update_app_pkgs:
        ret.append("APP_PACKAGES=")

    if update_app:
        if "GITHUB_HEAD_REF" in os.environ:
            ret.append(f'APP_REF={os.environ["GITHUB_HEAD_REF"].split("/")[-1]}')
        else:
            ret.append(f'APP_REF={os.environ["GITHUB_REF"].split("/")[-1]}')
    else:
        ret.append(f'APP_REF={os.environ["GITHUB_HEAD_REF"].split("/")[-1]}')

    return "\n".join(ret) + "\n"


def _git_root():
    "Return the root of the git repository."
    return os.popen("git rev-parse --show-toplevel").read().strip()


def main():
    "Generate the CI matrix for Janus container."
    # pylint: disable=too-many-locals,duplicate-code
    container_name = os.path.basename(os.path.dirname(__file__))
    container_context = os.path.relpath(os.path.dirname(__file__), _git_root())

    ci_per_run = 9999

    output = {
        "ci": {"needed": True, "matrix": {"include": []}},
        "post": {"needed": True, "matrix": {"include": []}},
    }

    selected = []
    permutations = []
    for flags in permute_flags():
        # keep the letter corresponding to the flag
        flag_str = "".join(["fodpa"[i] for i, flag in enumerate(flags) if flag])
        ci_id = "ci" if flag_str == "" else f"ci-{flag_str}"

        post = {
            "name": container_name,
            "id": ci_id,
            "runs-on": ["aws:ec2launchtemplate:runner-arm64"],
            "container": {"enable": True},
            "devcontainer": {"enable": True},
        }

        ci = []
        for arch in ["amd64", "arm64"]:
            if arch == "arm64":
                runs_on = ["aws:ec2launchtemplate:runner-arm64"]
            else:
                runs_on = ["aws:ec2launchtemplate:runner-amd64"]

            ci.append(
                {
                    "name": container_name,
                    "id": f"{ci_id}-{arch}",
                    "platform": f"linux/{arch}",
                    "runs-on": runs_on,
                    "context": container_context,
                    "container": {"enable": True, "args": build_flags_string(*flags)},
                    "devcontainer": {"enable": True},
                }
            )

        # If all boolean in flags are unset or set, append to selected, else append to permutations
        if len(set(flags)) == 1:
            selected.append((ci, post))
        else:
            permutations.append((ci, post))

    if os.path.exists(".cicache.json"):
        with open(".cicache.json", "r", encoding="utf-8") as f:
            cache = json.load(f)
    else:
        cache = {"failures": []}

    if len(cache["failures"]) > 0:
        for i in range(len(cache["failures"])):
            selected.append(cache["failures"].pop())

    # Randomly select ci_needed permutations
    ci_needed = min(len(permutations), ci_per_run - len(selected))
    for i in range(ci_needed):
        selected.append(permutations.pop(random.randint(0, len(permutations) - 1)))

    for ci, post in selected:
        output["ci"]["matrix"]["include"].extend(ci)
        output["post"]["matrix"]["include"].append(post)

    print(json.dumps(output))


if __name__ == "__main__":
    main()
