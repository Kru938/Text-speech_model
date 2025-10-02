@echo off
REM Text-to-Speech GUI Popup from Command Prompt
REM Usage: tts-popup.bat

powershell -WindowStyle Hidden -Command "& '$env:USERPROFILE\TextToSpeech\tts-popup.ps1'"