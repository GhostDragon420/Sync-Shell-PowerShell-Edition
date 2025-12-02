## 🔰 Sync-Shell: PowerShell Edition
**Author: *Jon Merriman / Juggalospsyco420*  
**Version: *1.0.0*  
**Created: *11-13-2025*  
**Requires: *PowerShell 7.0+*

------------------------------------------

## 🧠 Description

Sync-Shell is a PowerShell tool with a simple graphical interface. It remembers your command history, checks your syntax before running anything, and shows you a preview so you know exactly what will happen before execution. It’s built to run full commands safely and clearly, giving you control and confidence every step of the way.

------------------------------------------

─────────────────────────────────────────────────────────────

***## ⚠️ Warning — administrator privileges required***

─────────────────────────────────────────────────────────────

***Sync-shell may execute commands that require elevated privileges.***  
***The script does not automatically request administrator access.***

***Launching from a powershell instance running as admin will inherit full privileges.***  
***You can enable elevated execution by setting "run this program as administrator" in the file's properties.***

***Always review scripts before execution to avoid unintended system changes or errors.***	
***The author assumes no liability for misuse or system issues.***

─────────────────────────────────────────────────────────────


------------------------------------------

## 📋 Upcoming Features

- 🎨 **Enhanced Output Window** – Color-code errors, exceptions, and failures for easier readability; improve overall formatting. 
- 💾 **Autosave / Session Recovery** – Emergency recovery for the input/output boxes in case of crashes, power loss, or unexpected closures (standard save button remains for manual control).  
- 🖥️ **Shell Integration** – Add support for launching Windows cmd.exe when the user types CMD commands.  

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

## ‍💻 Beginner-friendly — no setup required

## 🚀 How to Use - `Sync-Shell-PowerShell-Script-Edition-v1.7z`

1. Extract the `.7z` archive  
2. Open PowerShell 7+  
3. Run `Sync-Shell-PWSH-v1.ps1` directly  
4. Use the GUI to write, preview, and run commands  
5. History is saved automatically across sessions

------------------------------------------

## ‍🔬 Intermediate — for users familiar with PowerShell modules

## 🚀 How to Use - `Sync-Shell-PowerShell-Module-Edition-v1.7z`

1. Extract the `.7z` archive
2. Open PowerShell 7+  
3. Run:	`Import-Module "<path>\Sync-Shell-PWSH.psm1"`
4. Launch with:	`Start-SyncShell`

-----------------------------------------

## ‍💻 Beginner-friendly — no setup required	

## 🚀 How to Use - Sync-Shell-PowerShell-Standalone-Edition-v1.7z

1. Extract the `.7z` archive to your preferred folder.
2. Launch with `Sync-Shell-PWSH.exe`
3. And enjoy!!

------------------------------------------

## 📁 Files Included with `Sync-Shell-PowerShell-Script-Edition-v1.7z` (`.ps1`)

- `Sync-Shell-PWSH-v1.ps1` — the standalone PowerShell script
- `readme.md` — this usage guide
- `License.txt` — terms of use
- `changelog.txt` — version/date/changelog

------------------------------------------

## 📁 Files Included with `Sync-Shell-PowerShell-Module-Edition-v1.7z` (`.psm1`)

- `Sync-Shell-PWSH.psm1` — the PowerShell module file
- `Sync-Shell-PWSH.psd1` — the module manifest with metadata and version info
- `readme.md` — this usage guide
- `License.txt` — terms of use
- `changelog.txt` — version/date/changelog 

------------------------------------------

## 📁 Files Included with `Sync-Shell-PowerShell-Standalone-Edition-v1.7z` (`.exe`)

- `Sync-Shell-PWSH.exe` — standalone executable file
- `readme.md` — this usage guide
- `License.txt` — terms of use
- `changelog.txt` — version/date/changelog

------------------------------------------
I used 7zip to make all the compressed files. Here is the site to download it if you need to.
[https://www.7-zip.org/](https://www.7-zip.org/)


## 🌐 Repository & Updates

This `.ps1` version is open-source and free to use.  
A `.psm1` version for Powershell Module with Manifest.  
A standalone `.exe` a standalone excutable made for those that dont know how to load a script yet. Does the same thing as `.ps1`.

Visit: [https://www.syncfirstessentials.com](https://www.syncfirstessentials.com)  
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

