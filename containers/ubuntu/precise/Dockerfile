#checkov:skip=CKV_DOCKER_2:Not applicable
#checkov:skip=CKV_DOCKER_3:Not applicable
#checkov:skip=CKV_DOCKER_7:False positive

# ghcr.io/jhatler/ubuntu-cloudimg:precise-20170502
ARG CONTAINER_REPO=ghcr.io/jhatler/ubuntu-cloudimg
ARG CONTAINER_TAG="@sha256:219a5ff64f11554dc85ad9c1fe26575ff18a4a8e0d8121cf00891d8f2af082aa"
ARG CONTAINER_IMAGE="${CONTAINER_REPO}${CONTAINER_TAG}"

# hadolint ignore=DL3006
FROM ${CONTAINER_IMAGE}
ARG TARGETARCH

SHELL ["/bin/bash", "-o", "pipefail", "-ex", "-c"]
ENV SHELL=/bin/bash
ENV DEBIAN_FRONTEND=noninteractive
