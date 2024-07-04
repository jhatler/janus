#checkov:skip=CKV_DOCKER_2:Not applicable
#checkov:skip=CKV_DOCKER_3:Not applicable
#checkov:skip=CKV_DOCKER_7:False positive

# ubuntu:22.04
ARG CONTAINER_REPO=ubuntu
ARG CONTAINER_TAG="@sha256:19478ce7fc2ffbce89df29fea5725a8d12e57de52eb9ea570890dc5852aac1ac"
ARG CONTAINER_IMAGE="${CONTAINER_REPO}${CONTAINER_TAG}"

ARG FUNCTION_DIR="/function"

# hadolint ignore=DL3006
FROM ${CONTAINER_IMAGE} as base
ARG TARGETARCH

SHELL ["/bin/bash", "-o", "pipefail", "-e", "-c"]
ENV SHELL=/bin/bash
ENV DEBIAN_FRONTEND=noninteractive

# Install Apt Packages
RUN apt-get update \
 && apt-get install --no-install-recommends -y \
        python3-pip=22.0.2+dfsg-1ubuntu0.4 \
 && apt-get autoremove --purge -y \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && find /var/cache/apt -type f -print0 | xargs -0 rm -f

# Update Pip
RUN python3 -m pip install --no-cache-dir --upgrade \
        setuptools==70.2.0 \
        wheel==0.43.0 \
        pip==24.1.1

FROM base as builder
ARG FUNCTION_DIR

RUN mkdir -p ${FUNCTION_DIR}
COPY *.py ${FUNCTION_DIR}/
COPY requirements.txt ${FUNCTION_DIR}/
COPY handlers ${FUNCTION_DIR}/handlers
COPY workflows ${FUNCTION_DIR}/workflows

# Install Python Packages
RUN python3 -m pip install \
        --target ${FUNCTION_DIR} \
        --no-cache-dir \
        -r ${FUNCTION_DIR}/requirements.txt

FROM base as runtime
ARG FUNCTION_DIR

# Set working directory to function root directory
WORKDIR ${FUNCTION_DIR}

# Copy in the built dependencies
COPY --from=builder ${FUNCTION_DIR} ${FUNCTION_DIR}

# Set runtime interface client as default command for the container runtime
ENTRYPOINT [ "/usr/bin/python3", "-m", "awslambdaric" ]

# Pass the name of the function handler as an argument to the runtime
CMD [ "lambda_function.incoming" ]
