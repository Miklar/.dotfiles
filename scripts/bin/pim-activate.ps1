#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Self-activate a PIM-eligible Azure role across a group of subscriptions.

.DESCRIPTION
    PowerShell port of pim-activate.sh. Behaves identically: same config file
    format, same environment variables, same activation logic (resolve role
    definition, confirm eligibility, skip if already active, submit a
    self-activation request).

.PARAMETER Group
    Name of a subscription group defined in the config file (default: "test").

.PARAMETER RoleName
    Display name of the eligible role (default: "Epiroc - LZ - Contributor").

.PARAMETER Duration
    ISO8601 duration (default: "PT8H" = 8 hours).

.EXAMPLE
    ./pim-activate.ps1
    ./pim-activate.ps1 prod "Epiroc - LZ - Contributor" PT4H

.NOTES
    Config:
      Subscription groups are defined in $env:PIM_GROUPS_FILE
      (default: ~/.config/pim/groups.conf), one group per line:

        <group>=<subscription>[,<subscription>...]

      Each <subscription> can be a subscription name or ID.

    Requires: az cli (logged in via `az login`), PowerShell 7+ (pwsh).
    No jq dependency — uses PowerShell's built-in JSON cmdlets instead.
#>

[CmdletBinding()]
param(
    [Parameter(Position = 0)]
    [string]$Group = "test",

    [Parameter(Position = 1)]
    [string]$RoleName = "Epiroc - LZ - Contributor",

    [Parameter(Position = 2)]
    [string]$Duration = "PT8H"
)

$ErrorActionPreference = "Stop"

$Justification = if ($env:PIM_JUSTIFICATION) { $env:PIM_JUSTIFICATION } else { "Daily work on assigned project" }
$GroupsFile = if ($env:PIM_GROUPS_FILE) { $env:PIM_GROUPS_FILE } else { Join-Path $HOME ".config/pim/groups.conf" }

if (-not (Test-Path -LiteralPath $GroupsFile)) {
    Write-Error "PIM groups file not found: $GroupsFile"
    exit 1
}

# Look up the comma-separated subscription list for the requested group.
function Get-GroupSubscriptions {
    param([string]$GroupsFile, [string]$GroupName)

    $available = @()
    foreach ($line in Get-Content -LiteralPath $GroupsFile) {
        $trimmed = $line.Trim()
        if ($trimmed -eq "" -or $trimmed.StartsWith("#")) { continue }

        $idx = $trimmed.IndexOf("=")
        if ($idx -lt 0) { continue }

        $key = $trimmed.Substring(0, $idx).Trim()
        $val = $trimmed.Substring($idx + 1).Trim()
        $available += $key

        if ($key -eq $GroupName) {
            return $val
        }
    }

    Write-Host "Unknown PIM group '$GroupName'. Available groups:" -ForegroundColor Red
    foreach ($g in $available) { Write-Host "  - $g" -ForegroundColor Red }
    exit 1
}

$subsRaw = Get-GroupSubscriptions -GroupsFile $GroupsFile -GroupName $Group
$Subscriptions = $subsRaw -split "," | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "" }

$PrincipalId = (az ad signed-in-user show --query id -o tsv).Trim()

# Activates $RoleName on a single subscription's scope. Returns $true on
# success (including "already active"), $false on failure.
function Invoke-PimActivation {
    param(
        [string]$Sub,
        [string]$RoleName,
        [string]$Duration,
        [string]$Justification,
        [string]$PrincipalId
    )

    $subscriptionId = (az account show --subscription $Sub --query id -o tsv).Trim()
    $scope = "/subscriptions/$subscriptionId"

    Write-Host "--- Subscription: $Sub ($subscriptionId) ---"

    # 1. Find the role definition id for the requested role name in this scope.
    $roleDefinitionId = (az role definition list --name $RoleName --scope $scope --query "[0].id" -o tsv).Trim()

    if ([string]::IsNullOrWhiteSpace($roleDefinitionId) -or $roleDefinitionId -eq "None") {
        Write-Error "Could not resolve role definition for '$RoleName' on $Sub."
        return $false
    }

    # 2. Confirm you actually have an eligible assignment for this role.
    #    Use asTarget() rather than a principalId filter: the scoped endpoint's
    #    principalId filter unreliably omits eligible assignments for some subs.
    $eligibleUrl = "https://management.azure.com$scope/providers/Microsoft.Authorization/roleEligibilityScheduleInstances?api-version=2020-10-01&`$filter=asTarget()"
    $eligibleJson = az rest --method get --url $eligibleUrl `
        --query "value[?properties.roleDefinitionId=='$roleDefinitionId'] | [0]" -o json
    $eligible = $eligibleJson | ConvertFrom-Json

    if ($null -eq $eligible) {
        Write-Error "No eligible assignment found for role '$RoleName' on $Sub."
        return $false
    }

    # 3. Check if already active — skip if so.
    $activeUrl = "https://management.azure.com$scope/providers/Microsoft.Authorization/roleAssignmentScheduleInstances?api-version=2020-10-01&`$filter=asTarget()"
    $activeJson = az rest --method get --url $activeUrl `
        --query "value[?properties.roleDefinitionId=='$roleDefinitionId' && properties.scope=='$scope'] | [0]" -o json
    $active = $activeJson | ConvertFrom-Json

    if ($null -ne $active) {
        Write-Host "Role '$RoleName' is already active on $Sub. Nothing to do."
        return $true
    }

    # 4. Submit the self-activation request.
    $requestName = [guid]::NewGuid().ToString()
    $body = [ordered]@{
        properties = [ordered]@{
            principalId     = $PrincipalId
            roleDefinitionId = $roleDefinitionId
            requestType     = "SelfActivate"
            justification   = $Justification
            scheduleInfo    = [ordered]@{
                startDateTime = (Get-Date).ToUniversalTime().ToString("o")
                expiration    = [ordered]@{
                    type     = "AfterDuration"
                    duration = $Duration
                }
            }
        }
    } | ConvertTo-Json -Depth 10 -Compress

    Write-Host "Activating '$RoleName' for $Duration on $Sub..."

    $putUrl = "https://management.azure.com$scope/providers/Microsoft.Authorization/roleAssignmentScheduleRequests/$requestName`?api-version=2020-10-01"

    # Write body to a temp file to avoid shell-quoting issues with `az rest --body`.
    $bodyFile = New-TemporaryFile
    try {
        Set-Content -LiteralPath $bodyFile -Value $body -NoNewline

        $putResponse = az rest --method put --url $putUrl `
            --body "@$bodyFile" --headers "Content-Type=application/json" 2>&1
        $putStatus = $LASTEXITCODE

        if ($putStatus -ne 0) {
            $putResponseText = $putResponse | Out-String
            if ($putResponseText -match "RoleAssignmentExists") {
                Write-Host "Role '$RoleName' is already active on $Sub. Nothing to do."
                return $true
            }
            Write-Error "Failed to activate '$RoleName' on $Sub`:`n$putResponseText"
            return $false
        }
    }
    finally {
        Remove-Item -LiteralPath $bodyFile -ErrorAction SilentlyContinue
    }

    Write-Host "Activation request submitted for $Sub."
    return $true
}

Write-Host "Group:     $Group"
Write-Host "Principal: $PrincipalId"
Write-Host "Role:      $RoleName"
Write-Host ""

$exitCode = 0
foreach ($sub in $Subscriptions) {
    $ok = Invoke-PimActivation -Sub $sub -RoleName $RoleName -Duration $Duration `
        -Justification $Justification -PrincipalId $PrincipalId
    if (-not $ok) { $exitCode = 1 }
    Write-Host ""
}

exit $exitCode
