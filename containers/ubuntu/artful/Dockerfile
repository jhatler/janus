#checkov:skip=CKV_DOCKER_2:Not applicable
#checkov:skip=CKV_DOCKER_3:Not applicable
#checkov:skip=CKV_DOCKER_7:False positive

# ghcr.io/jhatler/ubuntu-cloudimg:artful-20180706
ARG CONTAINER_REPO=ghcr.io/jhatler/ubuntu-cloudimg
ARG CONTAINER_TAG="@sha256:5754ebe6b4dfaaa1cfc55dd77d776ef4c3f961d182cfeb983c28c061b8132873"
ARG CONTAINER_IMAGE="${CONTAINER_REPO}${CONTAINER_TAG}"

# hadolint ignore=DL3006
FROM ${CONTAINER_IMAGE}
ARG TARGETARCH

SHELL ["/bin/bash", "-o", "pipefail", "-ex", "-c"]
ENV SHELL=/bin/bash
ENV DEBIAN_FRONTEND=noninteractive
