# TODO: change to HA image when available
ARG BUILD_FROM=ghcr.io/sairon/base:3.23
FROM ${BUILD_FROM}

# Set shell
SHELL ["/bin/ash", "-o", "pipefail", "-c"]

WORKDIR /usr/src

# Install rlwrap
ARG RLWRAP_VERSION=0.46.1
RUN apk add --no-cache --virtual .build-deps \
        build-base \
        readline-dev \
        ncurses-dev \
    && curl -L -s "https://github.com/hanslub42/rlwrap/releases/download/${RLWRAP_VERSION}/rlwrap-${RLWRAP_VERSION}.tar.gz" \
        | tar zxvf - -C /usr/src/ \
    && cd rlwrap-${RLWRAP_VERSION} \
    && ./configure \
    && make \
    && make install \
    && apk del .build-deps \
    && rm -rf /usr/src/*

# Install CLI
ARG BUILD_ARCH=amd64
ARG CLI_VERSION=4.46.0
RUN curl -Lfso /usr/bin/ha https://github.com/home-assistant/cli/releases/download/${CLI_VERSION}/ha_${BUILD_ARCH} \
    && chmod a+x /usr/bin/ha

COPY rootfs /
WORKDIR /

ARG BUILD_DATE="1970-01-01 00:00:00+00:00"
ARG BUILD_FROM
ARG BUILD_REPOSITORY
ARG BUILD_VERSION=0.0.0-local

LABEL \
    io.hass.type="cli" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.version="${BUILD_VERSION}" \
    org.opencontainers.image.created="${BUILD_DATE}" \
    org.opencontainers.image.version="${BUILD_VERSION}" \
    org.opencontainers.image.source="${BUILD_REPOSITORY}" \
    org.opencontainers.image.title="Home Assistant CLI Plugin" \
    org.opencontainers.image.description="Home Assistant Supervisor plugin for CLI" \
    org.opencontainers.image.authors="The Home Assistant Authors" \
    org.opencontainers.image.url="https://www.home-assistant.io/" \
    org.opencontainers.image.documentation="https://www.home-assistant.io/docs/" \
    org.opencontainers.image.licenses="Apache License 2.0"
