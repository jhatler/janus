# Copyright 2021 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# checkov:skip=CKV_DOCKER_3:Handled by devcontainer
# checkov:skip=CKV_DOCKER_2:Not applicable

# Use a multi-stage docker build to limit production dependencies.

FROM node:22-bookworm AS BUILD

WORKDIR /home/node

# Copy application dependency manifests to the container image.
# A wildcard is used to ensure copying both package.json AND package-lock.json (when available).
# Copying this first prevents re-running npm install on every code change.
COPY package*.json ./

# Install build dependencies.
RUN npm ci

# Now copy all the code so we can compile
COPY . ./

RUN npm run compile

FROM node:22-bookworm

SHELL ["/bin/bash", "-o", "pipefail", "-e", "-c"]
ENV SHELL=/bin/bash
ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /home/node

# hadolint ignore=DL3003
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      python3-pip=23.0.1+dfsg-1 \
 && apt-get autoremove --purge -y \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && find /var/cache/apt -type f -print0 | xargs -0 rm -f

COPY package*.json ./
COPY --from=BUILD /home/node/build build
COPY requirements.txt ./
RUN npm ci --only=production && \
    python3 -m pip install --no-cache-dir --require-hashes -r requirements.txt

ENV NODE_ENV "production"

# Run the web service on container startup.
CMD [ "npm", "--no-update-notifier", "run", "start" ]
