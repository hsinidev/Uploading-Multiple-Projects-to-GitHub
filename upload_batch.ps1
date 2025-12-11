<#
.SYNOPSIS
    Automates the initialization, remote creation, and push for multiple Git repositories.

.DESCRIPTION
    This script iterates through a list of project folders (defined in project_list.py),
    initializes Git repositories, creates remote repositories on GitHub, and pushes the code.

.PARAMETER GitHubUser
    Your GitHub username.

.PARAMETER ParentDir
    The root directory containing your project folders.

.EXAMPLE
    .\upload_batch.ps1 -GitHubUser "octocat" -ParentDir "C:\Projects"
#>

param (
    [string]$GitHubUser,
    [string]$ParentDir
)

# --- Configuration & Validation ---

Write-Host "--- 🚀 Batch GitHub Uploader ---" -ForegroundColor cyan

# 1. Interactive Inputs (if parameters not provided)
if ([string]::IsNullOrWhiteSpace($GitHubUser)) {
    $GitHubUser = Read-Host "Enter your GitHub Username"
}

if ([string]::IsNullOrWhiteSpace($ParentDir)) {
    $ParentDir = Read-Host "Enter the full path to your projects folder"
}

# Trim potential surrounding quotes from path if pasted from "Copy as path"
$ParentDir = $ParentDir.Trim('"').Trim("'")

if (-not (Test-Path $ParentDir -PathType Container)) {
    Write-Host "❌ FATAL ERROR: Directory '$ParentDir' does not exist." -ForegroundColor Red
    exit 1
}

# 2. Check Prerequisites
Write-Host "Checking prerequisites..." -ForegroundColor Gray

if (-not (Get-Command "gh" -ErrorAction SilentlyContinue)) {
    Write-Host "❌ Error: GitHub CLI ('gh') is not installed or not in PATH." -ForegroundColor Red
    exit 1
}

if (-not (Get-Command "python" -ErrorAction SilentlyContinue)) {
    Write-Host "❌ Error: Python is not installed or not in PATH." -ForegroundColor Red
    exit 1
}

# Check gh auth status (simple check)
$authStatus = gh auth status 2>&1
if ($authStatus -match "not logged in") {
    Write-Host "⚠️  You correspond to be logged out of GitHub CLI." -ForegroundColor Yellow
    Write-Host "Please run 'gh auth login' first." -ForegroundColor Yellow
    exit 1
}

# 3. Get Project List
Write-Host "Reading project list from python..." -ForegroundColor Gray
try {
    # Ensure project_list.py exists in current directory
    if (-not (Test-Path ".\project_list.py")) {
        throw "project_list.py not found in current directory."
    }

    $ProjectNameListString = python project_list.py -c "from project_list import get_project_list_for_powershell; print(get_project_list_for_powershell())"
    
    if (-not $ProjectNameListString) {
        throw "Python script returned empty output."
    }

    # Convert the string output back into a PowerShell array
    $ProjectNames = Invoke-Expression $ProjectNameListString
}
catch {
    Write-Host "❌ Error retrieving project list: $_" -ForegroundColor Red
    exit 1
}

$count = $ProjectNames.Count
Write-Host "✅ Found $count projects to process." -ForegroundColor Green
Start-Sleep -Seconds 1

# --- Automation Loop ---

Set-Location $ParentDir

foreach ($PROJECT_NAME in $ProjectNames) {
    
    $SafeName = $PROJECT_NAME # For display
    Write-Host "`n--------------------------------------------------" -ForegroundColor DarkGray
    Write-Host "📂 Processing: $SafeName" -ForegroundColor White
    
    $ProjectDir = Join-Path $ParentDir $PROJECT_NAME

    # Check if folder exists
    if (-not (Test-Path $ProjectDir -PathType Container)) {
        Write-Host "   ⏭️  SKIPPING: Folder not found." -ForegroundColor DarkGray
        continue
    }

    Push-Location $ProjectDir

    try {
        # Git Init
        if (-not (Test-Path .\.git)) {
            Write-Host "   🔨 Initializing Git repo..." -ForegroundColor Gray
            git init -b main | Out-Null
            git add .
            git commit -m "Initial commit for $SafeName" | Out-Null
        }
        else {
            Write-Host "   ℹ️  Git already initialized." -ForegroundColor Gray
        }

        # Remote Config
        $RemoteURL = "https://github.com/$GitHubUser/$PROJECT_NAME.git"
        if (git remote get-url origin -ErrorAction SilentlyContinue) {
            git remote set-url origin $RemoteURL | Out-Null
        }
        else {
            git remote add origin $RemoteURL | Out-Null
        }

        # GitHub Creation & Push
        Write-Host "   ☁️  Syncing to GitHub..." -ForegroundColor Gray
        
        # Try creating (will fail if exists, which is fine)
        gh repo create "$GitHubUser/$PROJECT_NAME" --public --source=. --remote=origin 2>&1 | Out-Null
        
        # Push changes
        git push -u origin main 2>&1 | Out-Null
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "   ✅ SUCCESS" -ForegroundColor Green
        }
        else {
            # Attempt force push if simple push failed (e.g. repo existed with different history)
            Write-Host "   ⚠️  Standard push failed. Attempting force push..." -ForegroundColor Yellow
            git push -u origin main --force 2>&1 | Out-Null
            if ($LASTEXITCODE -eq 0) {
                Write-Host "   ✅ FORCED SUCCESS" -ForegroundColor Green
            }
            else {
                Write-Host "   ❌ FAILED to push." -ForegroundColor Red
            }
        }

    }
    catch {
        Write-Host "   ❌ Unexpected Error: $_" -ForegroundColor Red
    }
    finally {
        Pop-Location
    }
}

Write-Host "`n--------------------------------------------------" -ForegroundColor DarkGray
Write-Host "🎉 Batch processing complete!" -ForegroundColor Cyan
Write-Host "Powered by HSINI MOHAMED" -ForegroundColor Magenta