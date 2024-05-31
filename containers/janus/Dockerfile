#checkov:skip=CKV_DOCKER_3:Handled by devcontainer
#checkov:skip=CKV_DOCKER_2:Not applicable

# Build stage
FROM mcr.microsoft.com/devcontainers/typescript-node:22-bookworm as build
ARG TARGETARCH

LABEL org.label-schema.schema-version="1.0"
LABEL maintainer="Jaremy Hatler <hatler.jaremy@gmail.com>"

SHELL ["/bin/bash", "-o", "pipefail", "-e", "-c"]
ENV SHELL=/bin/bash
ENV DEBIAN_FRONTEND=noninteractive

# hadolint ignore=DL3003
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      build-essential=12.9 \
      gnupg=2.2.40-1.1 \
      bash-completion=1:2.11-6 \
 && if [[ $TARGETARCH   = "amd64" ]]; then \
      apt-get install -y wget=1.21.3-1+b2; \
    elif [[ $TARGETARCH   = "arm64" ]]; then \
      apt-get install -y wget=1.21.3-1+b1; \
    else \
      false; \
    fi \
 && apt-get autoremove --purge -y \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && find /var/cache/apt -type f -print0 | xargs -0 rm -f

# Testing stage - verify binaries work and have the right permissions
FROM build as testing
RUN wget --version \
 && gpg2 --version \
 && node --version \
 && npm --version \
 && tsc --version

# Final stage
FROM testing as final
