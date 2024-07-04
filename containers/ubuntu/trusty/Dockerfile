#checkov:skip=CKV_DOCKER_2:Not applicable
#checkov:skip=CKV_DOCKER_3:Not applicable
#checkov:skip=CKV_DOCKER_7:False positive

# ghcr.io/jhatler/ubuntu-cloudimg:trusty-20191107
ARG CONTAINER_REPO=ghcr.io/jhatler/ubuntu-cloudimg
ARG CONTAINER_TAG="@sha256:25fef325fb1811bebe2821750c0cd83c130917294023436757a8d43d43a36fdc"
ARG CONTAINER_IMAGE="${CONTAINER_REPO}${CONTAINER_TAG}"

# hadolint ignore=DL3006
FROM ${CONTAINER_IMAGE}
ARG TARGETARCH

SHELL ["/bin/bash", "-o", "pipefail", "-ex", "-c"]
ENV SHELL=/bin/bash
ENV DEBIAN_FRONTEND=noninteractive
