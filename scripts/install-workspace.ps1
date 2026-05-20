[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [string]$CodexHome = (Join-Path $env:USERPROFILE ".codex"),
    [string]$Profile = "minimal",
    [switch]$ListProfiles,
    [switch]$SkipSkills,
    [switch]$SkipAgents,
    [switch]$Force
)

$ErrorActionPreference = "Stop"

$RepoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$ManifestPath = Join-Path $RepoRoot "workspace-manifest.json"
$SkillsSource = Join-Path $RepoRoot "skills"
$AgentsSource = Join-Path $RepoRoot ".codex/agents"
$SkillsTarget = Join-Path $CodexHome "skills"
$AgentsTarget = Join-Path $CodexHome "agents"
$BlockedInstallStatuses = @("curated", "review", "deprecated", "archived")

function Get-ObjectPropertyValue {
    param(
        [Parameter(Mandatory = $true)]$Object,
        [Parameter(Mandatory = $true)][string]$Name
    )

    $property = $Object.PSObject.Properties[$Name]
    if ($null -eq $property) {
        return $null
    }

    return $property.Value
}

function Add-UniqueValue {
    param(
        [System.Collections.Generic.List[string]]$List,
        [AllowEmptyString()][string]$Value
    )

    if ([string]::IsNullOrWhiteSpace($Value)) {
        return
    }

    if (-not $List.Contains($Value)) {
        $List.Add($Value) | Out-Null
    }
}

function Ensure-Directory {
    param([Parameter(Mandatory = $true)][string]$Path)

    if (-not (Test-Path $Path)) {
        if ($PSCmdlet.ShouldProcess($Path, "Create directory")) {
            New-Item -ItemType Directory -Force -Path $Path | Out-Null
        }
    }
}

function Copy-DirectoryExact {
    param(
        [Parameter(Mandatory = $true)][string]$Source,
        [Parameter(Mandatory = $true)][string]$Target
    )

    if ((Test-Path $Target) -and -not $Force) {
        Write-Host "[skip] existing directory without -Force: $Target"
        return
    }

    if ($PSCmdlet.ShouldProcess($Target, "Copy directory contents from $Source")) {
        if (-not (Test-Path $Target)) {
            New-Item -ItemType Directory -Force -Path $Target | Out-Null
        }
        Get-ChildItem -LiteralPath $Source -Force | ForEach-Object {
            Copy-Item -LiteralPath $_.FullName -Destination $Target -Recurse -Force
        }
    }
}

function Copy-FileExact {
    param(
        [Parameter(Mandatory = $true)][string]$Source,
        [Parameter(Mandatory = $true)][string]$Target
    )

    if ((Test-Path $Target) -and -not $Force) {
        Write-Host "[skip] existing file without -Force: $Target"
        return
    }

    if ($PSCmdlet.ShouldProcess($Target, "Copy file from $Source")) {
        $targetDirectory = Split-Path -Parent $Target
        if (-not (Test-Path $targetDirectory)) {
            New-Item -ItemType Directory -Force -Path $targetDirectory | Out-Null
        }
        Copy-Item -LiteralPath $Source -Destination $Target -Force
    }
}

function Test-InstallableCapability {
    param(
        [Parameter(Mandatory = $true)][string]$Kind,
        [Parameter(Mandatory = $true)][string]$Name
    )

    $collection = if ($Kind -eq "skill") { $Manifest.skills } else { $Manifest.agents }
    $status = Get-ObjectPropertyValue -Object $collection -Name $Name
    if ($null -eq $status) {
        throw "Profile '$Profile' references unknown ${Kind}: $Name"
    }
    if ($BlockedInstallStatuses -contains $status) {
        throw "Profile '$Profile' references ${Kind} '$Name' with non-installable status '$status'. Review/curated/deprecated/archived capabilities must be adopted manually."
    }
}

function Resolve-AdoptionProfile {
    param(
        [Parameter(Mandatory = $true)][string]$Name,
        [hashtable]$Seen = @{}
    )

    if ($Seen.ContainsKey($Name)) {
        throw "Profile cycle detected at '$Name'."
    }
    $Seen[$Name] = $true

    $profileDefinition = Get-ObjectPropertyValue -Object $Manifest.profiles -Name $Name
    if ($null -eq $profileDefinition) {
        throw "Unknown profile '$Name'. Use -ListProfiles to inspect available profiles."
    }

    $skills = New-Object System.Collections.Generic.List[string]
    $agents = New-Object System.Collections.Generic.List[string]

    if ($null -ne $profileDefinition.extends) {
        foreach ($parentName in @($profileDefinition.extends)) {
            $parentSelection = Resolve-AdoptionProfile -Name $parentName -Seen $Seen.Clone()
            foreach ($skill in $parentSelection.Skills) {
                Add-UniqueValue -List $skills -Value $skill
            }
            foreach ($agent in $parentSelection.Agents) {
                Add-UniqueValue -List $agents -Value $agent
            }
        }
    }

    if ($null -ne $profileDefinition.skills) {
        foreach ($skill in @($profileDefinition.skills)) {
            Test-InstallableCapability -Kind "skill" -Name $skill
            Add-UniqueValue -List $skills -Value $skill
        }
    }

    if ($null -ne $profileDefinition.agents) {
        foreach ($agent in @($profileDefinition.agents)) {
            Test-InstallableCapability -Kind "agent" -Name $agent
            Add-UniqueValue -List $agents -Value $agent
        }
    }

    return [PSCustomObject]@{
        Skills = $skills.ToArray()
        Agents = $agents.ToArray()
    }
}

Set-Location $RepoRoot

if (-not (Test-Path $ManifestPath)) {
    throw "Missing manifest: $ManifestPath"
}
if (-not (Test-Path $SkillsSource)) {
    throw "Missing source directory: $SkillsSource"
}
if (-not (Test-Path $AgentsSource)) {
    throw "Missing source directory: $AgentsSource"
}

$Manifest = Get-Content -Raw $ManifestPath | ConvertFrom-Json

if ($ListProfiles) {
    Write-Host "Available adoption profiles"
    Write-Host "==========================="
    foreach ($profileProperty in $Manifest.profiles.PSObject.Properties) {
        Write-Host "$($profileProperty.Name): $($profileProperty.Value.description)"
    }
    exit 0
}

$selection = Resolve-AdoptionProfile -Name $Profile

Write-Host "Workspace install preview/execution"
Write-Host "==================================="
Write-Host "Repo root : $RepoRoot"
Write-Host "Codex home: $CodexHome"
Write-Host "Profile   : $Profile"
Write-Host ""
Write-Host "This repository is a portable template. It does not verify or require any existing local Codex runtime state."
Write-Host "codex-global/AGENTS.md is a source template; adapt it before copying into a consumer runtime."
Write-Host "Existing runtime files are skipped unless -Force is provided."
Write-Host ""

if (-not $SkipSkills) {
    if ($selection.Skills.Count -gt 0) {
        Ensure-Directory $SkillsTarget
    }
    foreach ($skill in $selection.Skills) {
        $source = Join-Path $SkillsSource $skill
        $target = Join-Path $SkillsTarget $skill
        if (-not (Test-Path $source)) {
            throw "Profile '$Profile' selected missing skill directory: $skill"
        }
        Copy-DirectoryExact -Source $source -Target $target
    }
    Write-Host "Skills planned/copied: $($selection.Skills.Count)"
} else {
    Write-Host "Skills skipped."
}

if (-not $SkipAgents) {
    if ($selection.Agents.Count -gt 0) {
        Ensure-Directory $AgentsTarget
    }
    foreach ($agent in $selection.Agents) {
        $source = Join-Path $AgentsSource "$agent.toml"
        $target = Join-Path $AgentsTarget "$agent.toml"
        if (-not (Test-Path $source)) {
            throw "Profile '$Profile' selected missing agent file: $agent"
        }
        Copy-FileExact -Source $source -Target $target
    }
    Write-Host "Agents planned/copied: $($selection.Agents.Count)"
} else {
    Write-Host "Agents skipped."
}

Write-Host ""
Write-Host "Repository validation:"
Write-Host "  powershell -NoProfile -ExecutionPolicy Bypass -File scripts/healthcheck.ps1 -Strict"
Write-Host "  python scripts/validate-skills.py --strict"
Write-Host "  python scripts/evolve-workspace.py --strict"
Write-Host ""
Write-Host "Safe preview examples:"
Write-Host "  powershell -NoProfile -ExecutionPolicy Bypass -File scripts/install-workspace.ps1 -Profile governed-codex -WhatIf"
Write-Host "  powershell -NoProfile -ExecutionPolicy Bypass -File scripts/install-workspace.ps1 -Profile full-reviewed -WhatIf"
Write-Host "  powershell -NoProfile -ExecutionPolicy Bypass -File scripts/install-workspace.ps1 -ListProfiles"
