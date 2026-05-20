[CmdletBinding()]
param(
    [switch]$Strict
)

$ErrorActionPreference = "Stop"

$RepoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$Failures = New-Object System.Collections.Generic.List[string]
$Warnings = New-Object System.Collections.Generic.List[string]
$Infos = New-Object System.Collections.Generic.List[string]

function Add-Result {
    param(
        [ValidateSet("INFO", "WARN", "FAIL")]
        [string]$Level,
        [string]$Message
    )

    switch ($Level) {
        "INFO" { $Infos.Add($Message) | Out-Null }
        "WARN" { $Warnings.Add($Message) | Out-Null }
        "FAIL" { $Failures.Add($Message) | Out-Null }
    }
}

function Test-CommandExists {
    param([string]$Name)
    return $null -ne (Get-Command $Name -ErrorAction SilentlyContinue)
}

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

Set-Location $RepoRoot
Add-Result INFO "Repository root: $RepoRoot"
Add-Result INFO "Runtime state under ~/.codex is intentionally out of scope for this repository healthcheck."

if (-not (Test-CommandExists "git")) {
    Add-Result FAIL "git is not available on PATH."
} else {
    $insideGit = (& git rev-parse --is-inside-work-tree 2>$null)
    if ($LASTEXITCODE -ne 0 -or $insideGit -ne "true") {
        Add-Result FAIL "Current directory is not a git worktree."
    } else {
        Add-Result INFO "Git worktree detected."
    }
}

$requiredDirs = @(
    "skills",
    ".codex/agents",
    "codex-global",
    "docs/decisions",
    "docs/runbooks",
    "docs/operations",
    "docs/audits",
    "docs/evolution",
    "docs/lessons",
    "docs/patterns",
    "scripts"
)

foreach ($dir in $requiredDirs) {
    if (Test-Path $dir) {
        Add-Result INFO "Directory exists: $dir"
    } else {
        Add-Result FAIL "Required directory missing: $dir"
    }
}

$requiredDocs = @(
    "README.md",
    ".gitattributes",
    "LICENSE",
    "CONTRIBUTING.md",
    "CHANGELOG.md",
    "SECURITY.md",
    "CODE_OF_CONDUCT.md",
    "workspace-manifest.json",
    "docs/README.md",
    "docs/capability-inventory.md",
    "docs/skills-provenance.md",
    "docs/agentic-controls.md",
    "docs/continuous-evolution.md",
    "docs/skill-template.md",
    "docs/agent-template.md",
    "docs/subagents-policy.md",
    "docs/subagents-lifecycle.md",
    "docs/self-improvement-lifecycle.md",
    "docs/lessons/TEMPLATE.md",
    "docs/patterns/TEMPLATE.md",
    "docs/patterns/rejected/README.md",
    "docs/audits/TEMPLATE.md",
    "docs/decisions/TEMPLATE.md",
    "docs/archive/README.md",
    "docs/runbooks/setup-windows.md",
    "docs/runbooks/setup-macos.md"
)

foreach ($doc in $requiredDocs) {
    if (Test-Path $doc) {
        Add-Result INFO "Required file exists: $doc"
    } else {
        Add-Result FAIL "Required file missing: $doc"
    }
}

$repoSkills = @(Get-ChildItem "skills" -Directory -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Name | Sort-Object)
$skillFiles = @($repoSkills | ForEach-Object { Join-Path (Join-Path "skills" $_) "SKILL.md" })

if ($repoSkills.Count -eq 0) {
    Add-Result FAIL "No skills found under skills/."
} else {
    Add-Result INFO "Skills discovered: $($repoSkills.Count)"
}

foreach ($skillFile in $skillFiles) {
    if (-not (Test-Path $skillFile)) {
        Add-Result FAIL "$skillFile is missing."
        continue
    }

    $lines = @(Get-Content $skillFile)
    if ($lines.Count -lt 4) {
        Add-Result FAIL "$skillFile is too short to contain valid skill frontmatter."
        continue
    }
    if ($lines[0] -ne "---") {
        Add-Result FAIL "$skillFile frontmatter must start with ---."
    }

    $endIndex = -1
    for ($i = 1; $i -lt [Math]::Min($lines.Count, 60); $i++) {
        if ($lines[$i] -eq "---") {
            $endIndex = $i
            break
        }
    }

    if ($endIndex -lt 0) {
        Add-Result FAIL "$skillFile frontmatter closing delimiter not found in first 60 lines."
        continue
    }

    $frontmatter = $lines[1..($endIndex - 1)]
    if (-not ($frontmatter | Where-Object { $_ -match '^name:\s*"?[^"]+"?\s*$' })) {
        Add-Result FAIL "$skillFile missing simple name field in frontmatter."
    }
    if (-not ($frontmatter | Where-Object { $_ -match '^description:\s*.+' })) {
        Add-Result FAIL "$skillFile missing description field in frontmatter."
    }
}

$agentFiles = @(Get-ChildItem ".codex/agents" -Filter "*.toml" -File -ErrorAction SilentlyContinue | Sort-Object Name)
$repoAgents = @($agentFiles | ForEach-Object { [IO.Path]::GetFileNameWithoutExtension($_.Name) })
if ($agentFiles.Count -eq 0) {
    Add-Result FAIL "No custom agent TOML files found under .codex/agents/."
} else {
    Add-Result INFO "Custom agents discovered: $($agentFiles.Count)"
}

foreach ($agentFile in $agentFiles) {
    $relative = Resolve-Path -Relative $agentFile.FullName
    $content = Get-Content -Raw $agentFile.FullName
    foreach ($field in @("name", "description", "model", "model_reasoning_effort", "sandbox_mode", "developer_instructions")) {
        if ($content -notmatch "(?m)^$field\s*=") {
            Add-Result FAIL "$relative missing required field: $field."
        }
    }
}

$manifest = $null
if (Test-Path "workspace-manifest.json") {
    try {
        $manifest = Get-Content -Raw "workspace-manifest.json" | ConvertFrom-Json
        Add-Result INFO "workspace-manifest.json parsed successfully."
    } catch {
        Add-Result FAIL "workspace-manifest.json is not valid JSON: $($_.Exception.Message)"
    }
} else {
    Add-Result FAIL "workspace-manifest.json is missing."
}

if ($null -ne $manifest) {
    $allowedStatuses = @("core", "optional", "curated", "review", "deprecated", "archived")
    $installBlockedStatuses = @("curated", "review", "deprecated", "archived")

    foreach ($statusProperty in $manifest.statuses.PSObject.Properties) {
        if ($allowedStatuses -notcontains $statusProperty.Name) {
            Add-Result FAIL "Manifest declares unsupported status: $($statusProperty.Name)"
        }
    }

    $manifestSkills = @($manifest.skills.PSObject.Properties.Name | Sort-Object)
    $manifestAgents = @($manifest.agents.PSObject.Properties.Name | Sort-Object)

    foreach ($skill in $repoSkills) {
        if ($manifestSkills -notcontains $skill) {
            Add-Result FAIL "Manifest does not classify skill: $skill"
        }
    }
    foreach ($skill in $manifestSkills) {
        if ($repoSkills -notcontains $skill) {
            Add-Result FAIL "Manifest references missing skill directory: $skill"
        }
        $status = Get-ObjectPropertyValue -Object $manifest.skills -Name $skill
        if ($allowedStatuses -notcontains $status) {
            Add-Result FAIL "Manifest skill '$skill' has unsupported status '$status'."
        }
    }

    foreach ($agent in $repoAgents) {
        if ($manifestAgents -notcontains $agent) {
            Add-Result FAIL "Manifest does not classify agent: $agent"
        }
    }
    foreach ($agent in $manifestAgents) {
        if ($repoAgents -notcontains $agent) {
            Add-Result FAIL "Manifest references missing agent file: $agent"
        }
        $status = Get-ObjectPropertyValue -Object $manifest.agents -Name $agent
        if ($allowedStatuses -notcontains $status) {
            Add-Result FAIL "Manifest agent '$agent' has unsupported status '$status'."
        }
    }

    $profileNames = @($manifest.profiles.PSObject.Properties.Name)
    foreach ($profileProperty in $manifest.profiles.PSObject.Properties) {
        $profileName = $profileProperty.Name
        $profile = $profileProperty.Value

        if ($null -ne $profile.extends) {
            foreach ($parent in @($profile.extends)) {
                if ($profileNames -notcontains $parent) {
                    Add-Result FAIL "Profile '$profileName' extends unknown profile '$parent'."
                }
            }
        }

        if ($null -ne $profile.skills) {
            foreach ($skill in @($profile.skills)) {
                $status = Get-ObjectPropertyValue -Object $manifest.skills -Name $skill
                if ($null -eq $status) {
                    Add-Result FAIL "Profile '$profileName' references unknown skill '$skill'."
                } elseif ($installBlockedStatuses -contains $status) {
                    Add-Result FAIL "Profile '$profileName' references non-installable skill '$skill' with status '$status'."
                }
            }
        }

        if ($null -ne $profile.agents) {
            foreach ($agent in @($profile.agents)) {
                $status = Get-ObjectPropertyValue -Object $manifest.agents -Name $agent
                if ($null -eq $status) {
                    Add-Result FAIL "Profile '$profileName' references unknown agent '$agent'."
                } elseif ($installBlockedStatuses -contains $status) {
                    Add-Result FAIL "Profile '$profileName' references non-installable agent '$agent' with status '$status'."
                }
            }
        }
    }
}

if (Test-Path "docs/capability-inventory.md") {
    $inventory = Get-Content -Raw "docs/capability-inventory.md"
    foreach ($skill in $repoSkills) {
        if ($inventory -notmatch [Regex]::Escape($skill)) {
            Add-Result FAIL "Capability inventory does not mention skill: $skill"
        }
    }
    foreach ($agent in $repoAgents) {
        if ($inventory -notmatch [Regex]::Escape($agent)) {
            Add-Result FAIL "Capability inventory does not mention agent: $agent"
        }
    }
} else {
    Add-Result FAIL "docs/capability-inventory.md is missing."
}

$migrateCli = "skills/migrate-to-codex/scripts/cli.py"
if ((Test-Path $migrateCli) -and (Test-CommandExists "python")) {
    $validationOutput = & python $migrateCli --validate-target . 2>&1
    if ($LASTEXITCODE -ne 0) {
        Add-Result FAIL "migrate-to-codex validation failed: $($validationOutput -join ' ')"
    } else {
        Add-Result INFO "migrate-to-codex validation passed."
    }
} elseif (-not (Test-CommandExists "python")) {
    Add-Result WARN "python is not available; skipped migrate-to-codex validation."
} else {
    Add-Result WARN "migrate-to-codex validator not found at $migrateCli."
}

$skillValidator = "scripts/validate-skills.py"
if ((Test-Path $skillValidator) -and (Test-CommandExists "python")) {
    $skillValidationOutput = & python $skillValidator --strict 2>&1
    if ($LASTEXITCODE -ne 0) {
        Add-Result FAIL "Repository skill validation failed: $($skillValidationOutput -join ' ')"
    } else {
        Add-Result INFO "Repository skill validation passed."
    }
} elseif (-not (Test-CommandExists "python")) {
    Add-Result WARN "python is not available; skipped repository skill validation."
} else {
    Add-Result WARN "Repository skill validator not found at $skillValidator."
}

$evolutionValidator = "scripts/evolve-workspace.py"
if ((Test-Path $evolutionValidator) -and (Test-CommandExists "python")) {
    $evolutionValidationOutput = & python $evolutionValidator --strict 2>&1
    if ($LASTEXITCODE -ne 0) {
        Add-Result FAIL "Continuous evolution validation failed: $($evolutionValidationOutput -join ' ')"
    } else {
        Add-Result INFO "Continuous evolution validation passed."
    }
} elseif (-not (Test-CommandExists "python")) {
    Add-Result WARN "python is not available; skipped continuous evolution validation."
} else {
    Add-Result WARN "Continuous evolution validator not found at $evolutionValidator."
}

$scaffoldValidator = "scripts/scaffold-capability.py"
if ((Test-Path $scaffoldValidator) -and (Test-CommandExists "python")) {
    $scaffoldValidationOutput = & python -m py_compile $scaffoldValidator 2>&1
    if ($LASTEXITCODE -ne 0) {
        Add-Result FAIL "Capability scaffold validation failed: $($scaffoldValidationOutput -join ' ')"
    } else {
        Add-Result INFO "Capability scaffold validation passed."
    }
} elseif (-not (Test-CommandExists "python")) {
    Add-Result WARN "python is not available; skipped capability scaffold validation."
} else {
    Add-Result WARN "Capability scaffold validator not found at $scaffoldValidator."
}

foreach ($installer in @("scripts/install-workspace.ps1", "scripts/install-workspace.sh")) {
    if (-not (Test-Path $installer)) {
        Add-Result FAIL "Installer missing: $installer"
        continue
    }
    $content = Get-Content -Raw $installer
    if ($content -notmatch "workspace-manifest\.json") {
        Add-Result FAIL "$installer does not use workspace-manifest.json."
    }
    if ($installer -like "*.ps1" -and $content -notmatch "SupportsShouldProcess") {
        Add-Result FAIL "$installer must support PowerShell WhatIf."
    }
    if ($installer -like "*.sh" -and $content -notmatch "--dry-run") {
        Add-Result FAIL "$installer must support --dry-run."
    }
}

if (Test-CommandExists "git") {
    $trackedFiles = @(& git ls-files)
    $secretPatterns = @(
        "-----BEGIN (RSA |DSA |EC |OPENSSH )?PRIVATE KEY-----",
        "ghp_[A-Za-z0-9_]{20,}",
        "github_pat_[A-Za-z0-9_]{20,}",
        "dapi[a-f0-9]{32}",
        "xox[baprs]-[A-Za-z0-9-]{10,}",
        "sk-[A-Za-z0-9]{20,}"
    )

    foreach ($file in $trackedFiles) {
        if (-not (Test-Path $file)) {
            continue
        }
        $item = Get-Item $file
        if ($item.Length -gt 1048576) {
            continue
        }
        $text = Get-Content -Raw $file -ErrorAction SilentlyContinue
        foreach ($pattern in $secretPatterns) {
            if ($text -match $pattern) {
                Add-Result FAIL "Potential secret pattern found in tracked file: $file"
                break
            }
        }
    }
}

$largeFiles = @(Get-ChildItem -Recurse -File | Where-Object {
    $_.FullName -notmatch '\\.git\\' -and $_.Length -gt 5MB
})
foreach ($file in $largeFiles) {
    $relative = Resolve-Path -Relative $file.FullName
    Add-Result WARN "Large file over 5MB: $relative ($([Math]::Round($file.Length / 1MB, 2)) MB)"
}

Write-Host "Workspace repository healthcheck"
Write-Host "================================"
foreach ($message in $Infos) {
    Write-Host "[INFO] $message"
}
foreach ($message in $Warnings) {
    Write-Host "[WARN] $message"
}
foreach ($message in $Failures) {
    Write-Host "[FAIL] $message"
}

Write-Host ""
Write-Host "Summary: $($Infos.Count) info, $($Warnings.Count) warnings, $($Failures.Count) failures."

if ($Failures.Count -gt 0 -or ($Strict -and $Warnings.Count -gt 0)) {
    exit 1
}

exit 0
