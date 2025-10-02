# 🎤 Text-to-Speech Popup System - Complete Setup Guide

## 📋 Table of Contents
- [Quick Start (Already Installed)](#quick-start-already-installed)
- [Fresh Installation Guide](#fresh-installation-guide)
- [Usage Instructions](#usage-instructions)
- [Available Options](#available-options)
- [Troubleshooting](#troubleshooting)
- [Uninstallation](#uninstallation)

---

## ⚡ Quick Start (Already Installed)

If you've already run the installation, you can start using the system immediately:

### 🖱️ **Desktop Shortcuts (Easiest Method)**
Look for these shortcuts on your desktop:
- **"Quick Read"** - Instant clipboard reading
- **"Text Reader"** - Advanced controls
- **"TTS Popup"** - Visual popup interface *(Recommended)*

### 🎯 **How to Use Right Now:**
1. **Select any text** in Chrome, Word, or any application
2. **Copy it** with `Ctrl+C`
3. **Double-click "TTS Popup"** on your desktop
4. **Click "Play"** in the popup window
5. **Listen!** 🔊

---

## 🛠️ Fresh Installation Guide

### **Step 1: Download the Installation Script**

Open PowerShell and run:
```powershell
# Navigate to your desired folder
cd "C:\Users\$env:USERNAME\Documents"

# Download or create the installation files
# (The scripts should be in your current directory)
```

### **Step 2: Run the Installer**

```powershell
# Run the installation script
.\install-tts.ps1
```

**Expected Output:**
```
Installing Text-to-Speech System...
Created installation directory: C:\Users\YourName\TextToSpeech
Scripts copied to installation directory
Created command aliases: tts, speak, read-clip
Created desktop shortcuts
Created Start Menu shortcuts

=== INSTALLATION COMPLETE ===
```

### **Step 3: Verify Installation**

Check that these items were created:
- ✅ Folder: `C:\Users\YourName\TextToSpeech`
- ✅ Desktop shortcuts: "Quick Read", "Text Reader", "TTS Popup"
- ✅ Start Menu folder: "Text-to-Speech"

---

## 🎮 Usage Instructions

### 🖼️ **Method 1: GUI Popup (Recommended)**

**Perfect for beginners and daily use!**

1. **Open the Popup:**
   - Double-click **"TTS Popup"** on desktop, OR
   - Search "TTS Popup" in Start Menu, OR
   - Run: `& "$env:USERPROFILE\TextToSpeech\tts-popup.ps1"`

2. **Use the Interface:**
   ```
   ┌─────────────────────────────────┐
   │     Text-to-Speech Reader       │
   ├─────────────────────────────────┤
   │ Enter text or auto-load from    │
   │ clipboard:                      │
   │ ┌─────────────────────────────┐ │
   │ │ [Text appears here...]      │ │
   │ │                             │ │
   │ └─────────────────────────────┘ │
   │                                 │
   │ [Load Clipboard] [Clear]        │
   │                                 │
   │ [Play] [Stop] Speed: [<<] [>>]  │
   │                                 │
   │ Voice: [Microsoft Zira ▼]       │
   │                                 │
   │ Status: Ready to speak!         │
   └─────────────────────────────────┘
   ```

3. **Quick Workflow:**
   - Copy text from anywhere (`Ctrl+C`)
   - Open TTS Popup
   - Text auto-loads automatically
   - Click **"Play"**
   - Enjoy! 🎵

### ⚡ **Method 2: Quick Read (Fastest)**

**Perfect for instant reading!**

1. Copy any text (`Ctrl+C`)
2. Double-click **"Quick Read"** desktop shortcut
3. Text speaks immediately (no interface)

### 🎛️ **Method 3: Advanced Reader (Power Users)**

**Perfect for long documents with navigation!**

1. Copy text or have file ready
2. Double-click **"Text Reader"** shortcut
3. Use keyboard controls:
   - `SPACE/P` - Pause/Resume
   - `→/N` - Next sentence
   - `←/B` - Previous sentence
   - `↑/+` - Faster speed
   - `↓/-` - Slower speed
   - `R` - Restart
   - `Q/ESC` - Quit

### 💻 **Method 4: PowerShell Commands**

**After restarting PowerShell:**
```powershell
speak           # Quick clipboard reading
tts             # Advanced reader
tts-popup       # Open GUI popup
read-clip       # Same as speak
```

---

## 🎯 Available Options

### **Desktop Shortcuts:**
- **"Quick Read"** - Instant, no interface
- **"Text Reader"** - Keyboard-controlled navigation
- **"TTS Popup"** - Visual popup interface

### **Start Menu:**
- Search "Text-to-Speech" folder
- Contains all shortcuts

### **Direct Script Access:**
- Location: `C:\Users\YourName\TextToSpeech\`
- Files: `quick-read.ps1`, `text-to-speech-reader.ps1`, `tts-popup.ps1`

### **Available Voices:**
- Microsoft David Desktop (Male)
- Microsoft Hazel Desktop (Female)
- Microsoft Zira Desktop (Female)

---

## 🔧 Troubleshooting

### **Problem: Nothing happens when I click shortcuts**

**Solution 1: Check PowerShell Execution Policy**
```powershell
# Run as Administrator
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

**Solution 2: Run directly**
```powershell
& "$env:USERPROFILE\TextToSpeech\tts-popup.ps1"
```

### **Problem: "Access Denied" during installation**

**Solution: Run without admin (user installation)**
The installer automatically creates a user-space installation if admin rights aren't available.

### **Problem: No sound/speech**

**Check these:**
1. Volume is up
2. Speakers/headphones connected
3. Windows Speech service is running:
   ```powershell
   # Test speech directly
   Add-Type -AssemblyName System.Speech
   $speak = New-Object System.Speech.Synthesis.SpeechSynthesizer
   $speak.Speak("Test")
   ```

### **Problem: Clipboard is empty error**

**Solution:** Make sure you copy text first (`Ctrl+C`) before running the reader.

### **Problem: GUI doesn't open**

**Solution:** Run directly:
```powershell
powershell.exe -Command "& '$env:USERPROFILE\TextToSpeech\tts-popup.ps1'"
```

---

## 🗑️ Uninstallation

### **Complete Removal:**
```powershell
# Run the uninstaller
.\install-tts.ps1 -Uninstall
```

### **Manual Removal:**
1. Delete folder: `C:\Users\YourName\TextToSpeech`
2. Delete desktop shortcuts: "Quick Read", "Text Reader", "TTS Popup"
3. Delete Start Menu folder: "Text-to-Speech"
4. Remove PowerShell profile entries (optional)

---

## 🎉 Success Verification

### **Test Your Installation:**

1. **Copy this text:** `"Hello, this is a test of my text-to-speech system!"`
2. **Double-click "TTS Popup"** on desktop
3. **Click "Play"** in the popup
4. **Listen for speech** 🔊

If you hear the text spoken aloud, **congratulations! Your system is working perfectly!** 🎊

---

## 📞 Quick Reference

### **Daily Usage Workflow:**
```
Select Text → Copy (Ctrl+C) → Double-click "TTS Popup" → Click Play
```

### **File Locations:**
- **Installation:** `%USERPROFILE%\TextToSpeech\`
- **Shortcuts:** Desktop and Start Menu
- **Profile:** `%USERPROFILE%\Documents\WindowsPowerShell\`

### **Supported Text Sources:**
- ✅ Web pages (Chrome, Edge, Firefox)
- ✅ Documents (Word, PDF, Notepad)
- ✅ Emails (Outlook, Gmail)
- ✅ Social media (Twitter, Facebook)
- ✅ Any selectable text on Windows

---

## 🏆 You Now Have:

🎯 **Chrome Extension-like Experience**
🖱️ **One-Click Desktop Access**  
🎮 **Multiple Usage Methods**
🔊 **Professional Text-to-Speech**
⚡ **Instant Clipboard Reading**
🎛️ **Advanced Controls Available**

**Enjoy your new text-to-speech system!** 🚀