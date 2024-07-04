#checkov:skip=CKV_DOCKER_2:Not applicable
#checkov:skip=CKV_DOCKER_3:Not applicable
#checkov:skip=CKV_DOCKER_7:False positive

# ghcr.io/jhatler/ubuntu-cloudimg:cosmic-minimal-20190628
ARG CONTAINER_REPO=ghcr.io/jhatler/ubuntu-cloudimg
ARG CONTAINER_TAG="@sha256:87f7a1f9c7171708a6ea45da41e3c232c1dbb33f50651ab32a9669082f2c774d"
ARG CONTAINER_IMAGE="${CONTAINER_REPO}${CONTAINER_TAG}"

# hadolint ignore=DL3006
FROM ${CONTAINER_IMAGE}
ARG TARGETARCH

SHELL ["/bin/bash", "-o", "pipefail", "-ex", "-c"]
ENV SHELL=/bin/bash
ENV DEBIAN_FRONTEND=noninteractive
