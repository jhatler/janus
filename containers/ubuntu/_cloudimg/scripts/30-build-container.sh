#!/bin/bash

set -ex -o pipefail

: "${CONTAINER_REPO?Need to set CONTAINER_REPO}"
: "${CONTAINER_TAG?Need to set CONTAINER_TAG}"
: "${PLATFORM?Need to set PLATFORM}"
: "${FROM?Need to set FROM}"
: "${TYPE?Need to set TYPE}"

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <stem>"
    exit 1
fi

STEM=$1

export BUILDAH_FORMAT=docker
export BUILDAH_LAYERS=true

ID="$(buildah from --platform "$PLATFORM" "$FROM")"

buildah add "$ID" "$STEM.tar" /

buildah config --shell '["/bin/bash", "-o", "pipefail", "-e", "-c"]' "$ID"

buildah config --env LANG=C "$ID"
buildah config --env LC_ALL=C "$ID"
buildah config --env LANGUAGE=en_US:en "$ID"
buildah config --env TERM=linux "$ID"
buildah config --env DEBIAN_FRONTEND=noninteractive "$ID"

buildah add "$ID" janus/containers/ubuntu/_cloudimg/files /setup
buildah run "$ID" chmod 755 /setup/normalize.sh
buildah run "$ID" /setup/normalize.sh "$TYPE"
buildah run "$ID" rm -rf /setup

buildah tag "$(buildah commit --rm --squash "$ID")" "${CONTAINER_REPO}:${CONTAINER_TAG}"

_retries=5
until buildah push "${CONTAINER_REPO}:${CONTAINER_TAG}"; do
    _retries=$((_retries - 1))
    if [ $_retries -eq 0 ]; then
        exit 1
    fi
    sleep 5
done

echo "repo=${CONTAINER_REPO}" | tee -a "$GITHUB_OUTPUT"
echo "tag=${CONTAINER_TAG}" | tee -a "$GITHUB_OUTPUT"
