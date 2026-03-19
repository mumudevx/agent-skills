#Requires -Version 5.1
<#
.SYNOPSIS
    Install agent skills as symlinks into AI tool skill directories.

.PARAMETER Tool
    Target tool: claude, gemini, copilot, antigravity, all

.PARAMETER Skill
    Install only a specific skill (default: all skills)

.PARAMETER Uninstall
    Remove installed symlinks

.PARAMETER List
    List available skills

.EXAMPLE
    .\install.ps1 -Tool claude
    .\install.ps1 -Tool all
    .\install.ps1 -Tool gemini -Skill remotion
    .\install.ps1 -Uninstall -Tool claude
    .\install.ps1 -List
#>
param(
    [ValidateSet("claude", "gemini", "copilot", "antigravity", "all")]
    [string]$Tool,

    [string]$Skill,

    [switch]$Uninstall,

    [switch]$List
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# ─── Config ───────────────────────────────────────────────────────────────────
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ExcludeDirs = @(".git", ".github", "node_modules", "docs", "__pycache__")
$AllTools = @("claude", "gemini", "copilot", "antigravity")

$ToolDirs = @{
    claude      = Join-Path $HOME ".claude\skills"
    gemini      = Join-Path $HOME ".gemini\skills"
    copilot     = Join-Path $HOME ".copilot\skills"
    antigravity = Join-Path $HOME ".gemini\antigravity\skills"
}

# ─── Helpers ──────────────────────────────────────────────────────────────────
function Get-Skills {
    $skills = @()
    Get-ChildItem -Path $ScriptDir -Directory | ForEach-Object {
        $name = $_.Name
        if ($name -in $ExcludeDirs) { return }
        $skillMd = Join-Path $_.FullName "SKILL.md"
        if (Test-Path $skillMd) {
            $skills += $name
        }
    }
    return $skills
}

function Get-SkillDescription {
    param([string]$SkillName)
    $skillMd = Join-Path $ScriptDir "$SkillName\SKILL.md"
    $line = Get-Content $skillMd | Where-Object { $_ -match "^description:" } | Select-Object -First 1
    if ($line) {
        return ($line -replace "^description:\s*", "")
    }
    return "(no description)"
}

function Test-Symlink {
    param([string]$Path)
    if (-not (Test-Path $Path)) { return $false }
    $item = Get-Item $Path -Force
    return ($item.Attributes -band [System.IO.FileAttributes]::ReparsePoint) -ne 0
}

function Get-SymlinkTarget {
    param([string]$Path)
    $item = Get-Item $Path -Force
    if ($item.Target) { return $item.Target[0] }
    # Fallback for older PS versions
    return (cmd /c "dir `"$(Split-Path $Path)`" /al" 2>$null | Where-Object { $_ -match [regex]::Escape($item.Name) } | ForEach-Object {
        if ($_ -match '\[(.+)\]') { $matches[1] }
    })
}

# ─── Actions ──────────────────────────────────────────────────────────────────
function Show-Skills {
    $skills = Get-Skills
    if ($skills.Count -eq 0) {
        Write-Host "No skills found." -ForegroundColor Yellow
        return
    }
    Write-Host "Available skills:" -ForegroundColor Cyan
    Write-Host ""
    foreach ($s in $skills) {
        $desc = Get-SkillDescription $s
        Write-Host ("  {0,-25} {1}" -f $s, $desc)
    }
}

function Install-Skills {
    param(
        [string]$ToolName,
        [string]$FilterSkill
    )
    $targetDir = $ToolDirs[$ToolName]
    $skills = Get-Skills

    if ($FilterSkill) {
        if ($FilterSkill -notin $skills) {
            Write-Host "Error: Skill '$FilterSkill' not found." -ForegroundColor Red
            exit 1
        }
        $skills = @($FilterSkill)
    }

    if (-not (Test-Path $targetDir)) {
        New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
    }

    foreach ($s in $skills) {
        $src = Join-Path $ScriptDir $s
        $dest = Join-Path $targetDir $s

        if (Test-Symlink $dest) {
            $current = Get-SymlinkTarget $dest
            if ($current -eq $src) {
                Write-Host "  ~ $s — already installed" -ForegroundColor Yellow
                continue
            }
            else {
                Write-Host "  ! $s — symlink exists but points to $current, skipping" -ForegroundColor Yellow
                continue
            }
        }
        elseif (Test-Path $dest) {
            Write-Host "  x $s — real file/directory exists at $dest, skipping" -ForegroundColor Red
            continue
        }

        New-Item -ItemType SymbolicLink -Path $dest -Target $src -Force | Out-Null
        Write-Host "  + $s — installed" -ForegroundColor Green
    }

    Write-Host ""
    Write-Host "[$ToolName] Done." -ForegroundColor Cyan
}

function Uninstall-Skills {
    param(
        [string]$ToolName,
        [string]$FilterSkill
    )
    $targetDir = $ToolDirs[$ToolName]

    if (-not (Test-Path $targetDir)) {
        Write-Host "  Directory $targetDir does not exist, nothing to uninstall." -ForegroundColor Yellow
        return
    }

    $skills = Get-Skills
    if ($FilterSkill) {
        $skills = @($FilterSkill)
    }

    foreach ($s in $skills) {
        $dest = Join-Path $targetDir $s

        if (Test-Symlink $dest) {
            $current = Get-SymlinkTarget $dest
            $src = Join-Path $ScriptDir $s
            if ($current -eq $src) {
                Remove-Item $dest -Force
                Write-Host "  + $s — removed" -ForegroundColor Green
            }
            else {
                Write-Host "  ~ $s — symlink points elsewhere, skipping" -ForegroundColor Yellow
            }
        }
    }

    Write-Host ""
    Write-Host "[$ToolName] Done." -ForegroundColor Cyan
}

# ─── Execute ─────────────────────────────────────────────────────────────────
if ($List) {
    Show-Skills
    exit 0
}

if (-not $Tool) {
    Write-Host "Error: -Tool is required (claude, gemini, copilot, antigravity, all)" -ForegroundColor Red
    Write-Host ""
    Get-Help $MyInvocation.MyCommand.Path -Examples
    exit 1
}

if ($Tool -eq "all") {
    $targets = $AllTools
}
else {
    $targets = @($Tool)
}

foreach ($t in $targets) {
    Write-Host ""
    Write-Host "--- $t ---" -ForegroundColor Cyan
    if ($Uninstall) {
        Uninstall-Skills -ToolName $t -FilterSkill $Skill
    }
    else {
        Install-Skills -ToolName $t -FilterSkill $Skill
    }
}
