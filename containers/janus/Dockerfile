#checkov:skip=CKV_DOCKER_2:Not applicable
#checkov:skip=CKV_DOCKER_7:False positive

# ubuntu:22.04
ARG CONTAINER_REPO=ubuntu
ARG CONTAINER_TAG="@sha256:a6d2b38300ce017add71440577d5b0a90460d0e57fd7aec21dd0d1b0761bbfb2"
ARG CONTAINER_IMAGE="${CONTAINER_REPO}${CONTAINER_TAG}"

ARG APP_NAME=janus
ARG APP_REPO=jhatler/janus
ARG APP_RELEASE_BRANCH=release-please--branches--main
ARG APP_REF=626ea80033398a06331879a41b9cea0ec1269342
ARG APP_PACKAGES=LOCKED

# hadolint ignore=DL3006
FROM ${CONTAINER_IMAGE} as build
ARG TARGETARCH

# Main Dependencies
ARG APP_DEP_PIP="24.0"
ARG APP_DEP_PYTHON="3.12.3"
ARG APP_DEP_NODE="22.2.0"
ARG APP_DEP_YARN="1.22.19"

# Build Dependencies
ARG OS_DEP_BUILD_ESSENTIAL="=12.9ubuntu3"
ARG OS_DEP_CA_CERTIFICATES="=20230311ubuntu0.22.04.1"
ARG OS_DEP_CURL="=7.81.0-1ubuntu1.16"
ARG OS_DEP_DIRMNGR="=2.2.27-3ubuntu2.1"
ARG OS_DEP_GIT="=1:2.34.1-1ubuntu1.11"
ARG OS_DEP_GNUPG="=2.2.27-3ubuntu2.1"
ARG OS_DEP_JQ="=1.6-2.1ubuntu3"
ARG OS_DEP_LIBATOMIC1="=12.3.0-1ubuntu1~22.04"
ARG OS_DEP_LIBBLUETOOTH_DEV="=5.64-0ubuntu1.3"
ARG OS_DEP_LIBBZ2_DEV="=1.0.8-5build1"
ARG OS_DEP_LIBDB_DEV="=1:5.3.21~exp1ubuntu4"
ARG OS_DEP_LIBFFI_DEV="=3.4.2-4"
ARG OS_DEP_LIBLZMA_DEV="=5.2.5-2ubuntu1"
ARG OS_DEP_LIBMPDEC_DEV="=2.5.1-2build2"
ARG OS_DEP_LIBREADLINE_DEV="=8.1.2-1"
ARG OS_DEP_LIBSQLITE3_DEV="=3.37.2-2ubuntu0.3"
ARG OS_DEP_LIBSSL_DEV="=3.0.2-0ubuntu1.16"
ARG OS_DEP_LIBTINFO_DEV="=6.3-2ubuntu0.1"
ARG OS_DEP_LSB_RELEASE="=11.1.0ubuntu4"
ARG OS_DEP_PIGZ="=2.6-1"
ARG OS_DEP_TK_DEV="=8.6.11+1build2"
ARG OS_DEP_UUID_DEV="=2.37.2-4ubuntu3.4"
ARG OS_DEP_WGET="=1.21.2-2ubuntu1"
ARG OS_DEP_XZ_UTILS="=5.2.5-2ubuntu1"

# Node Configuration
ARG NPM_GLOBAL=/usr/local/share/npm-global
ENV NPM_GLOBAL=${NPM_GLOBAL}
ARG YARN_KEY_URL=https://dl.yarnpkg.com/debian/pubkey.gpg
ARG YARN_KEY_FILE=/usr/local/src/yarn.gpg

# Shell setup
SHELL ["/bin/bash", "-o", "pipefail", "-e", "-c"]
ENV LANG C.UTF-8
ENV SHELL=/bin/bash
ENV DEBIAN_FRONTEND=noninteractive

# Origin: Node.js
# License: MIT
# URL: https://github.com/nodejs/docker-node/blob/main/22/bookworm-slim/Dockerfile
# commit: 14ae63a78d5e38557a56822bd2b1094d038e52a4
# Purpose: Add Node.js and Yarn to the image
# Modifications:
# - Formatting
# - Updated/removed comments
# - Updated apt cleanup, pinned versions
# - Directly receive keys based on node README, yarn documentation
# - Removed unsupported architectures
# - Smoketests moved to testing stage
# hadolint ignore=DL3008,SC2155
RUN ARCH="" OPENSSL_ARCH="" NODE_VERSION="" && dpkgArch="$(dpkg --print-architecture)" \
 && case "${dpkgArch##*-}" in \
        amd64) ARCH='x64' OPENSSL_ARCH='linux-x86_64';; \
        arm64) ARCH='arm64' OPENSSL_ARCH='linux-aarch64';; \
        *) echo "unsupported architecture"; exit 1 ;; \
    esac \
 && apt-get update \
 && apt-get install -y --no-install-recommends \
        ca-certificates${OS_DEP_CA_CERTIFICATES} \
        curl${OS_DEP_CURL} \
        dirmngr${OS_DEP_DIRMNGR} \
        gnupg${OS_DEP_GNUPG} \
        jq${OS_DEP_JQ} \
        libatomic1${OS_DEP_LIBATOMIC1} \
        wget${OS_DEP_WGET} \
        xz-utils${OS_DEP_XZ_UTILS} \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && find /var/cache/apt -type f -print0 | xargs -0 rm -f \
 && if [[ -z "${APP_DEP_NODE}" ]]; then \
        NODE_VERSION="$( \
            curl -s https://api.github.com/repos/nodejs/node/tags?per_page=100 \
                | jq -r '.[] | .name' \
                | sort -V \
                | tail -n 1 \
                | cut -c 2- \
        )"; \
    else \
        NODE_VERSION="${APP_DEP_NODE}" ; \
    fi \
    # use pre-existing gpg directory, see https://github.com/nodejs/docker-node/pull/1895#issuecomment-1550389150
 && export GNUPGHOME="$(mktemp -d)" \
    # Load keys listed in https://github.com/nodejs/node#release-keys
 && curl -sSL "https://raw.githubusercontent.com/nodejs/node/v${NODE_VERSION}/README.md" \
        | sed '0,/^### Release keys$/d;0,/^```bash$/d;/^```$/,$d' \
        | grep -o '[0-9A-F]\{40\}' \
        | while read -r key; do \
            gpg --batch --keyserver hkps://keys.openpgp.org --recv-keys "$key" || \
                gpg --batch --keyserver keyserver.ubuntu.com --recv-keys "$key" ; \
        done \
 && curl -fsSLO --compressed "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-$ARCH.tar.xz" \
 && curl -fsSLO --compressed "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" \
 && gpg --batch --decrypt --output SHASUMS256.txt SHASUMS256.txt.asc \
 && gpgconf --kill all \
 && rm -rf "$GNUPGHOME" \
 && grep " node-v$NODE_VERSION-linux-$ARCH.tar.xz\$" SHASUMS256.txt | sha256sum -c - \
 && tar -xJf "node-v$NODE_VERSION-linux-$ARCH.tar.xz" -C /usr/local --strip-components=1 --no-same-owner \
 && rm "node-v$NODE_VERSION-linux-$ARCH.tar.xz" SHASUMS256.txt.asc SHASUMS256.txt \
    # Remove unused OpenSSL headers to save ~34MB. See this NodeJS issue: https://github.com/nodejs/node/issues/46451
 && find /usr/local/include/node/openssl/archs -mindepth 1 -maxdepth 1 ! -name "$OPENSSL_ARCH" -exec rm -rf {} \; \
 && ln -s /usr/local/bin/node /usr/local/bin/nodejs

# hadolint ignore=SC2155
RUN YARN_VERSION= ; \
    if [[ -z "${APP_DEP_YARN}" ]]; then \
        YARN_VERSION="$( \
            curl -s https://api.github.com/repos/yarnpkg/yarn/tags?per_page=100 \
                | jq -r '.[] | .name' \
                | sort -V \
                | tail -n 1 \
                | cut -c 2- \
        )"; \
    else \
        YARN_VERSION="${APP_DEP_YARN}" ; \
    fi \
 && curl -fsSL -o "${YARN_KEY_FILE}" --compressed "${YARN_KEY_URL}" \
 && echo "8550a7e298b523fffa899069754fc150f2ff74092701e4d4109edd1cd6d5327f  ${YARN_KEY_FILE}" | sha256sum -c - \
 && curl -fsSLO --compressed "https://yarnpkg.com/downloads/$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz" \
 && curl -fsSLO --compressed "https://yarnpkg.com/downloads/$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz.asc" \
 && curl -fsSL -o yarn.gpg --compressed "https://dl.yarnpkg.com/debian/pubkey.gpg" \
 && export GNUPGHOME="$(mktemp -d)" \
 && gpg --batch --import yarn.gpg \
 && gpg --batch --verify "yarn-v$YARN_VERSION.tar.gz.asc" "yarn-v$YARN_VERSION.tar.gz" \
 && gpgconf --kill all \
 && rm -rf "$GNUPGHOME" "yarn-v$YARN_VERSION.tar.gz.asc" yarn.gpg \
 && mkdir -p /opt \
 && tar -xzf "yarn-v$YARN_VERSION.tar.gz" -C /opt/ \
 && ln -s "/opt/yarn-v$YARN_VERSION/bin/yarn" /usr/local/bin/yarn \
 && ln -s "/opt/yarn-v$YARN_VERSION/bin/yarnpkg" /usr/local/bin/yarnpkg \
 && rm "yarn-v$YARN_VERSION.tar.gz"

# Origin: Original

# Add NPM global to PATH and setup for root and non-root user
ENV PATH=${NPM_GLOBAL}/bin:${PATH}
RUN groupadd -r npm \
 && umask 0002 \
 && mkdir -p ${NPM_GLOBAL} \
 && touch /usr/local/etc/npmrc \
 && chgrp npm ${NPM_GLOBAL} /usr/local/etc/npmrc \
 && chmod g+s ${NPM_GLOBAL} \
 && npm config -g set prefix ${NPM_GLOBAL}

# Install python
# Origin: Docker
# License: MIT
# URL: https://github.com/docker-library/python/blob/master/3.12/bookworm/Dockerfile
# commit: bf5951cfa2b2f6c3dabf428549c9dca658ecee81
# Purpose: Add Python to the image
# Modifications:
# - Formatting
# - Updated/removed comments
# - Updated apt cleanup, pinned versions
# - combined run commands
# - Use node.js retrieval methods
# - Smoketests moved to testing stage
# hadolint ignore=DL3003,DL3008,SC2043
RUN PYTHON_VERSION= ; \
    if [[ -z "${APP_DEP_PYTHON}" ]]; then \
        PYTHON_VERSION="$( \
            curl -s https://api.github.com/repos/python/cpython/tags?per_page=100 \
                | jq -r '.[] | .name' \
                | grep -Ev '(rc|a|b)[0-9]$' \
                | sort -V \
                | tail -n 1 \
                | cut -c 2- \
        )"; \
    else \
        PYTHON_VERSION="${APP_DEP_PYTHON}" ; \
    fi \
 && apt-get update \
 && apt-get install -y --no-install-recommends \
        build-essential${OS_DEP_BUILD_ESSENTIAL} \
        libbluetooth-dev${OS_DEP_LIBBLUETOOTH_DEV} \
        libbz2-dev${OS_DEP_LIBBZ2_DEV} \
        libdb-dev${OS_DEP_LIBDB_DEV} \
        libffi-dev${OS_DEP_LIBFFI_DEV} \
        liblzma-dev${OS_DEP_LIBLZMA_DEV} \
        libmpdec-dev${OS_DEP_LIBMPDEC_DEV} \
        libreadline-dev${OS_DEP_LIBREADLINE_DEV} \
        libsqlite3-dev${OS_DEP_LIBSQLITE3_DEV} \
        libssl-dev${OS_DEP_LIBSSL_DEV} \
        libtinfo-dev${OS_DEP_LIBTINFO_DEV} \
        tk-dev${OS_DEP_TK_DEV} \
        uuid-dev${OS_DEP_UUID_DEV} \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && find /var/cache/apt -type f -print0 | xargs -0 rm -f \
 && export GNUPGHOME="$(mktemp -d)" \
 && for key in 7169605F62C751356D054A26A821E680E5FA6305; do \
        gpg --batch --keyserver hkps://keys.openpgp.org --recv-keys "$key" || \
            gpg --batch --keyserver keyserver.ubuntu.com --recv-keys "$key" ; \
    done \
 && curl -fsSLO --compressed \
        "https://www.python.org/ftp/python/${PYTHON_VERSION%%[a-z]*}/Python-$PYTHON_VERSION.tar.xz" \
 && curl -fsSLO --compressed \
        "https://www.python.org/ftp/python/${PYTHON_VERSION%%[a-z]*}/Python-$PYTHON_VERSION.tar.xz.asc" \
 && gpg --batch --verify "Python-$PYTHON_VERSION.tar.xz.asc" "Python-$PYTHON_VERSION.tar.xz" \
 && gpgconf --kill all \
 && rm -rf "$GNUPGHOME" "Python-$PYTHON_VERSION.tar.xz.asc" \
 && mkdir -p /usr/src/python \
 && tar --extract --directory /usr/src/python --strip-components=1 --file "Python-$PYTHON_VERSION.tar.xz" \
 && rm "Python-$PYTHON_VERSION.tar.xz" \
 && cd /usr/src/python \
 && ./configure \
        --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
        --enable-loadable-sqlite-extensions \
        --enable-ipv6 \
        --enable-loadable-sqlite-extensions \
        --enable-optimizations \
        --enable-option-checking=fatal \
        --enable-shared \
        --with-computed-gotos \
        --with-lto \
        --with-system-expat \
        --without-ensurepip \
        --without-static-libpython \
 && nproc="$(nproc)" \
 && EXTRA_CFLAGS="$(dpkg-buildflags --get CFLAGS)" \
 && LDFLAGS="$(dpkg-buildflags --get LDFLAGS)" \
 && make -j "$nproc" \
        "EXTRA_CFLAGS=${EXTRA_CFLAGS:-}" \
        "LDFLAGS=${LDFLAGS:-}" \
        "PROFILE_TASK=${PROFILE_TASK:-}" \
    # https://github.com/docker-library/python/issues/784
    # prevent accidental usage of a system installed libpython of the same version
 && rm python \
 && make -j "$nproc" \
        "EXTRA_CFLAGS=${EXTRA_CFLAGS:-}" \
        "LDFLAGS=${LDFLAGS:--Wl},-rpath='\$\$ORIGIN/../lib'" \
        "PROFILE_TASK=${PROFILE_TASK:-}" \
        python \
 && make install \
    # enable GDB to load debugging data: https://github.com/docker-library/python/pull/701
 && bin="$(readlink -ve /usr/local/bin/python3)" \
 && dir="$(dirname "$bin")" \
 && mkdir -p "/usr/share/gdb/auto-load/$dir" \
 && cp -vL Tools/gdb/libpython.py "/usr/share/gdb/auto-load/$bin-gdb.py" \
 && cd / \
 && rm -rf /usr/src/python \
 && find /usr/local -depth \
        \( \
            \( -type d -a \( -name test -o -name tests -o -name idle_test \) \) \
            -o \( -type f -a \( -name '*.pyc' -o -name '*.pyo' -o -name 'libpython*.a' \) \) \
    \) -exec rm -rf '{}' + \
 && ldconfig \
    # make some useful symlinks that are expected to exist ("/usr/local/bin/python" and friends)
 && for src in idle3 pydoc3 python3 python3-config; do \
        dst="$(echo "$src" | tr -d 3)"; \
        [ -s "/usr/local/bin/$src" ]; \
        [ ! -e "/usr/local/bin/$dst" ]; \
        ln -svT "$src" "/usr/local/bin/$dst"; \
    done

RUN _DEP_PIP_VER= ; \
    if [[ -z "${APP_DEP_PIP}" ]]; then \
        _DEP_PIP_VER="$( \
            curl -s https://api.github.com/repos/pypa/pip/tags?per_page=100 \
                | jq -r '.[] | .name' \
                | grep -v 'b[0-9]$' \
                | sort -V \
                | tail -n 1 \
        )"; \
    else \
        _DEP_PIP_VER="${APP_DEP_PIP}" ; \
    fi \
 && curl -fsSLo get-pip.py "https://raw.githubusercontent.com/pypa/get-pip/${_DEP_PIP_VER}/public/get-pip.py" \
 && export PYTHONDONTWRITEBYTECODE=1 \
 && python get-pip.py \
        --disable-pip-version-check \
        --no-cache-dir \
        --no-compile \
        "pip==$_DEP_PIP_VER" \
 && rm -f get-pip.py

# Origin: Original


FROM build as app
ARG TARGETARCH

ARG APP_NAME
ARG APP_REPO
ARG APP_RELEASE_BRANCH
ARG APP_REF
ARG APP_PACKAGES

# Non-Root User configuration
ARG USERNAME=${APP_NAME}
ARG GROUPNAME=${APP_NAME}
ARG USERHOME=/home/${USERNAME}
ARG APPHOME=/usr/local/src/${APP_NAME}
ENV APPHOME=${APPHOME}

SHELL ["/bin/bash", "-o", "pipefail", "-e", "-c"]

# hadolint ignore=DL3008,SC2086
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
        git${OS_DEP_GIT} \
        lsb-release${OS_DEP_LSB_RELEASE} \
        pigz${OS_DEP_PIGZ} \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && find /var/cache/apt -type f -print0 | xargs -0 rm -f

# Create a non-root user
# hadolint ignore=DL3003,SC2164
RUN groupadd --gid 1000 "${GROUPNAME}" \
 && useradd --uid 1000 --gid "${GROUPNAME}" --groups npm \
        --shell /bin/bash \
        --create-home --home-dir "${USERHOME}" \
        "${USERNAME}" \
 && chown "${USERNAME}" "${NPM_GLOBAL}" /usr/local/etc/npmrc \
 && su "${USERNAME}" -c "npm config -g set prefix ${NPM_GLOBAL}" \
 && _APP_REF=""; \
    if [[ -z "${APP_REF}" ]]; then \
        _APP_REF="$( \
            curl -s "https://api.github.com/repos/${APP_REPO}/branches/${APP_RELEASE_BRANCH}" | jq -r '.name' \
        )" ; \
        if [[ "$_APP_REF" == "null" ]]; then \
            _APP_REF="main"; \
        fi \
    else \
        _APP_REF="${APP_REF}" ; \
    fi \
 && git clone \
        "https://github.com/${APP_REPO}.git" \
        "${APPHOME}" \
 && cd "${APPHOME}" \
 && git checkout "$(git rev-parse ${_APP_REF})" \
 && git fetch --depth 1 \
 && git tag -l | xargs git tag -d \
 && git branch -D main \
 && git reflog expire --expire=all --all \
 && git gc --prune=all \
 && chown -R "${USERNAME}:${GROUPNAME}" "${APPHOME}"

ENV HOME ${USERHOME}
USER ${USERNAME}
WORKDIR ${APPHOME}
ENV PATH ${USERHOME}/.local/bin:${PATH}

# hadolint ignore=DL3013
RUN if [[ -z "${APP_PACKAGES}" ]]; then \
        sed -i 's/==.*//g' {,dev-}requirements.txt lib/*/{,dev-}requirements.txt ; \
        npm upgrade ; \
    else \
        npm ci ; \
    fi \
 && npm cache clean --force > /dev/null 2>&1 \
 && for _req_f in {,dev-}requirements.txt lib/*/{,dev-}requirements.txt; do \
        if [[ -f "${_req_f}" ]]; then \
            pip install --user --no-cache-dir -r "${_req_f}" ; \
        fi; \
    done \
 && for _py_pkg in lib/* ; do \
        pip install --user --no-cache-dir "${_py_pkg}" ; \
    done

FROM app as testing

# hadolint ignore=DL3003
RUN node --version \
 && pip --version \
 && python3 --version \
 && yarn --version \
 && cd "$APPHOME" \
 && for _node_pkg in packages/* ; do \
        ( \
            cd "${_node_pkg}" ; \
            npm run test ; \
        ); \
    done \
 && for _python_pkg in lib/* ; do \
        ( \
            cd "${_python_pkg}" ; \
            pytest ; \
        ); \
    done \
 && rm -rf /tmp/*

# Final stage
FROM testing as final

WORKDIR ${USERHOME}
