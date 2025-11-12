## 🔰 Sync-Shell: PowerShell Edition
**Author: *Jon Merriman / Juggalospsyco420*
**Version: *1.0.0*  
**Created: *11-12-2025*
**Requires: *PowerShell 7.0+*

------------------------------------------

## 🧠 Description

Sync-Shell is a PowerShell tool with a simple graphical interface. It remembers your command history, checks your syntax before running anything, and shows you a preview so you know exactly what will happen before execution. It’s built to run full commands safely and clearly, giving you control and confidence every step of the way

------------------------------------------

─────────────────────────────────────────────────────────────

***## ⚠️ Warning — administrator privileges required***

─────────────────────────────────────────────────────────────

Sync-shell may execute commands that require elevated privileges.
The script does not automatically request administrator access.
- Launching from a powershell instance running as admin
  will inherit full privileges.
- You can enable elevated execution by setting
  "run this program as administrator" in the file's properties.

Always review scripts before execution to avoid unintended
system changes or errors.
The author assumes no liability for misuse or system issues.

─────────────────────────────────────────────────────────────

------------------------------------------

## 📋 Upcoming Features

- 🔄 **GitHub Auto-Update** – Check the GitHub repo for script updates; if a new version is available, prompt the user to update. The script will download, install, and restart automatically, elevating to admin if needed.  
- ⚠️ **Startup Admin Warning** – Display a legal-style message box or banner about administrator privileges on launch.  
- 🛡️ **Admin Status Indicator** – Show a visual indicator (Yes/No) if the script is running with administrator rights.  
- 🎨 **Enhanced Output Window** – Color-code errors, exceptions, and failures for easier readability; improve overall formatting.  
- 💾 **Autosave / Session Recovery** – Emergency recovery for the input/output boxes in case of crashes, power loss, or unexpected closures (standard save button remains for manual control).  
- 🆔 **Version Display** – Show the current version (v1.0.0) prominently in the main GUI window.  
- 🖥️ **Shell Integration** – Add support for launching Windows cmd.exe when the user types CMD commands.  
- 📦 **Multi-Format Packaging** – Distribute in three formats:  
  - .exe standalone version  ***COMING SOON***
  - .psm1 module version with manifest  ***COMING SOON***
  - .ps1 script version  ***DONE***
- 🚀 **GitHub Release** – Prepare a proper release on GitHub with all three formats attached.  
- 📝 **Changelog & Future Plans** – Complete the v1.0.0 changelog and outline plans for future versions.

------------------------------------------

## ⚙️ Features

- Syntax validation using `PSParser`
- Preview window for manual review before execution
- Ctrl+Enter or “Run” button to execute scripts
- “Save Script” to export `.ps1` files
- Persistent history logging to `script_history.txt`
- PowerShell Core toggle
- Output parsing with error highlighting

------------------------------------------

## 🚀 How to Use - `.ps1` version

1. Launch `Sync-Shell-PWSH.ps1` in PowerShell 7+
2. Write your script in the input box
3. Click **Preview** to review before running
4. Press **Ctrl+Enter** or click **Run** to execute
5. Use **Save Script** to export your code
6. History is auto-saved and loaded across sessions

------------------------------------------

## 🚀 How to Use - `.psm1` ZIP ***COMING SOON***

***COMING SOON***

------------------------------------------

## 🚀 How to Use - `.exe` ZIP ***COMING SOON***

***COMING SOON***

------------------------------------------


## 📁 Files Included with `.exe` Zip ***COMING SOON***

- `Sync-Shell-PWSH.exe` — stand alone excutable file ***COMING SOON***
- `README.md` — this usage guide
- `LICENSE.txt` — terms of use
- `changelog.txt` — version/date/changelog ***COMING SOON***

------------------------------------------

## 📁 Files Included with `.ps1` Zip

- `Sync-Shell-PWSH.ps1` — the open-source PowerShell module
- `README.md` — this usage guide
- `LICENSE.txt` — terms of use
- `changelog.txt` — version/date/changelog

------------------------------------------

## 📁 Files Included with `.psm1` Zip ***COMING SOON***

- `Sync-Shell-PWSH.psm1` — ***COMING SOON***
- `Sync-Shell-PWSH.manifest` — ***COMING SOON***
- `README.md` — this usage guide
- `LICENSE.txt` — terms of use
- `changelog.txt` — version/date/changelog ***COMING SOON***

------------------------------------------

## 🌐 Repository & Updates

This `.ps1` version is open-source and free to use.  
A standalone `.exe` version with auto-updater will be available separately. ***COMING SOON***
A `.psm1` version for Powershell Module with Manifest. ***COMING SOON***

Visit: [https://sync-first-essentials.com](https://sync-first-essentials.com)  
GitHub: [https://github.com/GhostDragon420/Sync-Shell-PowerShell-Edition](https://github.com/GhostDragon420/Sync-Shell-PowerShell-Edition)

------------------------------------------

## 🤝 Support & Collaboration

Sync-Shell is built for clarity, discipline, and reliable execution.  
Feedback is welcome — whether it's bug reports, improvement ideas, or collaboration proposals.

To reach out:
- Open an issue or discussion on GitHub:  
  [https://github.com/GhostDragon420/Sync-Shell-PowerShell-Edition/issues](https://github.com/GhostDragon420/Sync-Shell-PowerShell-Edition/issues)

All contributions and insights are appreciated.  
Please respect the original source, version history, and author credit.

------------------------------------------

## 🛡️ Legal

© 2025 Jon Merriman / Juggalospsyco420 — All Rights Reserved  
This module is part of Sync-First Essentials, built on the Sync-First Gate framework.


