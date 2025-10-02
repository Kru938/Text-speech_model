# Enhanced Text-to-Speech Reader with Playback Controls
# Usage: .\text-to-speech-reader.ps1 -Text "Your text here" or .\text-to-speech-reader.ps1 -File "path\to\file.txt"

param(
    [string]$Text = "",
    [string]$File = "",
    [string]$Voice = "Microsoft Zira Desktop",
    [int]$Rate = 0,  # -10 to 10 (slow to fast)
    [int]$Volume = 100  # 0 to 100
)

Add-Type -AssemblyName System.Speech
Add-Type -AssemblyName System.Windows.Forms

# Create speech synthesizer
$script:speak = New-Object System.Speech.Synthesis.SpeechSynthesizer

# Set voice properties
try {
    $script:speak.SelectVoice($Voice)
} catch {
    Write-Host "Voice '$Voice' not found. Using default voice." -ForegroundColor Yellow
}
$script:speak.Rate = $Rate
$script:speak.Volume = $Volume

# Global variables for text management
$script:sentences = @()
$script:currentIndex = 0
$script:isPaused = $false

function Show-AvailableVoices {
    Write-Host "`nAvailable Voices:" -ForegroundColor Green
    $script:speak.GetInstalledVoices() | ForEach-Object {
        $voice = $_.VoiceInfo
        Write-Host "  - $($voice.Name) ($($voice.Gender), $($voice.Age))" -ForegroundColor Cyan
    }
}

function Split-TextToSentences {
    param([string]$inputText)
    
    # Split by sentence endings, keeping the punctuation
    $sentences = $inputText -split '(?<=[.!?])\s+' | Where-Object { $_.Trim() -ne "" }
    return $sentences
}

function Show-Controls {
    Write-Host "`n=== TEXT-TO-SPEECH CONTROLS ===" -ForegroundColor Yellow
    Write-Host "SPACE or P  - Pause/Resume" -ForegroundColor Green
    Write-Host "RIGHT or N  - Next sentence" -ForegroundColor Green
    Write-Host "LEFT or B   - Previous sentence" -ForegroundColor Green
    Write-Host "UP or +     - Increase speed" -ForegroundColor Green
    Write-Host "DOWN or -   - Decrease speed" -ForegroundColor Green
    Write-Host "R           - Restart from beginning" -ForegroundColor Green
    Write-Host "S           - Stop completely" -ForegroundColor Green
    Write-Host "Q or ESC    - Quit" -ForegroundColor Green
    Write-Host "H           - Show this help" -ForegroundColor Green
    Write-Host "V           - Show available voices" -ForegroundColor Green
    Write-Host "=================================" -ForegroundColor Yellow
}

function Read-CurrentSentence {
    if ($script:currentIndex -ge 0 -and $script:currentIndex -lt $script:sentences.Count) {
        $currentSentence = $script:sentences[$script:currentIndex]
        Write-Host "`n[$($script:currentIndex + 1)/$($script:sentences.Count)] Reading: " -ForegroundColor Cyan -NoNewline
        Write-Host $currentSentence.Substring(0, [Math]::Min(50, $currentSentence.Length)) -ForegroundColor White
        if ($currentSentence.Length > 50) { Write-Host "..." -ForegroundColor White }
        
        $script:speak.SpeakAsync($currentSentence) | Out-Null
    }
}

function Stop-Speech {
    $script:speak.SpeakAsyncCancelAll()
}

function Process-KeyInput {
    while ($true) {
        if ([Console]::KeyAvailable) {
            $key = [Console]::ReadKey($true)
            
            switch ($key.Key) {
                "Spacebar" { 
                    if ($script:isPaused) {
                        $script:speak.Resume()
                        $script:isPaused = $false
                        Write-Host "Resumed" -ForegroundColor Green
                    } else {
                        $script:speak.Pause()
                        $script:isPaused = $true
                        Write-Host "Paused" -ForegroundColor Yellow
                    }
                }
                "P" {
                    if ($script:isPaused) {
                        $script:speak.Resume()
                        $script:isPaused = $false
                        Write-Host "Resumed" -ForegroundColor Green
                    } else {
                        $script:speak.Pause()
                        $script:isPaused = $true
                        Write-Host "Paused" -ForegroundColor Yellow
                    }
                }
                "RightArrow" { 
                    Stop-Speech
                    if ($script:currentIndex -lt $script:sentences.Count - 1) {
                        $script:currentIndex++
                        Read-CurrentSentence
                    } else {
                        Write-Host "End of text reached" -ForegroundColor Yellow
                    }
                }
                "N" {
                    Stop-Speech
                    if ($script:currentIndex -lt $script:sentences.Count - 1) {
                        $script:currentIndex++
                        Read-CurrentSentence
                    } else {
                        Write-Host "End of text reached" -ForegroundColor Yellow
                    }
                }
                "LeftArrow" {
                    Stop-Speech
                    if ($script:currentIndex -gt 0) {
                        $script:currentIndex--
                        Read-CurrentSentence
                    } else {
                        Write-Host "Beginning of text reached" -ForegroundColor Yellow
                    }
                }
                "B" {
                    Stop-Speech
                    if ($script:currentIndex -gt 0) {
                        $script:currentIndex--
                        Read-CurrentSentence
                    } else {
                        Write-Host "Beginning of text reached" -ForegroundColor Yellow
                    }
                }
                "UpArrow" {
                    if ($script:speak.Rate -lt 10) {
                        $script:speak.Rate++
                        Write-Host "Speed increased to $($script:speak.Rate)" -ForegroundColor Green
                    }
                }
                "Add" {
                    if ($script:speak.Rate -lt 10) {
                        $script:speak.Rate++
                        Write-Host "Speed increased to $($script:speak.Rate)" -ForegroundColor Green
                    }
                }
                "DownArrow" {
                    if ($script:speak.Rate -gt -10) {
                        $script:speak.Rate--
                        Write-Host "Speed decreased to $($script:speak.Rate)" -ForegroundColor Green
                    }
                }
                "Subtract" {
                    if ($script:speak.Rate -gt -10) {
                        $script:speak.Rate--
                        Write-Host "Speed decreased to $($script:speak.Rate)" -ForegroundColor Green
                    }
                }
                "R" {
                    Stop-Speech
                    $script:currentIndex = 0
                    Write-Host "Restarting from beginning..." -ForegroundColor Green
                    Read-CurrentSentence
                }
                "S" {
                    Stop-Speech
                    Write-Host "Speech stopped" -ForegroundColor Red
                }
                "H" {
                    Show-Controls
                }
                "V" {
                    Show-AvailableVoices
                }
                "Q" {
                    Stop-Speech
                    Write-Host "Exiting..." -ForegroundColor Red
                    return
                }
                "Escape" {
                    Stop-Speech
                    Write-Host "Exiting..." -ForegroundColor Red
                    return
                }
            }
        }
        Start-Sleep -Milliseconds 50
    }
}

# Main execution
try {
    Write-Host "Text-to-Speech Reader with Controls" -ForegroundColor Magenta
    Write-Host "===================================" -ForegroundColor Magenta
    
    # Get text input
    if ($File -ne "") {
        if (Test-Path $File) {
            $inputText = Get-Content $File -Raw
            Write-Host "Loaded text from file: $File" -ForegroundColor Green
        } else {
            Write-Host "File not found: $File" -ForegroundColor Red
            exit 1
        }
    } elseif ($Text -ne "") {
        $inputText = $Text
    } else {
        # Interactive mode - get text from clipboard or manual input
        Write-Host "No text or file specified. Checking clipboard..." -ForegroundColor Yellow
        
        try {
            $clipboardText = Get-Clipboard -Format Text -ErrorAction SilentlyContinue
            if ($clipboardText -and $clipboardText.Trim() -ne "") {
                $inputText = $clipboardText
                Write-Host "Using text from clipboard" -ForegroundColor Green
            } else {
                Write-Host "Enter your text (press Ctrl+Z then Enter when finished):" -ForegroundColor Yellow
                $inputText = [System.Console]::In.ReadToEnd()
            }
        } catch {
            Write-Host "Enter your text (press Ctrl+Z then Enter when finished):" -ForegroundColor Yellow
            $inputText = [System.Console]::In.ReadToEnd()
        }
    }
    
    if ($inputText.Trim() -eq "") {
        Write-Host "No text to read!" -ForegroundColor Red
        exit 1
    }
    
    # Split text into sentences
    $script:sentences = Split-TextToSentences $inputText.Trim()
    Write-Host "Text split into $($script:sentences.Count) sentences" -ForegroundColor Green
    
    # Show controls
    Show-Controls
    
    # Start reading
    Write-Host "`nStarting text-to-speech... Press H for help" -ForegroundColor Green
    Read-CurrentSentence
    
    # Process keyboard input
    Process-KeyInput
    
} catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
} finally {
    # Cleanup
    if ($script:speak) {
        $script:speak.Dispose()
    }
}