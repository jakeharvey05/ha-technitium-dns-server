# Technitium DNS Server

The official Technitium DNS Server Docker image, packaged as a Home Assistant
add-on.

## Installation

1. In Home Assistant go to **Settings → Add-ons → Add-on Store**.
2. Open the **⋮** menu (top-right) → **Repositories**.
3. Add this repository's URL:

   ```
   https://github.com/jakeharvey05/ha-technitium
   ```

4. Install **Technitium DNS Server** from the store.

See [technitium/DOCS.md](technitium/DOCS.md) for setup — including the
dedicated-IP walkthrough — and the add-on options.

## How updates work

The add-on is pinned to a specific stable `technitium/dns-server` image tag. A
scheduled GitHub Action
([`update-technitium.yaml`](.github/workflows/update-technitium.yaml)) checks
Docker Hub daily and, when a newer **stable** release exists, bumps the pinned
tag and the add-on `version` and commits to `main`. Home Assistant then shows an
**Update** button. Pre-releases and the `latest` tag are ignored.
