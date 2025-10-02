@echo off
REM Quick Text-to-Speech from Command Prompt
REM Usage: speak.bat or speak.bat "your text here"

if "%~1"=="" (
    powershell -Command "& '$env:USERPROFILE\TextToSpeech\quick-read.ps1'"
) else (
    powershell -Command "& '$env:USERPROFILE\TextToSpeech\quick-read.ps1' '%*'"
)