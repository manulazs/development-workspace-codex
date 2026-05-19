[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [string]$CodexHome = (Join-Path $env:USERPROFILE ".codex"),
    [switch]$SkipSkills,
    [switch]$SkipAgents
)

$ErrorActionPreference = "Stop"

$RepoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$SkillsSource = Join-Path $RepoRoot "skills"
$AgentsSource = Join-Path $RepoRoot ".codex/agents"
$SkillsTarget = Join-Path $CodexHome "skills"
$AgentsTarget = Join-Path $CodexHome "agents"

function Ensure-Directory {
    param([string]$Path)
    if (-not (Test-Path $Path)) {
        if ($PSCmdlet.ShouldProcess($Path, "Create directory")) {
            New-Item -ItemType Directory -Force -Path $Path | Out-Null
        }
    }
}

function Copy-DirectoryExact {
    param(
        [string]$Source,
        [string]$Target
    )

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
        [string]$Source,
        [string]$Target
    )

    if ($PSCmdlet.ShouldProcess($Target, "Copy file from $Source")) {
        Copy-Item -Path $Source -Destination $Target -Force
    }
}

Set-Location $RepoRoot

if (-not (Test-Path $SkillsSource)) {
    throw "Missing source directory: $SkillsSource"
}
if (-not (Test-Path $AgentsSource)) {
    throw "Missing source directory: $AgentsSource"
}

Write-Host "Workspace install"
Write-Host "================="
Write-Host "Repo root : $RepoRoot"
Write-Host "Codex home: $CodexHome"

if (-not $SkipSkills) {
    Ensure-Directory $SkillsTarget
    $skills = @(Get-ChildItem $SkillsSource -Directory | Sort-Object Name)
    foreach ($skill in $skills) {
        $target = Join-Path $SkillsTarget $skill.Name
        Copy-DirectoryExact -Source $skill.FullName -Target $target
    }
    Write-Host "Skills planned/copied: $($skills.Count)"
} else {
    Write-Host "Skills skipped."
}

if (-not $SkipAgents) {
    Ensure-Directory $AgentsTarget
    $agents = @(Get-ChildItem $AgentsSource -Filter "*.toml" -File | Sort-Object Name)
    foreach ($agent in $agents) {
        $target = Join-Path $AgentsTarget $agent.Name
        Copy-FileExact -Source $agent.FullName -Target $target
    }
    Write-Host "Agents planned/copied: $($agents.Count)"
} else {
    Write-Host "Agents skipped."
}

Write-Host ""
Write-Host "Recommended validation:"
Write-Host "  powershell -NoProfile -ExecutionPolicy Bypass -File scripts/healthcheck.ps1"
Write-Host ""
Write-Host "Safe preview:"
Write-Host "  powershell -NoProfile -ExecutionPolicy Bypass -File scripts/install-workspace.ps1 -WhatIf"
