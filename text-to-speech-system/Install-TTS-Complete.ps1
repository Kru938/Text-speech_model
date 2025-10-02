# 🎤 One-Click Text-to-Speech System Installer
# Complete installation with GUI popup, shortcuts, and documentation

param([switch]$Uninstall)

Write-Host "🎤 TEXT-TO-SPEECH POPUP SYSTEM INSTALLER" -ForegroundColor Magenta
Write-Host "=========================================" -ForegroundColor Magenta
Write-Host ""

if ($Uninstall) {
    Write-Host "🗑️ Uninstalling Text-to-Speech System..." -ForegroundColor Red
    
    # Run the main uninstaller
    if (Test-Path ".\install-tts.ps1") {
        & ".\install-tts.ps1" -Uninstall
    }
    
    # Remove documentation files
    Remove-Item "TTS-Setup-Guide.md" -ErrorAction SilentlyContinue
    Remove-Item "Quick-Start-Card.txt" -ErrorAction SilentlyContinue
    
    Write-Host "✅ Uninstallation complete!" -ForegroundColor Green
    exit
}

Write-Host "🚀 Installing complete text-to-speech system..." -ForegroundColor Green
Write-Host ""

# Check prerequisites
Write-Host "🔍 Checking system requirements..." -ForegroundColor Cyan
try {
    Add-Type -AssemblyName System.Speech
    $testSpeech = New-Object System.Speech.Synthesis.SpeechSynthesizer
    $voices = $testSpeech.GetInstalledVoices()
    Write-Host "   ✅ Speech synthesis: Available ($($voices.Count) voices)" -ForegroundColor Green
    $testSpeech.Dispose()
} catch {
    Write-Host "   ❌ Speech synthesis: Not available" -ForegroundColor Red
    Write-Host "   Please ensure Windows Speech Platform is installed." -ForegroundColor Yellow
    exit 1
}

try {
    Add-Type -AssemblyName System.Windows.Forms
    Write-Host "   ✅ Windows Forms: Available" -ForegroundColor Green
} catch {
    Write-Host "   ❌ Windows Forms: Not available" -ForegroundColor Red
    exit 1
}

Write-Host ""

# Install main system
Write-Host "📦 Installing core system..." -ForegroundColor Cyan
if (Test-Path ".\install-tts.ps1") {
    & ".\install-tts.ps1"
} else {
    Write-Host "❌ Main installer not found!" -ForegroundColor Red
    Write-Host "Please ensure install-tts.ps1 is in the current directory." -ForegroundColor Yellow
    exit 1
}

Write-Host ""

# Copy documentation to user folder
Write-Host "📚 Installing documentation..." -ForegroundColor Cyan
$userTTSPath = "$env:USERPROFILE\TextToSpeech"

if (Test-Path "TTS-Setup-Guide.md") {
    Copy-Item "TTS-Setup-Guide.md" "$userTTSPath\" -Force -ErrorAction SilentlyContinue
    Write-Host "   ✅ Setup guide installed" -ForegroundColor Green
}

if (Test-Path "Quick-Start-Card.txt") {
    Copy-Item "Quick-Start-Card.txt" "$userTTSPath\" -Force -ErrorAction SilentlyContinue
    Write-Host "   ✅ Quick start card installed" -ForegroundColor Green
}

# Create additional GUI shortcut if not exists
$guiShortcutPath = "$env:USERPROFILE\Desktop\TTS Popup.lnk"
if (-not (Test-Path $guiShortcutPath)) {
    Write-Host "🖱️ Creating GUI popup shortcut..." -ForegroundColor Cyan
    try {
        $shell = New-Object -ComObject WScript.Shell
        $shortcut = $shell.CreateShortcut($guiShortcutPath)
        $shortcut.TargetPath = "powershell.exe"
        $shortcut.Arguments = "-WindowStyle Hidden -Command `"& '$userTTSPath\tts-popup.ps1'`""
        $shortcut.Description = "Text-to-Speech GUI Popup"
        $shortcut.IconLocation = "shell32.dll,23"
        $shortcut.Save()
        Write-Host "   ✅ TTS Popup shortcut created" -ForegroundColor Green
    } catch {
        Write-Host "   ⚠️ Could not create GUI shortcut" -ForegroundColor Yellow
    }
}

# Test installation
Write-Host ""
Write-Host "🧪 Testing installation..." -ForegroundColor Cyan

# Test clipboard functionality
try {
    "Installation test successful!" | Set-Clipboard
    $testClip = Get-Clipboard
    if ($testClip -eq "Installation test successful!") {
        Write-Host "   ✅ Clipboard functionality: Working" -ForegroundColor Green
    }
} catch {
    Write-Host "   ⚠️ Clipboard functionality: Limited" -ForegroundColor Yellow
}

# Test script accessibility
if (Test-Path "$userTTSPath\tts-popup.ps1") {
    Write-Host "   ✅ GUI popup script: Available" -ForegroundColor Green
} else {
    Write-Host "   ❌ GUI popup script: Missing" -ForegroundColor Red
}

if (Test-Path "$userTTSPath\quick-read.ps1") {
    Write-Host "   ✅ Quick read script: Available" -ForegroundColor Green
} else {
    Write-Host "   ❌ Quick read script: Missing" -ForegroundColor Red
}

Write-Host ""
Write-Host "🎉 INSTALLATION COMPLETE!" -ForegroundColor Green -BackgroundColor DarkGreen
Write-Host ""

# Display success summary
Write-Host "📋 WHAT'S INSTALLED:" -ForegroundColor Yellow
Write-Host "   🖱️ Desktop shortcuts: Quick Read, Text Reader, TTS Popup" -ForegroundColor White
Write-Host "   📁 Start Menu folder: Text-to-Speech" -ForegroundColor White
Write-Host "   💾 Installation folder: $userTTSPath" -ForegroundColor White
Write-Host "   📚 Documentation: Setup guide & quick start card" -ForegroundColor White
Write-Host ""

Write-Host "🚀 QUICK START:" -ForegroundColor Yellow
Write-Host "   1. Copy any text (Ctrl+C)" -ForegroundColor White
Write-Host "   2. Double-click 'TTS Popup' on desktop" -ForegroundColor White
Write-Host "   3. Click 'Play' → Listen! 🔊" -ForegroundColor White
Write-Host ""

Write-Host "📖 DOCUMENTATION:" -ForegroundColor Yellow
Write-Host "   📄 Complete guide: $userTTSPath\TTS-Setup-Guide.md" -ForegroundColor White
Write-Host "   📋 Quick reference: $userTTSPath\Quick-Start-Card.txt" -ForegroundColor White
Write-Host ""

# Offer to test immediately
Write-Host "🧪 TEST NOW:" -ForegroundColor Yellow
$testNow = Read-Host "Would you like to test the TTS popup now? (y/n)"
if ($testNow.ToLower() -eq 'y' -or $testNow.ToLower() -eq 'yes') {
    Write-Host "Opening TTS Popup for testing..." -ForegroundColor Green
    try {
        & "$userTTSPath\tts-popup.ps1"
    } catch {
        Write-Host "Error opening popup. Try double-clicking the desktop shortcut instead." -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "🎊 Your Chrome extension-like text reader is ready!" -ForegroundColor Magenta
Write-Host "🎯 Remember: Select text → Copy (Ctrl+C) → Open TTS Popup → Play!" -ForegroundColor Cyan