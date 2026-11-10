# Technitium DNS Server

The official Technitium DNS Server Docker image, packaged as a Home Assistant
add-on. It runs on host networking so it can serve your whole network —
optionally on its own dedicated LAN IP. (No clash with HA, which uses :8123,
not :53.)

## Optional: give DNS its own dedicated IP

HA add-ons can't have their own container IP, so the clean way to a dedicated
DNS address is a second IP on the host:

1. **HA** → Settings → System → Network → your interface → **Add address**
   (e.g. `10.155.53.53/24`), save.
2. **Technitium console** (`http://<HA-IP>:5380`, login `admin` / `admin` —
   change it) → Settings → General → **DNS Server Local End Points** → replace
   `0.0.0.0:53` / `[::]:53` with `10.155.53.53:53` → Save.
3. Point your router/clients at `10.155.53.53`.

Skip this and DNS just answers on every IP the host has.

## Settings

- The **admin console** IP/ports are in the add-on **Configuration** tab.
- Everything else (zones, blocking, DoH/DoT, forwarders, DHCP…) is set in
  Technitium's own web console and persists in `/config` — included in HA
  snapshots.

## Updates

A daily GitHub Action bumps the add-on to each new **stable** Technitium
release, so HA shows an **Update** automatically. Your `/config` is untouched.
