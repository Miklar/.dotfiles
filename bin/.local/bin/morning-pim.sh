#!/usr/bin/env bash
# morning-pim.sh — ensure Azure CLI session is valid, then self-activate PIM role.
set -euo pipefail

ROLE_NAME="${1:-Contributor}"
DURATION="${2:-PT8H}"

# 1. Check if the cached session/token is still valid (no prompt if so).
if ! az account get-access-token --output none 2>/dev/null; then
  echo "Session expired or not logged in — launching login..."
  # Device code avoids opening a browser session tied to a specific window;
  # drop --use-device-code if you prefer the normal browser popup.
  az login --use-device-code
fi

# 2. Activate PIM role using the persistent session.
"$(dirname "$0")/pim-activate.sh" "${ROLE_NAME}" "${DURATION}"
