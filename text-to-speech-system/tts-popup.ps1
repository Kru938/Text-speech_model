# Text-to-Speech GUI Popup
# A Chrome extension-like popup interface for text reading

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Speech

# Global variables
$script:speak = New-Object System.Speech.Synthesis.SpeechSynthesizer
$script:isPlaying = $false
$script:isPaused = $false
$script:currentText = ""

# Create main form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Text-to-Speech Reader"
$form.Size = New-Object System.Drawing.Size(400, 350)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedDialog"
$form.MaximizeBox = $false
$form.Icon = [System.Drawing.SystemIcons]::Information
$form.BackColor = [System.Drawing.Color]::White

# Title label
$titleLabel = New-Object System.Windows.Forms.Label
$titleLabel.Text = "Text-to-Speech Reader"
$titleLabel.Font = New-Object System.Drawing.Font("Segoe UI", 14, [System.Drawing.FontStyle]::Bold)
$titleLabel.ForeColor = [System.Drawing.Color]::DarkBlue
$titleLabel.Location = New-Object System.Drawing.Point(20, 15)
$titleLabel.Size = New-Object System.Drawing.Size(350, 30)
$titleLabel.TextAlign = "MiddleCenter"
$form.Controls.Add($titleLabel)

# Text input area
$textLabel = New-Object System.Windows.Forms.Label
$textLabel.Text = "Enter text or it will auto-load from clipboard:"
$textLabel.Location = New-Object System.Drawing.Point(20, 55)
$textLabel.Size = New-Object System.Drawing.Size(350, 20)
$form.Controls.Add($textLabel)

$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Location = New-Object System.Drawing.Point(20, 80)
$textBox.Size = New-Object System.Drawing.Size(350, 100)
$textBox.Multiline = $true
$textBox.ScrollBars = "Vertical"
$textBox.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$form.Controls.Add($textBox)

# Load clipboard button
$clipboardBtn = New-Object System.Windows.Forms.Button
$clipboardBtn.Text = "Load from Clipboard"
$clipboardBtn.Location = New-Object System.Drawing.Point(20, 190)
$clipboardBtn.Size = New-Object System.Drawing.Size(150, 30)
$clipboardBtn.BackColor = [System.Drawing.Color]::LightBlue
$clipboardBtn.Add_Click({
    try {
        $clipText = [System.Windows.Forms.Clipboard]::GetText()
        if ($clipText) {
            $textBox.Text = $clipText
            $statusLabel.Text = "Loaded from clipboard"
        } else {
            $statusLabel.Text = "Clipboard is empty"
        }
    } catch {
        $statusLabel.Text = "Error reading clipboard"
    }
})
$form.Controls.Add($clipboardBtn)

# Clear button
$clearBtn = New-Object System.Windows.Forms.Button
$clearBtn.Text = "Clear"
$clearBtn.Location = New-Object System.Drawing.Point(220, 190)
$clearBtn.Size = New-Object System.Drawing.Size(150, 30)
$clearBtn.BackColor = [System.Drawing.Color]::LightGray
$clearBtn.Add_Click({
    $textBox.Text = ""
    $statusLabel.Text = "Text cleared"
})
$form.Controls.Add($clearBtn)

# Control buttons panel
$controlPanel = New-Object System.Windows.Forms.Panel
$controlPanel.Location = New-Object System.Drawing.Point(20, 230)
$controlPanel.Size = New-Object System.Drawing.Size(350, 40)
$form.Controls.Add($controlPanel)

# Play button
$playBtn = New-Object System.Windows.Forms.Button
$playBtn.Text = "Play"
$playBtn.Location = New-Object System.Drawing.Point(0, 0)
$playBtn.Size = New-Object System.Drawing.Size(80, 35)
$playBtn.BackColor = [System.Drawing.Color]::LightGreen
$playBtn.Add_Click({
    if ($textBox.Text.Trim() -eq "") {
        $statusLabel.Text = "No text to read"
        return
    }
    
    if ($script:isPlaying -and $script:isPaused) {
        $script:speak.Resume()
        $script:isPaused = $false
        $playBtn.Text = "Pause"
        $statusLabel.Text = "Resumed"
    } else {
        $script:currentText = $textBox.Text
        $script:speak.SpeakAsync($script:currentText)
        $script:isPlaying = $true
        $script:isPaused = $false
        $playBtn.Text = "Pause"
        $statusLabel.Text = "Speaking..."
    }
})
$controlPanel.Controls.Add($playBtn)

# Stop button
$stopBtn = New-Object System.Windows.Forms.Button
$stopBtn.Text = "Stop"
$stopBtn.Location = New-Object System.Drawing.Point(90, 0)
$stopBtn.Size = New-Object System.Drawing.Size(80, 35)
$stopBtn.BackColor = [System.Drawing.Color]::LightCoral
$stopBtn.Add_Click({
    $script:speak.SpeakAsyncCancelAll()
    $script:isPlaying = $false
    $script:isPaused = $false
    $playBtn.Text = "Play"
    $statusLabel.Text = "Stopped"
})
$controlPanel.Controls.Add($stopBtn)

# Speed controls
$speedLabel = New-Object System.Windows.Forms.Label
$speedLabel.Text = "Speed:"
$speedLabel.Location = New-Object System.Drawing.Point(180, 8)
$speedLabel.Size = New-Object System.Drawing.Size(45, 20)
$controlPanel.Controls.Add($speedLabel)

$slowBtn = New-Object System.Windows.Forms.Button
$slowBtn.Text = "<<"
$slowBtn.Location = New-Object System.Drawing.Point(225, 0)
$slowBtn.Size = New-Object System.Drawing.Size(35, 35)
$slowBtn.Add_Click({
    if ($script:speak.Rate -gt -10) {
        $script:speak.Rate--
        $statusLabel.Text = "Speed: $($script:speak.Rate)"
    }
})
$controlPanel.Controls.Add($slowBtn)

$fastBtn = New-Object System.Windows.Forms.Button
$fastBtn.Text = ">>"
$fastBtn.Location = New-Object System.Drawing.Point(270, 0)
$fastBtn.Size = New-Object System.Drawing.Size(35, 35)
$fastBtn.Add_Click({
    if ($script:speak.Rate -lt 10) {
        $script:speak.Rate++
        $statusLabel.Text = "Speed: $($script:speak.Rate)"
    }
})
$controlPanel.Controls.Add($fastBtn)

# Voice selection
$voiceLabel = New-Object System.Windows.Forms.Label
$voiceLabel.Text = "Voice:"
$voiceLabel.Location = New-Object System.Drawing.Point(20, 280)
$voiceLabel.Size = New-Object System.Drawing.Size(40, 20)
$form.Controls.Add($voiceLabel)

$voiceCombo = New-Object System.Windows.Forms.ComboBox
$voiceCombo.Location = New-Object System.Drawing.Point(70, 278)
$voiceCombo.Size = New-Object System.Drawing.Size(200, 25)
$voiceCombo.DropDownStyle = "DropDownList"

# Populate voices
$script:speak.GetInstalledVoices() | ForEach-Object {
    $voiceCombo.Items.Add($_.VoiceInfo.Name) | Out-Null
}
$voiceCombo.SelectedIndex = 0

$voiceCombo.Add_SelectedIndexChanged({
    try {
        $script:speak.SelectVoice($voiceCombo.SelectedItem)
        $statusLabel.Text = "Voice changed to: $($voiceCombo.SelectedItem)"
    } catch {
        $statusLabel.Text = "Error changing voice"
    }
})
$form.Controls.Add($voiceCombo)

# Status label
$statusLabel = New-Object System.Windows.Forms.Label
$statusLabel.Text = "Ready to speak!"
$statusLabel.Location = New-Object System.Drawing.Point(20, 310)
$statusLabel.Size = New-Object System.Drawing.Size(350, 20)
$statusLabel.ForeColor = [System.Drawing.Color]::DarkGreen
$statusLabel.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Italic)
$form.Controls.Add($statusLabel)

# Handle pause/resume for play button
$script:speak.Add_SpeakStarted({
    $script:isPlaying = $true
})

$script:speak.Add_SpeakCompleted({
    $script:isPlaying = $false
    $script:isPaused = $false
    $playBtn.Text = "Play"
    $statusLabel.Text = "Finished speaking"
})

# Auto-load clipboard on startup
try {
    $clipText = [System.Windows.Forms.Clipboard]::GetText()
    if ($clipText -and $clipText.Trim() -ne "") {
        $textBox.Text = $clipText
        $statusLabel.Text = "Auto-loaded from clipboard"
    }
} catch {
    # Ignore clipboard errors on startup
}

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

# Make form topmost initially
$form.TopMost = $true

# Show the form
[void]$form.ShowDialog()