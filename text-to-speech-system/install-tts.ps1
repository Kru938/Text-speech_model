# Text-to-Speech Global Deployment Script
# Run as Administrator for full installation

param([switch]$Uninstall)

$installPath = "$env:USERPROFILE\TextToSpeech"
$userScriptsPath = "$env:USERPROFILE\Documents\WindowsPowerShell\Scripts"

function Test-AdminRights {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Install-TTS {
    Write-Host "Installing Text-to-Speech System..." -ForegroundColor Green
    
    # Create installation directory
    if (-not (Test-Path $installPath)) {
        New-Item -ItemType Directory -Path $installPath -Force | Out-Null
        Write-Host "Created installation directory: $installPath" -ForegroundColor Cyan
    }
    
    # Create user scripts directory
    if (-not (Test-Path $userScriptsPath)) {
        New-Item -ItemType Directory -Path $userScriptsPath -Force | Out-Null
        Write-Host "Created user scripts directory: $userScriptsPath" -ForegroundColor Cyan
    }
    
    # Copy main scripts
    $currentDir = $PSScriptRoot
    if (-not $currentDir) { $currentDir = Split-Path -Parent $MyInvocation.MyCommand.Path }
    if (-not $currentDir) { $currentDir = Get-Location }
    
    Copy-Item "$currentDir\text-to-speech-reader.ps1" "$installPath\" -Force -ErrorAction SilentlyContinue
    Copy-Item "$currentDir\quick-read.ps1" "$installPath\" -Force -ErrorAction SilentlyContinue
    Copy-Item "$currentDir\tts-popup.ps1" "$installPath\" -Force -ErrorAction SilentlyContinue
    Write-Host "Scripts copied to installation directory" -ForegroundColor Cyan
    
    # Create command aliases in user scripts
    $aliasScript = @"
# Text-to-Speech Aliases
function tts { & "$installPath\text-to-speech-reader.ps1" @args }
function speak { & "$installPath\quick-read.ps1" @args }
function read-clip { & "$installPath\quick-read.ps1" }
function tts-popup { & "$installPath\tts-popup.ps1" }
"@
    
    $aliasScript | Out-File "$userScriptsPath\tts-aliases.ps1" -Encoding UTF8
    Write-Host "Created command aliases: tts, speak, read-clip" -ForegroundColor Cyan
    
    # Add to PowerShell profile
    $profilePath = $PROFILE.CurrentUserAllHosts
    $profileDir = Split-Path -Parent $profilePath
    
    if (-not (Test-Path $profileDir)) {
        New-Item -ItemType Directory -Path $profileDir -Force | Out-Null
    }
    
    $profileContent = ""
    if (Test-Path $profilePath) {
        $profileContent = Get-Content $profilePath -Raw
    }
    
    $ttsProfileAddition = @"

# Text-to-Speech Integration
if (Test-Path "$userScriptsPath\tts-aliases.ps1") {
    . "$userScriptsPath\tts-aliases.ps1"
}
"@
    
    if ($profileContent -notmatch "Text-to-Speech Integration") {
        $ttsProfileAddition | Add-Content $profilePath -Encoding UTF8
        Write-Host "Added to PowerShell profile: $profilePath" -ForegroundColor Cyan
    }
    
    # Create desktop shortcuts
    $shell = New-Object -ComObject WScript.Shell
    
    # Quick Read shortcut
    $shortcut = $shell.CreateShortcut("$env:USERPROFILE\Desktop\Quick Read.lnk")
    $shortcut.TargetPath = "powershell.exe"
    $shortcut.Arguments = "-WindowStyle Hidden -Command `"& '$installPath\quick-read.ps1'`""
    $shortcut.Description = "Read clipboard text aloud"
    $shortcut.IconLocation = "shell32.dll,222"
    $shortcut.Save()
    
    # Enhanced Reader shortcut
    $shortcut2 = $shell.CreateShortcut("$env:USERPROFILE\Desktop\Text Reader.lnk")
    $shortcut2.TargetPath = "powershell.exe"
    $shortcut2.Arguments = "-Command `"& '$installPath\text-to-speech-reader.ps1'`""
    $shortcut2.Description = "Advanced text-to-speech reader with controls"
    $shortcut2.IconLocation = "shell32.dll,221"
    $shortcut2.Save()
    
    Write-Host "Created desktop shortcuts" -ForegroundColor Cyan
    
    # Create Start Menu shortcuts
    $startMenuPath = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Text-to-Speech"
    if (-not (Test-Path $startMenuPath)) {
        New-Item -ItemType Directory -Path $startMenuPath -Force | Out-Null
    }
    
    $shortcut3 = $shell.CreateShortcut("$startMenuPath\Quick Read.lnk")
    $shortcut3.TargetPath = "powershell.exe"
    $shortcut3.Arguments = "-WindowStyle Hidden -Command `"& '$installPath\quick-read.ps1'`""
    $shortcut3.Description = "Read clipboard text aloud"
    $shortcut3.IconLocation = "shell32.dll,222"
    $shortcut3.Save()
    
    $shortcut4 = $shell.CreateShortcut("$startMenuPath\Text Reader.lnk")
    $shortcut4.TargetPath = "powershell.exe"
    $shortcut4.Arguments = "-Command `"& '$installPath\text-to-speech-reader.ps1'`""
    $shortcut4.Description = "Advanced text-to-speech reader with controls"
    $shortcut4.IconLocation = "shell32.dll,221"
    $shortcut4.Save()
    
    Write-Host "Created Start Menu shortcuts" -ForegroundColor Cyan
    
    Write-Host "`n=== INSTALLATION COMPLETE ===" -ForegroundColor Green
    Write-Host "Available commands (restart PowerShell to use):" -ForegroundColor Yellow
    Write-Host "  tts          - Advanced reader with controls" -ForegroundColor Cyan
    Write-Host "  speak        - Quick clipboard reading" -ForegroundColor Cyan
    Write-Host "  read-clip    - Read clipboard instantly" -ForegroundColor Cyan
    Write-Host "`nDesktop shortcuts created:" -ForegroundColor Yellow
    Write-Host "  Quick Read   - Double-click to read clipboard" -ForegroundColor Cyan
    Write-Host "  Text Reader  - Full-featured reader" -ForegroundColor Cyan
    Write-Host "`nStart Menu: Text-to-Speech folder" -ForegroundColor Yellow
}

function Uninstall-TTS {
    Write-Host "Uninstalling Text-to-Speech System..." -ForegroundColor Red
    
    # Remove installation directory
    if (Test-Path $installPath) {
        Remove-Item $installPath -Recurse -Force
        Write-Host "Removed installation directory" -ForegroundColor Yellow
    }
    
    # Remove aliases script
    if (Test-Path "$userScriptsPath\tts-aliases.ps1") {
        Remove-Item "$userScriptsPath\tts-aliases.ps1" -Force
        Write-Host "Removed alias scripts" -ForegroundColor Yellow
    }
    
    # Remove desktop shortcuts
    Remove-Item "$env:USERPROFILE\Desktop\Quick Read.lnk" -ErrorAction SilentlyContinue
    Remove-Item "$env:USERPROFILE\Desktop\Text Reader.lnk" -ErrorAction SilentlyContinue
    Write-Host "Removed desktop shortcuts" -ForegroundColor Yellow
    
    # Remove Start Menu shortcuts
    $startMenuPath = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Text-to-Speech"
    if (Test-Path $startMenuPath) {
        Remove-Item $startMenuPath -Recurse -Force
        Write-Host "Removed Start Menu shortcuts" -ForegroundColor Yellow
    }
    
    Write-Host "Note: PowerShell profile entries need to be removed manually if desired" -ForegroundColor Yellow
    Write-Host "=== UNINSTALL COMPLETE ===" -ForegroundColor Green
}

# Main execution
if ($Uninstall) {
    Uninstall-TTS
} else {
    if (-not (Test-AdminRights)) {
        Write-Host "Note: Running without admin rights. Some features may be limited." -ForegroundColor Yellow
        Write-Host "For full installation, run as Administrator." -ForegroundColor Yellow
    }
    
    Install-TTS
    
    Write-Host "`n=== QUICK START GUIDE ===" -ForegroundColor Magenta
    Write-Host "1. Restart PowerShell or run: . `$PROFILE" -ForegroundColor White
    Write-Host "2. Copy any text to clipboard" -ForegroundColor White
    Write-Host "3. Type 'speak' in PowerShell or double-click 'Quick Read' shortcut" -ForegroundColor White
    Write-Host "4. For advanced controls, use 'tts' command or 'Text Reader' shortcut" -ForegroundColor White
}