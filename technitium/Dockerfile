# Pinned to a specific stable Technitium DNS Server release.
# The official image is a multi-arch manifest (amd64 / arm64 / armv7), so the
# Home Assistant builder automatically pulls the right CPU variant on-device.
#
# IMPORTANT: the tag below and `version:` in config.yaml are kept in lockstep by
# .github/workflows/update-technitium.yaml. Do not edit the version by hand
# unless you also update config.yaml.
ARG BUILD_FROM=technitium/dns-server:15.6.2
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

# The upstream image is Debian/Ubuntu based and reads its own DNS_SERVER_* env
# vars at startup. We only add `jq` so the entrypoint can translate the add-on
# options (/data/options.json) into those env vars.
# hadolint ignore=DL3008
RUN apt-get update \
    && apt-get install -y --no-install-recommends jq \
    && rm -rf /var/lib/apt/lists/*

COPY run.sh /run.sh
RUN chmod +x /run.sh

# Home Assistant add-on labels
ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_DESCRIPTION
ARG BUILD_NAME
ARG BUILD_REF
ARG BUILD_REPOSITORY
ARG BUILD_VERSION
LABEL \
    io.hass.name="${BUILD_NAME}" \
    io.hass.description="${BUILD_DESCRIPTION}" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version="${BUILD_VERSION}" \
    org.opencontainers.image.title="${BUILD_NAME}" \
    org.opencontainers.image.description="${BUILD_DESCRIPTION}" \
    org.opencontainers.image.source="https://github.com/${BUILD_REPOSITORY}" \
    org.opencontainers.image.created="${BUILD_DATE}" \
    org.opencontainers.image.revision="${BUILD_REF}" \
    org.opencontainers.image.version="${BUILD_VERSION}"

ENTRYPOINT []
CMD [ "/run.sh" ]
