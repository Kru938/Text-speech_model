# Voice and Language Checker
# Shows all available TTS voices and their languages/capabilities

Add-Type -AssemblyName System.Speech

Write-Host "🎤 AVAILABLE TEXT-TO-SPEECH VOICES" -ForegroundColor Green
Write-Host "=================================" -ForegroundColor Green
Write-Host ""

$speak = New-Object System.Speech.Synthesis.SpeechSynthesizer
$voices = $speak.GetInstalledVoices()

if ($voices.Count -eq 0) {
    Write-Host "❌ No voices found!" -ForegroundColor Red
    exit
}

Write-Host "Found $($voices.Count) available voice(s):" -ForegroundColor Cyan
Write-Host ""

$i = 1
foreach ($voice in $voices) {
    $info = $voice.VoiceInfo
    
    Write-Host "[$i] Voice Details:" -ForegroundColor Yellow
    Write-Host "   Name: $($info.Name)" -ForegroundColor White
    Write-Host "   Language: $($info.Culture.DisplayName) ($($info.Culture.Name))" -ForegroundColor Cyan
    Write-Host "   Gender: $($info.Gender)" -ForegroundColor Magenta
    Write-Host "   Age: $($info.Age)" -ForegroundColor Blue
    Write-Host "   Description: $($info.Description)" -ForegroundColor Gray
    
    # Test if voice supports different languages
    $supportedFormats = $info.SupportedAudioFormats
    if ($supportedFormats.Count -gt 0) {
        Write-Host "   Audio Formats: $($supportedFormats.Count) supported" -ForegroundColor Green
    }
    
    Write-Host ""
    $i++
}

Write-Host "🎯 LANGUAGE SUPPORT:" -ForegroundColor Green
Write-Host "===================" -ForegroundColor Green

# Get unique languages
$languages = $voices | ForEach-Object { $_.VoiceInfo.Culture } | Sort-Object DisplayName -Unique

foreach ($lang in $languages) {
    $voicesForLang = $voices | Where-Object { $_.VoiceInfo.Culture.Name -eq $lang.Name }
    Write-Host "🌐 $($lang.DisplayName) ($($lang.Name)): $($voicesForLang.Count) voice(s)" -ForegroundColor Cyan
    
    foreach ($v in $voicesForLang) {
        Write-Host "   - $($v.VoiceInfo.Name) ($($v.VoiceInfo.Gender))" -ForegroundColor White
    }
    Write-Host ""
}

Write-Host "🧪 VOICE TEST:" -ForegroundColor Green
Write-Host "=============" -ForegroundColor Green

$testChoice = Read-Host "Would you like to test a voice? Enter voice number (1-$($voices.Count)) or 'n' to skip"

if ($testChoice -ne 'n' -and $testChoice -match '^\d+$') {
    $voiceIndex = [int]$testChoice - 1
    if ($voiceIndex -ge 0 -and $voiceIndex -lt $voices.Count) {
        $selectedVoice = $voices[$voiceIndex].VoiceInfo
        Write-Host "Testing voice: $($selectedVoice.Name)" -ForegroundColor Yellow
        
        try {
            $speak.SelectVoice($selectedVoice.Name)
            $testText = "Hello! This is a test of the $($selectedVoice.Name) voice speaking in $($selectedVoice.Culture.DisplayName). The current speed is normal."
            
            Write-Host "🔊 Speaking..." -ForegroundColor Green
            $speak.Speak($testText)
            Write-Host "✅ Test completed!" -ForegroundColor Green
            
        } catch {
            Write-Host "❌ Error testing voice: $($_.Exception.Message)" -ForegroundColor Red
        }
    } else {
        Write-Host "❌ Invalid voice number!" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "💡 TIPS FOR DIFFERENT LANGUAGES:" -ForegroundColor Green
Write-Host "================================" -ForegroundColor Green
Write-Host "• English text works with all voices" -ForegroundColor White
Write-Host "• For best results, match text language to voice language" -ForegroundColor White
Write-Host "• Some voices may pronounce foreign words differently" -ForegroundColor White
Write-Host "• Speed and pitch settings affect all languages" -ForegroundColor White
Write-Host ""

Write-Host "🎊 To use different voices in the TTS popup:" -ForegroundColor Magenta
Write-Host "1. Run the enhanced TTS popup: .\tts-popup-enhanced.ps1" -ForegroundColor Cyan
Write-Host "2. Select voice from dropdown (includes language info)" -ForegroundColor Cyan
Write-Host "3. Click Test button to hear the voice" -ForegroundColor Cyan
Write-Host "4. Speed changes work in real-time!" -ForegroundColor Cyan

$speak.Dispose()