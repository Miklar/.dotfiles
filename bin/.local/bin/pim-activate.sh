#!/usr/bin/env bash
# pim-activate.sh — self-activate a PIM-eligible Azure role on the current subscription.
#
# Usage:
#   pim-activate.sh [role-name] [duration]
#
#   role-name   Display name of the eligible role (default: "Contributor")
#   duration    ISO8601 duration (default: "PT8H" = 8 hours)
#
# Requires: az cli, logged in (az login), jq
set -euo pipefail

ROLE_NAME="${1:-Contributor}"
DURATION="${2:-PT8H}"
JUSTIFICATION="${PIM_JUSTIFICATION:-Daily work on assigned project}"

SUBSCRIPTION_ID=$(az account show --query id -o tsv)
SCOPE="/subscriptions/${SUBSCRIPTION_ID}"
PRINCIPAL_ID=$(az ad signed-in-user show --query id -o tsv)

echo "Subscription: ${SUBSCRIPTION_ID}"
echo "Principal:    ${PRINCIPAL_ID}"
echo "Role:         ${ROLE_NAME}"

# 1. Find the role definition id for the requested role name in this scope.
ROLE_DEFINITION_ID=$(az role definition list --name "${ROLE_NAME}" --scope "${SCOPE}" \
  --query "[0].id" -o tsv)

if [[ -z "${ROLE_DEFINITION_ID}" || "${ROLE_DEFINITION_ID}" == "None" ]]; then
  echo "Could not resolve role definition for '${ROLE_NAME}'." >&2
  exit 1
fi

# 2. Confirm you actually have an eligible (not already active) assignment for this role.
ELIGIBLE=$(az rest --method get \
  --url "https://management.azure.com${SCOPE}/providers/Microsoft.Authorization/roleEligibilityScheduleInstances?api-version=2020-10-01&\$filter=principalId eq '${PRINCIPAL_ID}'" \
  --query "value[?roleDefinitionId=='${ROLE_DEFINITION_ID}'] | [0]" -o json)

if [[ -z "${ELIGIBLE}" || "${ELIGIBLE}" == "null" ]]; then
  echo "No eligible assignment found for role '${ROLE_NAME}' on this subscription." >&2
  exit 1
fi

# 3. Check if already active — skip if so.
ACTIVE=$(az rest --method get \
  --url "https://management.azure.com${SCOPE}/providers/Microsoft.Authorization/roleAssignmentScheduleInstances?api-version=2020-10-01&\$filter=principalId eq '${PRINCIPAL_ID}'" \
  --query "value[?roleDefinitionId=='${ROLE_DEFINITION_ID}'] | [0]" -o json)

if [[ -n "${ACTIVE}" && "${ACTIVE}" != "null" ]]; then
  echo "Role '${ROLE_NAME}' is already active. Nothing to do."
  exit 0
fi

# 4. Submit the self-activation request.
REQUEST_NAME=$(uuidgen)
BODY=$(jq -n \
  --arg principalId "${PRINCIPAL_ID}" \
  --arg roleDefinitionId "${ROLE_DEFINITION_ID}" \
  --arg scope "${SCOPE}" \
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

echo "Activating role for ${DURATION}..."
az rest --method put \
  --url "https://management.azure.com${SCOPE}/providers/Microsoft.Authorization/roleAssignmentScheduleRequests/${REQUEST_NAME}?api-version=2020-10-01" \
  --body "${BODY}" \
  --headers "Content-Type=application/json"

echo "Activation request submitted. It may take a few seconds to become active."
