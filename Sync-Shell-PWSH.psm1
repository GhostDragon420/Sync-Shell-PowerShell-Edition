# ┌────────────────────────────────────────────────────────────┐
# │ 🔰 Sync-Shell: PowerShell Module                           │
# │ A Sync-Shell Module          			                   │
# └────────────────────────────────────────────────────────────┘
# Core Framework: Sync-Shell
# Module Type: Shell GUI Interface
# Shell Target: PowerShell (Windows/Core)
# Author: Jon Merriman (Sync-First Gate)
# Version: 1.0.0
# Requires -Version 7.0
# Created: 11-12-2025
# Description:
#   Syntax-aware, history-persistent PowerShell runner with mapped output parsiync-Shell is a PowerShell tool with a simple graphical interface. It remembers your command history, checks your syntax before running anything, and shows you exactly what will happen before it does it. It’s designed to run full commands safely and clearly, so you stay in control.

# ─────────────────────────────────────────────────────────────
# PowerShell Version Check
# ─────────────────────────────────────────────────────────────
if ($PSVersionTable.PSVersion.Major -lt 7) {
	Write-Host "❌ This module requires PowerShell 7.0 or higher." -ForegroundColor Red
	Write-Host "Detected PowerShell version: $($PSVersionTable.PSVersion)" -ForegroundColor Yellow
return
}




# --- Utility functions ---
function Test-Syntax {
	param([string]$code)

	$errors = $null
	[System.Management.Automation.PSParser]::Tokenize($code, [ref]$errors) | Out-Null
	return $errors
}

# --- Command History ---
$commandHistory = New-Object System.Collections.Generic.List[string]
$historyIndex = -1

# --- Sync-Shell-Core ---
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# --- Main form ---
$form = New-Object System.Windows.Forms.Form
$form.Text = "PowerShell Script Runner"
$form.Size = New-Object System.Drawing.Size(800, 600)
$form.StartPosition = "CenterScreen"
$form.TopMost = $false


# --- Working Directory Label (moved to top) ---
$cwdLabel = New-Object System.Windows.Forms.Label
$cwdLabel.Dock = "Bottom"
$cwdLabel.Height = 20
$cwdLabel.Font = New-Object System.Drawing.Font("Consolas", 10)
$form.Controls.Add($cwdLabel)
$updateCWD = {
	$cwdLabel.Text = "Working Dir: $(Get-Location)"
	}

$timer = New-Object System.Windows.Forms.Timer
$timer.Interval = 1000
$timer.Add_Tick($updateCWD)
$timer.Start()

# --- Unified Log Box (Top) ---
$outputBox = New-Object System.Windows.Forms.RichTextBox
$outputBox.Multiline = $true
$outputBox.ScrollBars = "Both"
$outputBox.WordWrap = $false
$outputBox.ReadOnly = $true
$outputBox.Dock = "Fill"
$outputBox.Height = 320
$outputBox.Font = New-Object System.Drawing.Font("Consolas", 10)
$form.Controls.Add($outputBox)

# --- Input inputBox (Bottom half) ---
$inputBox = New-Object System.Windows.Forms.RichTextBox
$inputBox.Multiline = $true
$inputBox.ScrollBars = "Both"
$inputBox.WordWrap = $false
$inputBox.Dock = "Bottom"
$inputBox.Height = 220
$inputBox.Font = New-Object System.Drawing.Font("Consolas", 10)
$inputBox.Text = ">>>> "
$form.Controls.Add($inputBox)

# --- Run Script ---
$runScript = {
	$scriptText = ($inputBox.Text -replace '^>{2,}\s*', '').Trim()
	if (![string]::IsNullOrWhiteSpace($scriptText)) {
		$timestamp = (Get-Date).ToString("MM-dd-yyyy HH:mm:ss")
		$outputBox.AppendText("[$timestamp] Executing: $scriptText`r`n")
		
		$errors = Test-Syntax $scriptText
		if ($errors.Count -gt 0) {
			$msg = "Syntax errors detected:`r`n" + ($errors | ForEach-Object { $_.Message }) -join "`r`n"
			$outputBox.SelectionColor = [System.Drawing.Color]::Red        # for errors
			$outputBox.AppendText("[$timestamp] Syntax check failed:`r`n$msg`r`n")
			$outputBox.SelectionStart = $outputBox.Text.Length
			$outputBox.ScrollToCaret()
			[System.Windows.Forms.MessageBox]::Show($msg, "Syntax Check Failed", 'OK', 'Error')
			$inputBox.Text = ">>>> "
			$inputBox.SelectionStart = $inputBox.Text.Length			
		return
		}
		else {
			$outputBox.SelectionColor = [System.Drawing.Color]::DarkGreen  # for success
			$outputBox.AppendText("[$timestamp] Syntax check passed.`r`n")
		}
	if ($scriptText -match '^cd\s+("?~.*"?|".+?"|\".+?\"|.+)$') {
    $targetDir = if ($Matches[1]) { $Matches[1].Trim('''"\') } else { $HOME }
    try {
        Set-Location $targetDir
        $outputBox.AppendText("[$timestamp] Changed directory to: $(Get-Location)`r`n")
    } catch {
        $outputBox.AppendText("[$timestamp] Failed to change directory: $_`r`n")
    }
		$inputBox.Text = ">>>> "
		$inputBox.SelectionStart = $inputBox.Text.Length
    return
}
		$tempFile = [System.IO.Path]::GetTempFileName() + ".ps1"
		Set-Content -Path $tempFile -Value $scriptText -Encoding UTF8
		$output = & pwsh -NoProfile -ExecutionPolicy Bypass -File $tempFile 2>&1
		Remove-Item $tempFile -ErrorAction SilentlyContinue

		$timestamp = (Get-Date).ToString("MM-dd-yyyy HH:mm:ss")
		$outputBox.AppendText("[$timestamp] PS $(Get-Location)> $scriptText`r`n")
		$outputBox.AppendText(($output -join "`r`n") + "`r`n")
		
		if ($scriptText -notmatch "(--help|\s-h\s|/\?)" -and ($output | Select-String -Pattern '\b(Exception|Error|Failed)\b')) {
			$outputBox.BackColor = [System.Drawing.Color]::MistyRose
		}
		$commandHistory.Add($scriptText)
		$historyIndex = $commandHistory.Count
		$inputBox.Text = ">>>> "
		$inputBox.SelectionStart = $inputBox.Text.Length
		$outputBox.SelectionStart = $outputBox.Text.Length
		$outputBox.ScrollToCaret()
	}
}

$inputBox.Add_KeyDown({
	if ($_.KeyCode -eq "Enter" -and $_.Shift) {
		# Allow newline
		return
	}
	elseif ($_.KeyCode -eq "Enter") {
		$_.SuppressKeyPress = $true
		& $runScript
	}

	elseif ($_.KeyCode -eq "Up") {
		if ($commandHistory.Count -gt 0) {
			$historyIndex = [Math]::Max(0, $historyIndex - 1)
			$inputBox.Text = $commandHistory[$historyIndex]
			$inputBox.SelectionStart = $inputBox.Text.Length
		}
	}

	elseif ($_.KeyCode -eq "Down") {
		if ($commandHistory.Count -gt 0) {
			$historyIndex = [Math]::Min($commandHistory.Count - 1, $historyIndex + 1)
			$inputBox.Text = $commandHistory[$historyIndex]
			$inputBox.SelectionStart = $inputBox.Text.Length
		}
	}
	elseif ($_.KeyCode -eq "Tab") {
	$_.SuppressKeyPress = $true

		# Refresh known commands dynamically
		$knownCommands = Get-Command | Where-Object { $_.CommandType -in 'Cmdlet','Function','Alias' } | Select-Object -ExpandProperty Name
		$inputLine = $inputBox.Text.TrimStart(">").Trim()
		$match = $knownCommands | Where-Object { $_ -like "$inputLine*" }

		if ($match.Count -eq 1) {
			$inputBox.Text = ">>>> $($match[0])"
			$inputBox.SelectionStart = $inputBox.Text.Length
		}
		elseif ($match.Count -gt 1) {
			$outputBox.AppendText("Autocomplete options:`r`n" + ($match -join "`r`n") + "`r`n")
			$outputBox.SelectionStart = $outputBox.Text.Length
			$outputBox.ScrollToCaret()
		}
	}
})

# --- Preview Button ---
$btnPreview = New-Object System.Windows.Forms.Button
$btnPreview.Text = "Preview"
$btnPreview.Dock = "Left"
$btnPreview.Width = 100

# --- Run Button ---
$btnRun = New-Object System.Windows.Forms.Button
$btnRun.Text = "Run"
$btnRun.Dock = "Fill"
$btnRun.Width = 100

# --- Clear Output/Log Button ---
$btnClearLog = New-Object System.Windows.Forms.Button
$btnClearLog.Text = "Clear Output"
$btnClearLog.Dock = "Right"
$btnClearLog.Width = 100
$btnClearLog.Add_Click({ $outputBox.Clear() })

# --- Clear Input Button ---
$btnClear = New-Object System.Windows.Forms.Button
$btnClear.Text = "Clear Input"
$btnClear.Dock = "Left"
$btnClear.Width = 100
$btnClear.Add_Click({ $inputBox.Clear() })

# --- Save Button ---
$btnSave = New-Object System.Windows.Forms.Button
$btnSave.Text = "Save Script"
$btnSave.Dock = "Right"
$btnSave.Width = 100
$btnSave.Add_Click({
	$dialog = New-Object System.Windows.Forms.SaveFileDialog
	$dialog.Filter = "PowerShell Script (*.ps1)|*.ps1"
	if ($dialog.ShowDialog() -eq "OK") {
		Set-Content -Path $dialog.FileName -Value $inputBox.Text -Encoding UTF8
	}
})

# --- Add padding using a Panel for bottom buttons ---
$panel = New-Object System.Windows.Forms.Panel
$panel.Dock = "Bottom"
$panel.Height = 60
$panel.Controls.AddRange(@($btnRun, $btnClear, $btnClearLog, $btnPreview, $btnSave))
$form.Controls.Add($panel)

# --- Preview First Script ---
$btnPreview.Add_Click({
	$previewForm = New-Object System.Windows.Forms.Form
	$previewForm.Text = "Preview Script"
	$previewForm.Size = New-Object System.Drawing.Size(600, 400)
	$previewForm.StartPosition = "CenterScreen"
	$previewForm.TopMost = $true

	$previewBox = New-Object System.Windows.Forms.RichTextBox
	$previewBox.Multiline = $true
	$previewBox.ScrollBars = "Both"
	$previewBox.WordWrap = $false
	$previewBox.Font = New-Object System.Drawing.Font("Consolas", 10)
	$previewBox.ReadOnly = $true
	$previewBox.Dock = "Fill"
	$previewBox.Text = $inputBox.Text
	$previewForm.Controls.Add($previewBox)

	# --- Creating Bottom Button Panel ---
	$buttonPanel = New-Object System.Windows.Forms.Panel
	$buttonPanel.Dock = "Bottom"
	$buttonPanel.Height = 40

	# --- Execute Button ---
	$btnExecutePreview = New-Object System.Windows.Forms.Button
	$btnExecutePreview.Text = "Execute"
	$btnExecutePreview.Dock = "Left"
	$btnExecutePreview.Width = 100
	$btnExecutePreview.Font = New-Object System.Drawing.Font("Consolas", 10)
	$btnExecutePreview.Add_Click({
		$inputBox.Text = $previewBox.Text
		& $runScript
		$previewForm.Close()
	})

	# --- Back Button ---
	$btnBack = New-Object System.Windows.Forms.Button
	$btnBack.Text = "Back"
	$btnBack.Dock = "Right"
	$btnBack.Width = 100
	$btnBack.Font = New-Object System.Drawing.Font("Consolas", 10)
	$btnBack.Add_Click({ $previewForm.Close() })
	
	# --- Add Button Pannel ---
	$buttonPanel.Controls.AddRange(@($btnExecutePreview, $btnBack))
	$previewForm.Controls.Add($buttonPanel)
	
	# --- Show the preview window ---
	$previewForm.ShowDialog()
	})

# --- Show form ---
$form.ShowDialog()

# ─────────────────────────────────────────────────────────────
# Sync-Shell Module Execution Complete
# Timestamp: $(Get-Date -Format "MM-dd-yyyy HH:mm:ss")
# Exit Status: Success
# © [2025] [Jon Merriman/Juggalospsyco420] – All Rights Reserved
# ─────────────────────────────────────────────────────────────