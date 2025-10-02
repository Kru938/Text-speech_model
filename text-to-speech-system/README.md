# 🎤 Text-to-Speech Popup System

A Chrome extension-like text-to-speech system for Windows that allows you to read any text aloud with a simple popup interface.

![Text-to-Speech Demo](https://img.shields.io/badge/Platform-Windows-blue) ![PowerShell](https://img.shields.io/badge/PowerShell-5.1+-green) ![License](https://img.shields.io/badge/License-MIT-orange)

## ✨ Features

- 🖱️ **Chrome Extension-like Experience** - Popup interface for easy use
- ⚡ **Instant Clipboard Reading** - Copy text anywhere and speak it immediately
- 🎛️ **Advanced Controls** - Play, pause, speed control, voice selection
- 🚀 **Multiple Access Methods** - Desktop shortcuts, command line, GUI popup
- 🔊 **Multiple Voices** - Choose from available Windows voices
- 📱 **Works Everywhere** - Chrome, Word, PDFs, emails, social media

## 🚀 Quick Start

### One-Click Installation
```powershell
.\Install-TTS-Complete.ps1
```

### Basic Usage
1. **Select and copy any text** (`Ctrl+C`)
2. **Double-click "TTS Popup"** on desktop
3. **Click "Play"** → Listen! 🔊

## 📋 What's Included

### Core Scripts
- `tts-popup.ps1` - GUI popup interface (recommended)
- `quick-read.ps1` - Instant clipboard reading
- `text-to-speech-reader.ps1` - Advanced reader with navigation controls
- `install-tts.ps1` - Main installer
- `Install-TTS-Complete.ps1` - Complete one-click installer

### Command Prompt Support
- `speak.bat` - Quick text-to-speech for Command Prompt
- `tts-popup.bat` - GUI popup for Command Prompt

### Documentation
- `TTS-Setup-Guide.md` - Complete installation and usage guide
- `Quick-Start-Card.txt` - Handy reference card
- `README.md` - This file

## 🎮 Usage Methods

### Method 1: GUI Popup (Recommended)
```powershell
.\tts-popup.ps1
```
- Visual interface with play/pause/stop controls
- Speed adjustment (slow/fast)
- Voice selection dropdown
- Auto-loads clipboard content

### Method 2: Quick Read (Fastest)
```powershell
.\quick-read.ps1                    # Read from clipboard
.\quick-read.ps1 "Your text here"   # Read text directly
```

### Method 3: Advanced Reader
```powershell
.\text-to-speech-reader.ps1
```
**Keyboard Controls:**
- `SPACE/P` - Pause/Resume
- `→/N` - Next sentence
- `←/B` - Previous sentence
- `↑/+` - Increase speed
- `↓/-` - Decrease speed
- `R` - Restart
- `Q/ESC` - Quit

### Method 4: Command Prompt
```cmd
speak.bat                           # Read from clipboard
speak.bat "Your text here"          # Read text directly
tts-popup.bat                       # Open GUI popup
```

## 🛠️ Installation

### Prerequisites
- Windows 10/11
- PowerShell 5.1+ (included in Windows)
- Windows Speech Platform (included in Windows)

### Install Options

#### Option 1: Complete Installation
```powershell
# Run the complete installer
.\Install-TTS-Complete.ps1
```

#### Option 2: Basic Installation
```powershell
# Run the main installer
.\install-tts.ps1
```

#### Option 3: Manual Setup
1. Copy all `.ps1` files to `%USERPROFILE%\TextToSpeech\`
2. Run scripts directly from that location

### What Gets Installed
- ✅ Desktop shortcuts: "Quick Read", "Text Reader", "TTS Popup"
- ✅ Start Menu folder: "Text-to-Speech"
- ✅ PowerShell aliases: `speak`, `tts`, `tts-popup`
- ✅ Installation folder: `%USERPROFILE%\TextToSpeech\`

## 🎯 Supported Text Sources

- ✅ **Web browsers** (Chrome, Edge, Firefox)
- ✅ **Documents** (Word, PDF, Notepad)
- ✅ **Emails** (Outlook, Gmail web)
- ✅ **Social media** (Twitter, Facebook, Reddit)
- ✅ **Development tools** (VS Code, IDEs)
- ✅ **Any selectable text** on Windows

## 🔧 Available Voices

The system uses Windows built-in voices:
- **Microsoft David Desktop** (Male)
- **Microsoft Hazel Desktop** (Female)
- **Microsoft Zira Desktop** (Female)

## 📖 Documentation

For detailed instructions, see:
- [`TTS-Setup-Guide.md`](TTS-Setup-Guide.md) - Complete setup and usage guide
- [`Quick-Start-Card.txt`](Quick-Start-Card.txt) - Quick reference card

## 🔧 Troubleshooting

### Common Issues

**Nothing happens when clicking shortcuts?**
```powershell
# Check PowerShell execution policy
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

**No sound/speech?**
- Check volume and speakers
- Verify Windows Speech service is running
- Test with: `Add-Type -AssemblyName System.Speech; (New-Object System.Speech.Synthesis.SpeechSynthesizer).Speak("Test")`

**Clipboard empty error?**
- Make sure to copy text first (`Ctrl+C`) before running the reader

## 🗑️ Uninstallation

```powershell
.\install-tts.ps1 -Uninstall
```

Or manually delete:
- Folder: `%USERPROFILE%\TextToSpeech\`
- Desktop shortcuts: "Quick Read", "Text Reader", "TTS Popup"
- Start Menu folder: "Text-to-Speech"

## 🏆 Why Use This?

### vs Browser Extensions
- ✅ Works in **all applications**, not just browsers
- ✅ No browser dependency
- ✅ Better voice quality (Windows native)
- ✅ More control options

### vs Online TTS Services
- ✅ **100% offline** - no internet required
- ✅ **Privacy** - text never leaves your computer
- ✅ **Faster** - instant processing
- ✅ **Always available** - works without connectivity

### vs Built-in Windows Narrator
- ✅ **Selective reading** - only read what you want
- ✅ **Better interface** - popup instead of full-screen overlay
- ✅ **More convenient** - designed for quick text snippets

## 📄 License

MIT License - Feel free to use, modify, and distribute.

## 🤝 Contributing

Contributions welcome! Feel free to:
- Report bugs
- Suggest features
- Submit pull requests
- Improve documentation

## 🎊 Enjoy Your Text-to-Speech System!

**Quick Workflow Reminder:**
```
Select Text → Copy (Ctrl+C) → Double-click "TTS Popup" → Click Play → Listen! 🔊
```