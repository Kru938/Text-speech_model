# Enhanced Text-to-Speech GUI Popup
# Fixed pause functionality, real-time speed changes, better voice/language support

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Speech

# Global variables
$script:speak = New-Object System.Speech.Synthesis.SpeechSynthesizer
$script:isPlaying = $false
$script:isPaused = $false
$script:currentText = ""
$script:sentences = @()
$script:currentSentenceIndex = 0

# Enhanced form with better size
$form = New-Object System.Windows.Forms.Form
$form.Text = "Enhanced Text-to-Speech Reader"
$form.Size = New-Object System.Drawing.Size(450, 450)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedDialog"
$form.MaximizeBox = $false
$form.Icon = [System.Drawing.SystemIcons]::Information
$form.BackColor = [System.Drawing.Color]::White

# Title label
$titleLabel = New-Object System.Windows.Forms.Label
$titleLabel.Text = "Enhanced Text-to-Speech Reader"
$titleLabel.Font = New-Object System.Drawing.Font("Segoe UI", 14, [System.Drawing.FontStyle]::Bold)
$titleLabel.ForeColor = [System.Drawing.Color]::DarkBlue
$titleLabel.Location = New-Object System.Drawing.Point(20, 15)
$titleLabel.Size = New-Object System.Drawing.Size(400, 30)
$titleLabel.TextAlign = "MiddleCenter"
$form.Controls.Add($titleLabel)

# Text input area
$textLabel = New-Object System.Windows.Forms.Label
$textLabel.Text = "Enter text or auto-load from clipboard:"
$textLabel.Location = New-Object System.Drawing.Point(20, 55)
$textLabel.Size = New-Object System.Drawing.Size(400, 20)
$form.Controls.Add($textLabel)

$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Location = New-Object System.Drawing.Point(20, 80)
$textBox.Size = New-Object System.Drawing.Size(400, 80)
$textBox.Multiline = $true
$textBox.ScrollBars = "Vertical"
$textBox.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$form.Controls.Add($textBox)

# Clipboard and Clear buttons
$clipboardBtn = New-Object System.Windows.Forms.Button
$clipboardBtn.Text = "Load Clipboard"
$clipboardBtn.Location = New-Object System.Drawing.Point(20, 170)
$clipboardBtn.Size = New-Object System.Drawing.Size(130, 30)
$clipboardBtn.BackColor = [System.Drawing.Color]::LightBlue
$clipboardBtn.Add_Click({
    try {
        $clipText = [System.Windows.Forms.Clipboard]::GetText()
        if ($clipText) {
            $textBox.Text = $clipText
            $statusLabel.Text = "✓ Loaded from clipboard"
        } else {
            $statusLabel.Text = "⚠ Clipboard is empty"
        }
    } catch {
        $statusLabel.Text = "✗ Error reading clipboard"
    }
})
$form.Controls.Add($clipboardBtn)

$clearBtn = New-Object System.Windows.Forms.Button
$clearBtn.Text = "Clear"
$clearBtn.Location = New-Object System.Drawing.Point(160, 170)
$clearBtn.Size = New-Object System.Drawing.Size(100, 30)
$clearBtn.BackColor = [System.Drawing.Color]::LightGray
$clearBtn.Add_Click({
    $textBox.Text = ""
    $statusLabel.Text = "Text cleared"
    # Stop any current speech
    $script:speak.SpeakAsyncCancelAll()
    $script:isPlaying = $false
    $script:isPaused = $false
    $playBtn.Text = "▶ Play"
})
$form.Controls.Add($clearBtn)

# Demo button
$demoBtn = New-Object System.Windows.Forms.Button
$demoBtn.Text = "Demo"
$demoBtn.Location = New-Object System.Drawing.Point(270, 170)
$demoBtn.Size = New-Object System.Drawing.Size(80, 30)
$demoBtn.BackColor = [System.Drawing.Color]::LightYellow
$demoBtn.Add_Click({
    $textBox.Text = "Hello! This is a demo of the enhanced text-to-speech system with improved pause functionality and real-time speed control."
    $statusLabel.Text = "Demo text loaded"
})
$form.Controls.Add($demoBtn)

# Refresh voices button
$refreshBtn = New-Object System.Windows.Forms.Button
$refreshBtn.Text = "Refresh"
$refreshBtn.Location = New-Object System.Drawing.Point(360, 170)
$refreshBtn.Size = New-Object System.Drawing.Size(60, 30)
$refreshBtn.BackColor = [System.Drawing.Color]::LightGreen
$refreshBtn.Add_Click({
    # Refresh voice list
    $voiceCombo.Items.Clear()
    $script:speak.GetInstalledVoices() | ForEach-Object {
        $voice = $_.VoiceInfo
        $displayName = "$($voice.Name) ($($voice.Culture.DisplayName))"
        $voiceCombo.Items.Add($displayName) | Out-Null
    }
    if ($voiceCombo.Items.Count -gt 0) {
        $voiceCombo.SelectedIndex = 0
    }
    $statusLabel.Text = "Voice list refreshed"
})
$form.Controls.Add($refreshBtn)

# Main control buttons panel
$controlPanel = New-Object System.Windows.Forms.Panel
$controlPanel.Location = New-Object System.Drawing.Point(20, 210)
$controlPanel.Size = New-Object System.Drawing.Size(400, 50)
$controlPanel.BorderStyle = "FixedSingle"
$controlPanel.BackColor = [System.Drawing.Color]::AliceBlue
$form.Controls.Add($controlPanel)

# Play/Pause button
$playBtn = New-Object System.Windows.Forms.Button
$playBtn.Text = "Play"
$playBtn.Location = New-Object System.Drawing.Point(10, 10)
$playBtn.Size = New-Object System.Drawing.Size(80, 30)
$playBtn.BackColor = [System.Drawing.Color]::LightGreen
$playBtn.Add_Click({
    if ($textBox.Text.Trim() -eq "") {
        $statusLabel.Text = "⚠ No text to read"
        return
    }
    
    if ($script:isPlaying -and $script:isPaused) {
        # Resume
        $script:speak.Resume()
        $script:isPaused = $false
        $playBtn.Text = "⏸ Pause"
        $statusLabel.Text = "▶ Resumed speaking..."
    } elseif ($script:isPlaying -and -not $script:isPaused) {
        # Pause
        $script:speak.Pause()
        $script:isPaused = $true
        $playBtn.Text = "▶ Resume"
        $statusLabel.Text = "⏸ Paused"
    } else {
        # Start new speech
        $script:currentText = $textBox.Text
        $script:speak.SpeakAsync($script:currentText)
        $script:isPlaying = $true
        $script:isPaused = $false
        $playBtn.Text = "⏸ Pause"
        $statusLabel.Text = "🔊 Speaking..."
    }
})
$controlPanel.Controls.Add($playBtn)

# Stop button
$stopBtn = New-Object System.Windows.Forms.Button
$stopBtn.Text = "Stop"
$stopBtn.Location = New-Object System.Drawing.Point(100, 10)
$stopBtn.Size = New-Object System.Drawing.Size(70, 30)
$stopBtn.BackColor = [System.Drawing.Color]::LightCoral
$stopBtn.Add_Click({
    $script:speak.SpeakAsyncCancelAll()
    $script:isPlaying = $false
    $script:isPaused = $false
    $playBtn.Text = "▶ Play"
    $statusLabel.Text = "⏹ Stopped"
})
$controlPanel.Controls.Add($stopBtn)

# Speed controls with real-time display
$speedLabel = New-Object System.Windows.Forms.Label
$speedLabel.Text = "Speed:"
$speedLabel.Location = New-Object System.Drawing.Point(180, 15)
$speedLabel.Size = New-Object System.Drawing.Size(45, 20)
$speedLabel.Font = New-Object System.Drawing.Font("Segoe UI", 8)
$controlPanel.Controls.Add($speedLabel)

$speedValueLabel = New-Object System.Windows.Forms.Label
$speedValueLabel.Text = "0"
$speedValueLabel.Location = New-Object System.Drawing.Point(225, 15)
$speedValueLabel.Size = New-Object System.Drawing.Size(25, 20)
$speedValueLabel.Font = New-Object System.Drawing.Font("Segoe UI", 8, [System.Drawing.FontStyle]::Bold)
$speedValueLabel.ForeColor = [System.Drawing.Color]::DarkBlue
$controlPanel.Controls.Add($speedValueLabel)

$slowBtn = New-Object System.Windows.Forms.Button
$slowBtn.Text = "🐌"
$slowBtn.Location = New-Object System.Drawing.Point(250, 10)
$slowBtn.Size = New-Object System.Drawing.Size(35, 30)
$slowBtn.BackColor = [System.Drawing.Color]::LightBlue
$slowBtn.Add_Click({
    if ($script:speak.Rate -gt -10) {
        $script:speak.Rate--
        $speedValueLabel.Text = $script:speak.Rate.ToString()
        $statusLabel.Text = "🐌 Speed: $($script:speak.Rate) (Slower)"
        
        # If currently speaking, restart with new speed
        if ($script:isPlaying -and -not $script:isPaused) {
            $script:speak.SpeakAsyncCancelAll()
            Start-Sleep -Milliseconds 100
            $script:speak.SpeakAsync($script:currentText)
        }
    } else {
        $statusLabel.Text = "⚠ Minimum speed reached (-10)"
    }
})
$controlPanel.Controls.Add($slowBtn)

$fastBtn = New-Object System.Windows.Forms.Button
$fastBtn.Text = "🐰"
$fastBtn.Location = New-Object System.Drawing.Point(290, 10)
$fastBtn.Size = New-Object System.Drawing.Size(35, 30)
$fastBtn.BackColor = [System.Drawing.Color]::LightPink
$fastBtn.Add_Click({
    if ($script:speak.Rate -lt 10) {
        $script:speak.Rate++
        $speedValueLabel.Text = $script:speak.Rate.ToString()
        $statusLabel.Text = "🐰 Speed: $($script:speak.Rate) (Faster)"
        
        # If currently speaking, restart with new speed
        if ($script:isPlaying -and -not $script:isPaused) {
            $script:speak.SpeakAsyncCancelAll()
            Start-Sleep -Milliseconds 100
            $script:speak.SpeakAsync($script:currentText)
        }
    } else {
        $statusLabel.Text = "⚠ Maximum speed reached (+10)"
    }
})
$controlPanel.Controls.Add($fastBtn)

# Reset speed button
$resetSpeedBtn = New-Object System.Windows.Forms.Button
$resetSpeedBtn.Text = "↻"
$resetSpeedBtn.Location = New-Object System.Drawing.Point(330, 10)
$resetSpeedBtn.Size = New-Object System.Drawing.Size(30, 30)
$resetSpeedBtn.BackColor = [System.Drawing.Color]::LightGray
$resetSpeedBtn.Add_Click({
    $script:speak.Rate = 0
    $speedValueLabel.Text = "0"
    $statusLabel.Text = "↻ Speed reset to normal (0)"
    
    # If currently speaking, restart with normal speed
    if ($script:isPlaying -and -not $script:isPaused) {
        $script:speak.SpeakAsyncCancelAll()
        Start-Sleep -Milliseconds 100
        $script:speak.SpeakAsync($script:currentText)
    }
})
$controlPanel.Controls.Add($resetSpeedBtn)

# Voice and Language selection panel
$voicePanel = New-Object System.Windows.Forms.Panel
$voicePanel.Location = New-Object System.Drawing.Point(20, 270)
$voicePanel.Size = New-Object System.Drawing.Size(400, 60)
$voicePanel.BorderStyle = "FixedSingle"
$voicePanel.BackColor = [System.Drawing.Color]::Honeydew
$form.Controls.Add($voicePanel)

# Voice selection
$voiceLabel = New-Object System.Windows.Forms.Label
$voiceLabel.Text = "Voice & Language:"
$voiceLabel.Location = New-Object System.Drawing.Point(10, 10)
$voiceLabel.Size = New-Object System.Drawing.Size(100, 20)
$voiceLabel.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
$voicePanel.Controls.Add($voiceLabel)

$voiceCombo = New-Object System.Windows.Forms.ComboBox
$voiceCombo.Location = New-Object System.Drawing.Point(10, 30)
$voiceCombo.Size = New-Object System.Drawing.Size(300, 25)
$voiceCombo.DropDownStyle = "DropDownList"
$voiceCombo.Font = New-Object System.Drawing.Font("Segoe UI", 8)

# Populate voices with language info
$script:speak.GetInstalledVoices() | ForEach-Object {
    $voice = $_.VoiceInfo
    $culture = $voice.Culture.DisplayName
    $displayName = "$($voice.Name) ($culture - $($voice.Gender), $($voice.Age))"
    $voiceCombo.Items.Add($displayName) | Out-Null
}

if ($voiceCombo.Items.Count -gt 0) {
    $voiceCombo.SelectedIndex = 0
}

$voiceCombo.Add_SelectedIndexChanged({
    try {
        $selectedText = $voiceCombo.SelectedItem.ToString()
        $voiceName = $selectedText.Split('(')[0].Trim()
        $script:speak.SelectVoice($voiceName)
        $statusLabel.Text = "🎤 Voice changed to: $voiceName"
        
        # If currently speaking, restart with new voice
        if ($script:isPlaying -and -not $script:isPaused) {
            $script:speak.SpeakAsyncCancelAll()
            Start-Sleep -Milliseconds 100
            $script:speak.SpeakAsync($script:currentText)
        }
    } catch {
        $statusLabel.Text = "✗ Error changing voice: $($_.Exception.Message)"
    }
})
$voicePanel.Controls.Add($voiceCombo)

# Test voice button
$testVoiceBtn = New-Object System.Windows.Forms.Button
$testVoiceBtn.Text = "🎵 Test"
$testVoiceBtn.Location = New-Object System.Drawing.Point(320, 28)
$testVoiceBtn.Size = New-Object System.Drawing.Size(70, 25)
$testVoiceBtn.BackColor = [System.Drawing.Color]::LightCyan
$testVoiceBtn.Add_Click({
    $testText = "Hello, this is a voice test. Speed is $($script:speak.Rate)."
    $script:speak.SpeakAsync($testText)
    $statusLabel.Text = "🎵 Testing current voice..."
})
$voicePanel.Controls.Add($testVoiceBtn)

# Volume control
$volumeLabel = New-Object System.Windows.Forms.Label
$volumeLabel.Text = "Volume:"
$volumeLabel.Location = New-Object System.Drawing.Point(20, 340)
$volumeLabel.Size = New-Object System.Drawing.Size(50, 20)
$form.Controls.Add($volumeLabel)

$volumeTrackBar = New-Object System.Windows.Forms.TrackBar
$volumeTrackBar.Location = New-Object System.Drawing.Point(70, 335)
$volumeTrackBar.Size = New-Object System.Drawing.Size(200, 45)
$volumeTrackBar.Minimum = 0
$volumeTrackBar.Maximum = 100
$volumeTrackBar.Value = 100
$volumeTrackBar.TickFrequency = 10
$volumeTrackBar.Add_ValueChanged({
    $script:speak.Volume = $volumeTrackBar.Value
    $volumeValueLabel.Text = "$($volumeTrackBar.Value)%"
})
$form.Controls.Add($volumeTrackBar)

$volumeValueLabel = New-Object System.Windows.Forms.Label
$volumeValueLabel.Text = "100%"
$volumeValueLabel.Location = New-Object System.Drawing.Point(280, 340)
$volumeValueLabel.Size = New-Object System.Drawing.Size(50, 20)
$volumeValueLabel.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
$form.Controls.Add($volumeValueLabel)

# Mute button
$muteBtn = New-Object System.Windows.Forms.Button
$muteBtn.Text = "🔊"
$muteBtn.Location = New-Object System.Drawing.Point(340, 335)
$muteBtn.Size = New-Object System.Drawing.Size(40, 30)
$muteBtn.BackColor = [System.Drawing.Color]::LightGray
$script:isMuted = $false
$script:lastVolume = 100
$muteBtn.Add_Click({
    if ($script:isMuted) {
        # Unmute
        $script:speak.Volume = $script:lastVolume
        $volumeTrackBar.Value = $script:lastVolume
        $volumeValueLabel.Text = "$($script:lastVolume)%"
        $muteBtn.Text = "🔊"
        $script:isMuted = $false
        $statusLabel.Text = "🔊 Unmuted"
    } else {
        # Mute
        $script:lastVolume = $script:speak.Volume
        $script:speak.Volume = 0
        $volumeTrackBar.Value = 0
        $volumeValueLabel.Text = "0%"
        $muteBtn.Text = "🔇"
        $script:isMuted = $true
        $statusLabel.Text = "🔇 Muted"
    }
})
$form.Controls.Add($muteBtn)

# Status label
$statusLabel = New-Object System.Windows.Forms.Label
$statusLabel.Text = "✨ Ready to speak! Try the demo or load text from clipboard."
$statusLabel.Location = New-Object System.Drawing.Point(20, 380)
$statusLabel.Size = New-Object System.Drawing.Size(400, 20)
$statusLabel.ForegroundColor = [System.Drawing.Color]::DarkGreen
$statusLabel.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Italic)
$form.Controls.Add($statusLabel)

# Event handlers for proper state management
$script:speak.Add_SpeakStarted({
    $script:isPlaying = $true
    $script:isPaused = $false
})

$script:speak.Add_SpeakCompleted({
    $script:isPlaying = $false
    $script:isPaused = $false
    $playBtn.Text = "▶ Play"
    $statusLabel.Text = "✅ Finished speaking"
})

$script:speak.Add_SpeakProgress({
    param($sender, $e)
    # Update status with current word being spoken
    if ($e.Text) {
        $statusLabel.Text = "🔊 Speaking: '$($e.Text)'"
    }
})

# Auto-load clipboard on startup
try {
    $clipText = [System.Windows.Forms.Clipboard]::GetText()
    if ($clipText -and $clipText.Trim() -ne "") {
        $textBox.Text = $clipText
        $statusLabel.Text = "📋 Auto-loaded from clipboard"
    }
} catch {
    # Ignore clipboard errors on startup
}

# Initialize speed display
$speedValueLabel.Text = $script:speak.Rate.ToString()

# Handle form closing
$form.Add_FormClosed({
    if ($script:speak) {
        $script:speak.SpeakAsyncCancelAll()
        $script:speak.Dispose()
    }
})

# Handle ESC key to close
$form.Add_KeyDown({
    if ($_.KeyCode -eq "Escape") {
        $form.Close()
    }
})

# Keyboard shortcuts
$form.Add_KeyDown({
    if ($_.Control) {
        switch ($_.KeyCode) {
            "V" { # Ctrl+V - Load clipboard
                $clipboardBtn.PerformClick()
            }
            "Enter" { # Ctrl+Enter - Play/Pause
                $playBtn.PerformClick()
            }
            "D" { # Ctrl+D - Demo
                $demoBtn.PerformClick()
            }
        }
    }
    if ($_.KeyCode -eq "Space") {
        $playBtn.PerformClick()
        $_.Handled = $true
    }
})

# Make form topmost initially
$form.TopMost = $true

# Show help on startup
$form.Add_Shown({
    $statusLabel.Text = "💡 Tips: Space=Play/Pause, Ctrl+V=Clipboard, Ctrl+D=Demo, Speed adjusts in real-time!"
})

# Show the form
[void]$form.ShowDialog()