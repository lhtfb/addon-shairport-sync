ARG BUILD_FROM=hassioaddons/base:8.0.1
FROM ${BUILD_FROM}

ENV LANG C.UTF-8

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apk -U add \
        git \
        build-base \
        autoconf \
        automake \
        libtool \
        alsa-lib-dev \
        libdaemon-dev \
        popt-dev \
        libressl-dev \
        soxr-dev \
        avahi-dev \
        libconfig-dev \
        libpopt-dev \
        libasound2-dev \
        avahi-daemon \
        libavahi-client-dev \
        libssl-dev 
        libsoxr-dev \
        libplist-dev \
        libsodium-dev \
        libavutil-dev \
        libavcodec-dev \
        libavformat-dev \
        uuid-dev \
        libgcrypt-dev \
        xxd \
        
 && cd /root \
 && git clone https://github.com/mikebrady/shairport-sync.git \
 && cd shairport-sync \
 && autoreconf -i -f \
 && ./configure \
        --with-alsa \
        --with-pipe \
        --with-avahi \
        --with-ssl=openssl \
        --with-soxr \
        --with-metadata \
        --with-airplay-2 \
 && make \
 && make install \
 && cd / \
 && apk --purge del \
        git \
        build-base \
        autoconf \
        automake \
        libtool \
        alsa-lib-dev \
        libdaemon-dev \
        popt-dev \
        libressl-dev \
        soxr-dev \
        avahi-dev \
        libconfig-dev \
 && apk add \
        dbus \
        alsa-lib \
        alsa-plugins-pulse \
        libdaemon \
        popt \
        libressl \
        soxr \
        avahi \
        libconfig \
 && rm -rf \
        /etc/ssl \
        /var/cache/apk/* \
        /lib/apk/db/* \
        /root/shairport-sync

# Copy root filesystem
COPY rootfs /

# Build arguments
ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_REF
ARG BUILD_VERSION

# Labels
LABEL \
    io.hass.name="Shairport Sync" \
    io.hass.description="Shairport Sync for Hass.io" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="Maido Käära <m@maido.io>"
