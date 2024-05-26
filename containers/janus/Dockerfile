#checkov:skip=CKV_DOCKER_3:Handled by devcontainer
#checkov:skip=CKV_DOCKER_2:Not applicable
# Build stage
FROM mcr.microsoft.com/devcontainers/typescript-node:22-bookworm as build
SHELL ["/bin/bash", "-o", "pipefail", "-e", "-c"]
ENV SHELL=/bin/bash
ENV DEBIAN_FRONTEND=noninteractive

# hadolint ignore=DL3003
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
        build-essential=12.9 \
        wget=1.21.3-1+b2 \
        gnupg=2.2.40-1.1 \
        bash-completion=1:2.11-6 \
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

# Create testing timestamp
RUN date -u +'%Y-%m-%dT%H:%M:%SZ' > /.build-date

# Final stage
FROM build as final
COPY --from=testing /.build-date /.build-date
