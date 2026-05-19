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

function Get-ReadmeSectionItems {
    param(
        [string]$Path,
        [string]$StartHeading,
        [string]$EndHeading
    )

    if (-not (Test-Path $Path)) {
        return @()
    }

    $lines = Get-Content $Path
    $inside = $false
    $items = New-Object System.Collections.Generic.List[string]

    foreach ($line in $lines) {
        if ($line -eq $StartHeading) {
            $inside = $true
            continue
        }
        if ($inside -and $line -eq $EndHeading) {
            break
        }
        if ($inside -and $line -match '^- `([^`]+)`') {
            $items.Add($Matches[1]) | Out-Null
        }
    }

    return $items.ToArray()
}

Set-Location $RepoRoot
Add-Result INFO "Repository root: $RepoRoot"

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
    "docs/README.md",
    "docs/capability-inventory.md",
    "docs/subagents-policy.md",
    "docs/subagents-lifecycle.md",
    "docs/self-improvement-lifecycle.md",
    "docs/lessons/TEMPLATE.md",
    "docs/patterns/TEMPLATE.md",
    "docs/patterns/rejected/README.md",
    "docs/audits/TEMPLATE.md",
    "docs/decisions/TEMPLATE.md",
    "docs/runbooks/setup-windows.md",
    "docs/runbooks/setup-macos.md"
)

foreach ($doc in $requiredDocs) {
    if (Test-Path $doc) {
        Add-Result INFO "Required doc exists: $doc"
    } else {
        Add-Result FAIL "Required doc missing: $doc"
    }
}

$skillFiles = @(Get-ChildItem "skills" -Directory -ErrorAction SilentlyContinue | ForEach-Object {
    Join-Path $_.FullName "SKILL.md"
} | Where-Object { Test-Path $_ })

if ($skillFiles.Count -eq 0) {
    Add-Result FAIL "No skills with SKILL.md found under skills/."
} else {
    Add-Result INFO "Skills discovered: $($skillFiles.Count)"
}

foreach ($skillFile in $skillFiles) {
    $relative = Resolve-Path -Relative $skillFile
    $lines = @(Get-Content $skillFile)

    if ($lines.Count -lt 4) {
        Add-Result FAIL "$relative is too short to contain valid skill frontmatter."
        continue
    }

    if ($lines[0] -ne "---") {
        Add-Result FAIL "$relative frontmatter must start with ---."
    }

    $endIndex = -1
    for ($i = 1; $i -lt [Math]::Min($lines.Count, 60); $i++) {
        if ($lines[$i] -eq "---") {
            $endIndex = $i
            break
        }
    }

    if ($endIndex -lt 0) {
        Add-Result FAIL "$relative frontmatter closing delimiter not found in first 60 lines."
        continue
    }

    $frontmatter = $lines[1..($endIndex - 1)]
    if (-not ($frontmatter | Where-Object { $_ -match '^name:\s*"?[^"]+"?\s*$' })) {
        Add-Result FAIL "$relative missing simple name field in frontmatter."
    }
    if (-not ($frontmatter | Where-Object { $_ -match '^description:\s*.+' })) {
        Add-Result FAIL "$relative missing description field in frontmatter."
    }
}

$agentFiles = @(Get-ChildItem ".codex/agents" -Filter "*.toml" -File -ErrorAction SilentlyContinue)
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

if (Test-Path "scripts/migrate-to-codex/scripts/cli.py") {
    Add-Result WARN "Unexpected migrate-to-codex script path under scripts/. Expected under skills/."
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

$quickValidate = Join-Path $env:USERPROFILE ".codex/skills/.system/skill-creator/scripts/quick_validate.py"
if ((Test-Path $quickValidate) -and (Test-CommandExists "python")) {
    $previousErrorActionPreference = $ErrorActionPreference
    $ErrorActionPreference = "Continue"
    $yamlOutput = & python -c "import yaml" 2>&1
    $yamlExitCode = $LASTEXITCODE
    $ErrorActionPreference = $previousErrorActionPreference
    if ($yamlExitCode -ne 0) {
        Add-Result WARN "PyYAML is not installed for the active python. quick_validate.py would fail; install PyYAML or use a managed Python environment."
    } else {
        Add-Result INFO "PyYAML is available for quick_validate.py."
    }
} else {
    Add-Result WARN "System skill quick_validate.py not available; using built-in lightweight skill checks only."
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

$repoSkills = @(Get-ChildItem "skills" -Directory | Select-Object -ExpandProperty Name | Sort-Object)
$readmeSkills = @(Get-ReadmeSectionItems -Path "README.md" -StartHeading "## Current Skills" -EndHeading "## Current Custom Agents" | Sort-Object)
if ($readmeSkills.Count -gt 0) {
    $diff = @(Compare-Object $repoSkills $readmeSkills)
    if ($diff.Count -gt 0) {
        Add-Result WARN "README Current Skills list differs from skills/ directory. Prefer docs/capability-inventory.md as source of truth."
    } else {
        Add-Result INFO "README Current Skills list matches skills/ directory."
    }
} else {
    Add-Result INFO "README delegates skill inventory to docs/capability-inventory.md."
}

if (Test-Path "docs/capability-inventory.md") {
    $inventory = Get-Content -Raw "docs/capability-inventory.md"
    foreach ($skill in $repoSkills) {
        if ($inventory -notmatch [Regex]::Escape($skill)) {
            Add-Result WARN "Capability inventory does not mention skill: $skill"
        }
    }
    foreach ($agent in $agentFiles) {
        $name = [IO.Path]::GetFileNameWithoutExtension($agent.Name)
        if ($inventory -notmatch [Regex]::Escape($name)) {
            Add-Result WARN "Capability inventory does not mention agent: $name"
        }
    }
} else {
    Add-Result FAIL "docs/capability-inventory.md is missing."
}

if (-not $env:GITHUB_ACTIONS) {
    $codexSkills = Join-Path $env:USERPROFILE ".codex/skills"
    $codexAgents = Join-Path $env:USERPROFILE ".codex/agents"

    if (Test-Path $codexSkills) {
        $installedSkills = @(Get-ChildItem $codexSkills -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -ne ".system" } | Select-Object -ExpandProperty Name)
        $missingSkills = @($repoSkills | Where-Object { $_ -notin $installedSkills })
        if ($missingSkills.Count -gt 0) {
            Add-Result WARN "Repo skills not installed in ~/.codex/skills: $($missingSkills -join ', ')"
        } else {
            Add-Result INFO "All repo skills are installed in ~/.codex/skills."
        }
    } else {
        Add-Result WARN "~/.codex/skills does not exist."
    }

    if (Test-Path $codexAgents) {
        $installedAgents = @(Get-ChildItem $codexAgents -Filter "*.toml" -File -ErrorAction SilentlyContinue | ForEach-Object { [IO.Path]::GetFileNameWithoutExtension($_.Name) })
        $repoAgents = @($agentFiles | ForEach-Object { [IO.Path]::GetFileNameWithoutExtension($_.Name) })
        $missingAgents = @($repoAgents | Where-Object { $_ -notin $installedAgents })
        if ($missingAgents.Count -gt 0) {
            Add-Result WARN "Repo agents not installed in ~/.codex/agents: $($missingAgents -join ', ')"
        } else {
            Add-Result INFO "All repo agents are installed in ~/.codex/agents."
        }
    } else {
        Add-Result WARN "~/.codex/agents does not exist."
    }
}

Write-Host "Workspace healthcheck"
Write-Host "====================="

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
