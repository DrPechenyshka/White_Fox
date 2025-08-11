# White_Fox
My home project to study cybersecurity and try create my best in this direction 

# 🦊 White Fox - System Security Toolkit
```powershell
. . . . . . . . . . . . . . . . . . . .
. . . . . . . . . . . . . . . . . . . .
. . . . . . . /\. . . ./\ . . . . . . .
. . . . . . / [].\. ./.[] \ . . . . . .
. . . . . ./.{. } |_| { .}.\. . . . . .
. . . . . | .--- .\|/. ---. | . . . . .
. . . . . . . . . . . . . . . . . . . .
. . . . ./. / <:?>. .<?:> \ .\. . . . .
. . . . / / . . . . . . . . \ \ . . . .
. . . . < _ . .\! . . !/. . _ > . . . .
. . . . . . \_. \ _-_ / ._/ . . . . . .
. . . . . . . . ./_!_\. . . . . . . . .
. . . . . . . . . . . . . . . . . . . .
. . . .       WHITE FOX         . . . .
. . . .    KVRT + Hosts Tool    . . . .
. . . . . . . . . . . . . . . . . . . .
```
## 📌 Overview
Automated tool for:
- System scanning with KVRT (in-memory execution)
- Hosts file protection and reset
- DNS cache management

## 🚀 Quick Start

### Basic Usage
```powershell
powershell -ExecutionPolicy Bypass -File "$PATH\src\main.ps1"
```
Replace $PATH with your installation directory (e.g., C:\security_tools\white_fox)
## 🔧 Requirements
PowerShell 5.1+ (Windows)

Administrative rights (for full functionality)

Internet access (for KVRT updates)

## 🛡️ Security Notes
The script will:

Temporarily set execution policy to Bypass

Restore original policy on exit

## ❓ FAQ
Q: How to verify script integrity?
```powershell
Get-FileHash "$PATH\src\main.ps1" -Algorithm SHA256
```
Q: Script closes immediately?
Check logs:
```powershell
notepad "$PATH\whitefox.log"
```