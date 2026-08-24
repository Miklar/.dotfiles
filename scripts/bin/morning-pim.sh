#!/usr/bin/env bash
# morning-pim.sh — ensure Azure CLI session is valid, then self-activate PIM role(s).
#
# Usage:
#   morning-pim.sh [group] [role-name] [duration]
set -euo pipefail

GROUP="${1:-test}"
ROLE_NAME="${2:-Epiroc - LZ - Contributor}"
DURATION="${3:-PT8H}"

# 1. Check if the cached session/token is still valid (no prompt if so).
if ! az account get-access-token --output none 2>/dev/null; then
  echo "Session expired or not logged in — launching login..."
  # Device code avoids opening a browser session tied to a specific window;
  # drop --use-device-code if you prefer the normal browser popup.
  az login --use-device-code
fi

# 2. Activate PIM role(s) for the group using the persistent session.
"$(dirname "$0")/pim-activate.sh" "${GROUP}" "${ROLE_NAME}" "${DURATION}"
