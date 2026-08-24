# pim-activate

Self-activate an Azure PIM-eligible role across a group of subscriptions,
without clicking through the Azure Portal for each one.

Two equivalent implementations are provided:

- **`pim-activate.sh`** — Bash, for macOS/Linux shells.
- **`pim-activate.ps1`** — PowerShell (pwsh 7+), for Windows or any platform
  with PowerShell Core installed.

Both scripts read the same config file and environment variables, and behave
identically: resolve the role definition on each subscription, confirm you
have an eligible assignment, skip subscriptions where the role is already
active, and otherwise submit a self-activation request for the requested
duration.

## Requirements

| | Bash (`pim-activate.sh`) | PowerShell (`pim-activate.ps1`) |
|---|---|---|
| Shell | bash | pwsh 7+ |
| Azure CLI | `az`, logged in (`az login`) | `az`, logged in (`az login`) |
| JSON tool | `jq` | none (uses `ConvertTo-Json`/`ConvertFrom-Json`) |
| Other | `uuidgen` | none (uses `[guid]::NewGuid()`) |

## Usage

```bash
# Bash
pim-activate.sh [group] [role-name] [duration]

# PowerShell
./pim-activate.ps1 [group] [role-name] [duration]
```

All three arguments are positional and optional:

| Argument | Default | Description |
|---|---|---|
| `group` | `test` | Name of a subscription group defined in the config file. |
| `role-name` | `Epiroc - LZ - Contributor` | Display name of the eligible role to activate. |
| `duration` | `PT8H` | ISO 8601 duration for the activation (e.g. `PT4H` = 4 hours). |

Examples:

```bash
pim-activate.sh                                            # test group, default role, 8h
pim-activate.sh prod                                       # prod group, default role, 8h
pim-activate.sh prod "Epiroc - LZ - Owner" PT4H             # prod group, custom role, 4h

./pim-activate.ps1 prod
./pim-activate.ps1 prod "Epiroc - LZ - Owner" PT4H
```

## Config file

Subscription groups are defined in a config file, one group per line:

```
<group>=<subscription>[,<subscription>...]
```

- Each `<subscription>` can be a subscription **name or ID** — anything
  `az account show --subscription <x>` accepts.
- Lines starting with `#` and blank lines are ignored.

Default location: `~/.config/pim/groups.conf` (see
`pim/.config/pim/groups.conf` in this repo). Override with the
`PIM_GROUPS_FILE` environment variable — respected by both scripts.

Example:

```
test=epiroc-digitalprogram-test,epiroc-evrypart-test
prod=epiroc-prod-sub-1,epiroc-prod-sub-2
```

If an unknown group is passed, both scripts print the list of available
groups from the config file and exit non-zero.

## Environment variables

| Variable | Default | Description |
|---|---|---|
| `PIM_GROUPS_FILE` | `~/.config/pim/groups.conf` | Path to the subscription groups config file. |
| `PIM_JUSTIFICATION` | `Daily work on assigned project` | Justification text submitted with the activation request. |

## What it does, per subscription

1. Resolve the role definition ID for `role-name` at the subscription scope.
2. Confirm you have an **eligible** assignment for that role (via
   `roleEligibilityScheduleInstances`, using `asTarget()` rather than a
   `principalId` filter — the latter unreliably omits eligible assignments on
   some subscriptions).
3. Check whether the role is already **active** (via
   `roleAssignmentScheduleInstances`); if so, skip with a message.
4. Otherwise, submit a `SelfActivate` request via
   `roleAssignmentScheduleRequests` for the given `duration`.

Failures on one subscription don't stop the others — both scripts continue
through the full group and exit non-zero at the end if any subscription
failed.

## Related

- **`morning-pim.sh`** — ensures the `az` session is valid (prompts
  `az login --use-device-code` if not), then calls `pim-activate.sh`. There
  is currently no PowerShell equivalent of `morning-pim.sh`.
