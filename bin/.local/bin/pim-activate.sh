#!/usr/bin/env bash
# pim-activate.sh — self-activate a PIM-eligible Azure role across a group of subscriptions.
#
# Usage:
#   pim-activate.sh [group] [role-name] [duration]
#
#   group       Name of a subscription group defined in the config file (default: "test")
#   role-name   Display name of the eligible role (default: "Epiroc - LZ - Contributor")
#   duration    ISO8601 duration (default: "PT8H" = 8 hours)
#
# Config:
#   Subscription groups are defined in $PIM_GROUPS_FILE
#   (default: ~/.config/pim/groups.conf), one group per line:
#
#     <group>=<subscription>[,<subscription>...]
#
#   Each <subscription> can be a subscription name or ID.
#
# Requires: az cli, logged in (az login), jq
set -euo pipefail

GROUP="${1:-test}"
ROLE_NAME="${2:-Epiroc - LZ - Contributor}"
DURATION="${3:-PT8H}"
JUSTIFICATION="${PIM_JUSTIFICATION:-Daily work on assigned project}"
GROUPS_FILE="${PIM_GROUPS_FILE:-$HOME/.config/pim/groups.conf}"

if [[ ! -f "${GROUPS_FILE}" ]]; then
  echo "PIM groups file not found: ${GROUPS_FILE}" >&2
  exit 1
fi

# Look up the comma-separated subscription list for the requested group.
SUBS_RAW=$(awk -F= -v g="${GROUP}" '
  /^[[:space:]]*#/ || /^[[:space:]]*$/ { next }
  {
    key = $1
    sub(/^[[:space:]]+/, "", key)
    sub(/[[:space:]]+$/, "", key)
    if (key == g) {
      val = $0
      sub(/^[^=]*=/, "", val)
      print val
      found = 1
      exit
    }
  }
  END { if (!found) exit 1 }
' "${GROUPS_FILE}") || {
  echo "Unknown PIM group '${GROUP}'. Available groups:" >&2
  awk -F= '!/^[[:space:]]*#/ && NF { print "  - " $1 }' "${GROUPS_FILE}" >&2
  exit 1
}

IFS=',' read -r -a SUBSCRIPTIONS <<< "${SUBS_RAW}"

PRINCIPAL_ID=$(az ad signed-in-user show --query id -o tsv)

# Activates ROLE_NAME on a single subscription's scope.
activate_for_subscription() {
  local sub="$1"
  local subscription_id scope role_definition_id eligible active request_name body

  subscription_id=$(az account show --subscription "${sub}" --query id -o tsv)
  scope="/subscriptions/${subscription_id}"

  echo "--- Subscription: ${sub} (${subscription_id}) ---"

  # 1. Find the role definition id for the requested role name in this scope.
  role_definition_id=$(az role definition list --name "${ROLE_NAME}" --scope "${scope}" \
    --query "[0].id" -o tsv)

  if [[ -z "${role_definition_id}" || "${role_definition_id}" == "None" ]]; then
    echo "Could not resolve role definition for '${ROLE_NAME}' on ${sub}." >&2
    return 1
  fi

  # 2. Confirm you actually have an eligible assignment for this role.
  eligible=$(az rest --method get \
    --url "https://management.azure.com${scope}/providers/Microsoft.Authorization/roleEligibilityScheduleInstances?api-version=2020-10-01&\$filter=principalId eq '${PRINCIPAL_ID}'" \
    --query "value[?roleDefinitionId=='${role_definition_id}'] | [0]" -o json)

  if [[ -z "${eligible}" || "${eligible}" == "null" ]]; then
    echo "No eligible assignment found for role '${ROLE_NAME}' on ${sub}." >&2
    return 1
  fi

  # 3. Check if already active — skip if so.
  active=$(az rest --method get \
    --url "https://management.azure.com${scope}/providers/Microsoft.Authorization/roleAssignmentScheduleInstances?api-version=2020-10-01&\$filter=principalId eq '${PRINCIPAL_ID}'" \
    --query "value[?roleDefinitionId=='${role_definition_id}'] | [0]" -o json)

  if [[ -n "${active}" && "${active}" != "null" ]]; then
    echo "Role '${ROLE_NAME}' is already active on ${sub}. Nothing to do."
    return 0
  fi

  # 4. Submit the self-activation request.
  request_name=$(uuidgen)
  body=$(jq -n \
    --arg principalId "${PRINCIPAL_ID}" \
    --arg roleDefinitionId "${role_definition_id}" \
    --arg justification "${JUSTIFICATION}" \
    --arg duration "${DURATION}" \
    '{
      properties: {
        principalId: $principalId,
        roleDefinitionId: $roleDefinitionId,
        requestType: "SelfActivate",
        justification: $justification,
        scheduleInfo: {
          startDateTime: (now | todate),
          expiration: {
            type: "AfterDuration",
            duration: $duration
          }
        }
      }
    }')

  echo "Activating '${ROLE_NAME}' for ${DURATION} on ${sub}..."
  az rest --method put \
    --url "https://management.azure.com${scope}/providers/Microsoft.Authorization/roleAssignmentScheduleRequests/${request_name}?api-version=2020-10-01" \
    --body "${body}" \
    --headers "Content-Type=application/json" >/dev/null

  echo "Activation request submitted for ${sub}."
}

echo "Group:     ${GROUP}"
echo "Principal: ${PRINCIPAL_ID}"
echo "Role:      ${ROLE_NAME}"
echo

STATUS=0
for sub in "${SUBSCRIPTIONS[@]}"; do
  sub="${sub#"${sub%%[![:space:]]*}"}" # trim leading whitespace
  sub="${sub%"${sub##*[![:space:]]}"}" # trim trailing whitespace
  [[ -z "${sub}" ]] && continue
  activate_for_subscription "${sub}" || STATUS=1
  echo
done

exit "${STATUS}"
