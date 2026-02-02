FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

EXPOSE 18789

# Install core packages and Node 22 from NodeSource
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       ca-certificates \
       curl \
       gnupg \
       build-essential \
       python3 \
       git \
    && curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y --no-install-recommends nodejs \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user for safer development runs
RUN useradd -m -s /bin/bash node \
    && mkdir -p /app \
    && chown node:node /app

RUN npm install -g openclaw

WORKDIR /app
USER node

# Default to an interactive shell so you can attach with docker run/exec
CMD ["bash"]
