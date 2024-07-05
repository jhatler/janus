#!/usr/bin/env python
"Generate the CI matrix for the project containers."

import glob
import json
import os
import pathlib
import sys

import yaml  # pylint: disable=import-error


def _write_github_output(data):
    with open(os.environ["GITHUB_OUTPUT"], "a", encoding="utf-8") as f:
        for name, value in data.items():
            f.write(f"{name}={json.dumps(value)}\n")


def _changed_paths():
    if "GITHUB_BASE_REF" in os.environ:
        print(f"base: {os.environ['GITHUB_BASE_REF']}")
        before = f"origin/{os.environ['GITHUB_BASE_REF'].split('/')[-1]}"
    else:
        print("base: HEAD~1")
        os.system("git checkout HEAD^")
        before = "HEAD~1"

    changes = os.popen(f"git diff --name-only {before}").read().splitlines()

    return [pathlib.Path(c) for c in changes]


def _find_ci(paths):
    ci = {
        pathlib.Path(f)
        for path in paths
        for f in glob.glob(f"{path}/.ci.*")
        if os.path.exists(f)
    }
    next_paths = {parent for path in paths for parent in path.parents}
    if not next_paths:
        return ci
    return ci | _find_ci(next_paths)


def _order_top_down(path_set):
    return sorted(path_set, key=lambda x: len(x.parents))


def _deep_merge(a, b):
    if isinstance(a, dict) and isinstance(b, dict):
        for key in b:
            if key in a:
                a[key] = _deep_merge(a[key], b[key])
            else:
                a[key] = b[key]
    elif isinstance(a, list) and isinstance(b, list):
        a.extend(b)
    else:
        return b
    return a


def interrogate():
    "Interrogate the git history for changes and merge CI files."
    changes = _changed_paths()
    if changes:
        for change in changes:
            print(f"changed: {change}")
    else:
        print("warn: no changes detected")

    ci_files = {ci.resolve() for ci in _find_ci(changes)}

    output = {}
    for ci in _order_top_down(ci_files):
        if str(ci) == os.path.abspath(__file__):
            continue

        if ci.stat().st_size == 0:
            print(f"warn: empty ci file: {ci}")
        elif ci.suffix in [".yml", ".yaml", ".json"]:
            # All valid JSON is valid YAML
            output = _deep_merge(output, yaml.safe_load(ci.read_text()))
            print(f"merged: {ci}")
        elif os.access(ci, os.X_OK):
            output = _deep_merge(output, yaml.safe_load(os.popen(str(ci)).read()))
            print(f"merged stdout: {ci}")
        else:
            print(f"warn: unable to handle: {ci}")

    _write_github_output(output)


if __name__ == "__main__":
    allowed_fns = [
        attr
        for attr in dir()
        if callable(getattr(sys.modules[__name__], attr)) and not attr.startswith("_")
    ]
    usage = f"usage: {sys.argv[0]} [help|{'|'.join(allowed_fns)}]"

    try:
        fn = sys.argv[1] if sys.argv[1] in allowed_fns else "usage"
        if fn in ["help", "usage"]:
            print(usage)
            sys.exit(1 if fn == "usage" else 0)
        fn = getattr(sys.modules[__name__], fn)
        fn()
    except IndexError:
        interrogate()
