#checkov:skip=CKV_DOCKER_2:Not applicable
#checkov:skip=CKV_DOCKER_3:Not applicable
#checkov:skip=CKV_DOCKER_7:False positive

# ghcr.io/jhatler/ubuntu-cloudimg:eoan-minimal-20200716
ARG CONTAINER_REPO=ghcr.io/jhatler/ubuntu-cloudimg
ARG CONTAINER_TAG="@sha256:eaca8b11b2e0004d329b0826e3a081eece5059ebd926fa26618c772aaae4010f"
ARG CONTAINER_IMAGE="${CONTAINER_REPO}${CONTAINER_TAG}"

# hadolint ignore=DL3006
FROM ${CONTAINER_IMAGE}
ARG TARGETARCH

SHELL ["/bin/bash", "-o", "pipefail", "-ex", "-c"]
ENV SHELL=/bin/bash
ENV DEBIAN_FRONTEND=noninteractive
