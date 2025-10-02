# Quick Text-to-Speech from Clipboard or Selection
# Usage: .\quick-read.ps1 or .\quick-read.ps1 "Your text here"

param([string]$Text = "")

Add-Type -AssemblyName System.Speech

# Create and configure speech synthesizer
$speak = New-Object System.Speech.Synthesis.SpeechSynthesizer
$speak.Rate = 0  # Normal speed
$speak.Volume = 100

try {
    if ($Text -eq "") {
        # Try to get text from clipboard
        $clipboardText = Get-Clipboard -Format Text -ErrorAction SilentlyContinue
        if ($clipboardText -and $clipboardText.Trim() -ne "") {
            $inputText = $clipboardText.Trim()
            Write-Host "Reading from clipboard..." -ForegroundColor Green
        } else {
            Write-Host "No text provided and clipboard is empty!" -ForegroundColor Red
            Write-Host "Usage: .\quick-read.ps1 `"Your text here`"" -ForegroundColor Yellow
            Write-Host "   OR: Copy text to clipboard and run .\quick-read.ps1" -ForegroundColor Yellow
            exit 1
        }
    } else {
        $inputText = $Text
    }
    
    $previewText = if ($inputText.Length > 100) { $inputText.Substring(0, 100) + "..." } else { $inputText }
    Write-Host "Speaking: $previewText" -ForegroundColor Cyan
    $speak.Speak($inputText)
    
} catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
} finally {
    $speak.Dispose()
}