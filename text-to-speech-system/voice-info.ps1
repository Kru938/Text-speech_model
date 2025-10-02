# Simple Voice and Language Information
Add-Type -AssemblyName System.Speech

Write-Host "AVAILABLE TEXT-TO-SPEECH VOICES" -ForegroundColor Green
Write-Host "===============================" -ForegroundColor Green
Write-Host ""

$speak = New-Object System.Speech.Synthesis.SpeechSynthesizer
$voices = $speak.GetInstalledVoices()

Write-Host "Found $($voices.Count) available voice(s):" -ForegroundColor Cyan
Write-Host ""

$i = 1
foreach ($voice in $voices) {
    $info = $voice.VoiceInfo
    
    Write-Host "[$i] $($info.Name)" -ForegroundColor Yellow
    Write-Host "    Language: $($info.Culture.DisplayName) ($($info.Culture.Name))" -ForegroundColor Cyan
    Write-Host "    Gender: $($info.Gender), Age: $($info.Age)" -ForegroundColor White
    Write-Host ""
    $i++
}

Write-Host "LANGUAGE SUMMARY:" -ForegroundColor Green
Write-Host "=================" -ForegroundColor Green

$languages = $voices | ForEach-Object { $_.VoiceInfo.Culture } | Sort-Object DisplayName -Unique

foreach ($lang in $languages) {
    $voicesForLang = $voices | Where-Object { $_.VoiceInfo.Culture.Name -eq $lang.Name }
    Write-Host "$($lang.DisplayName): $($voicesForLang.Count) voice(s)" -ForegroundColor Cyan
}

Write-Host ""
Write-Host "To use the enhanced TTS popup with these voices:" -ForegroundColor Magenta
Write-Host ".\tts-popup-enhanced.ps1" -ForegroundColor Yellow

$speak.Dispose()