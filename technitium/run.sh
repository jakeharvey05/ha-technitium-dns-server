#!/usr/bin/env bash
# ----------------------------------------------------------------------------
# Home Assistant add-on entrypoint for Technitium DNS Server.
#
# Reads the add-on options (/data/options.json) and translates the ones that
# apply in host-network mode into the DNS_SERVER_* environment variables the
# official Technitium image understands, then hands off to the upstream app.
#
# Technitium stores its own config/zones in /config (the add-on config dir),
# which persists across restarts and version updates. Deeper settings — above
# all the DNS listen addresses ("DNS Server Local End Points", e.g. binding
# :53 to a dedicated LAN IP) — are configured in the web console and kept there.
# ----------------------------------------------------------------------------
set -euo pipefail

OPTIONS_FILE="/data/options.json"
CONFIG_DIR="/config"

# opt KEY -> prints the option value, or empty string if absent/null.
opt() {
  if [ -f "${OPTIONS_FILE}" ]; then
    jq -r --arg k "$1" '.[$k] // empty' "${OPTIONS_FILE}"
  fi
}

# export_if VARNAME VALUE -> export only when VALUE is non-empty, so unset
# options fall back to Technitium's own defaults rather than blanking them.
export_if() {
  if [ -n "${2:-}" ]; then
    export "$1=$2"
  fi
}

# Web console bind address + ports (the only add-on options). Everything else
# is configured in Technitium's web console and persists in /config.
export_if DNS_SERVER_WEB_SERVICE_LOCAL_ADDRESSES "$(opt web_service_local_addresses)"
export_if DNS_SERVER_WEB_SERVICE_HTTP_PORT "$(opt web_service_http_port)"
export_if DNS_SERVER_WEB_SERVICE_HTTPS_PORT "$(opt web_service_https_port)"
export_if DNS_SERVER_WEB_SERVICE_ENABLE_HTTPS "$(opt web_service_enable_https)"

mkdir -p "${CONFIG_DIR}"

echo "[technitium-addon] Starting Technitium DNS Server; config dir: ${CONFIG_DIR}"
echo "[technitium-addon] Web console local addresses: ${DNS_SERVER_WEB_SERVICE_LOCAL_ADDRESSES:-<default>}"

# Hand off to the upstream entrypoint. The config directory is passed as the
# argument (matches the upstream image's default CMD of /etc/dns).
exec /usr/bin/dotnet /opt/technitium/dns/DnsServerApp.dll "${CONFIG_DIR}"
