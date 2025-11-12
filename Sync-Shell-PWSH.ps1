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
# Created: 2025-11-12
# Description:
#   Syntax-aware, history-persistent PowerShell runner with mapped output parsing.
#   Built for block command execution with sync-first clarity.

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



# --- PowerShell GUI Script Runner with History and Run on Enter ---
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# --- Main form ---
$form = New-Object System.Windows.Forms.Form
$form.Text = "PowerShell Script Runner"
$form.Size = New-Object System.Drawing.Size(800, 600)
$form.StartPosition = "CenterScreen"
$form.TopMost = $true

# --- History TextBox (Top half) ---
$historyBox = New-Object System.Windows.Forms.TextBox
$historyBox.Multiline = $true
$historyBox.ScrollBars = "Vertical"
$historyBox.WordWrap = $false
$historyBox.ReadOnly = $true
$historyBox.Dock = "Top"
$historyBox.Height = 280
$historyBox.Font = New-Object System.Drawing.Font("Consolas", 10)
$form.Controls.Add($historyBox)

# --- Working Directory Label (moved to top) ---
$cwdLabel = New-Object System.Windows.Forms.Label

$cwdLabel.Dock = "Top"
$cwdLabel.Height = 20
$cwdLabel.Font = New-Object System.Drawing.Font("Consolas", 9)
$form.Controls.Add($cwdLabel)
$updateCWD = {
	$cwdLabel.Text = "Working Dir: $(Get-Location)"
	}

$timer = New-Object System.Windows.Forms.Timer
$timer.Interval = 1000
$timer.Add_Tick($updateCWD)
$timer.Start()

# --- Input TextBox (Bottom half) ---
$textbox = New-Object System.Windows.Forms.TextBox
$textbox.Multiline = $true
$textbox.ScrollBars = "Vertical"
$textbox.WordWrap = $false
$textbox.Dock = "Top"
$textbox.Height = 180
$textbox.Font = New-Object System.Drawing.Font("Consolas", 10)
$form.Controls.Add($textbox)

# --- Run Button ---
$btnRun = New-Object System.Windows.Forms.Button
$btnRun.Text = "Run"
$btnRun.Dock = "Left"
$btnRun.Width = 100

# --- Clear Button ---
$btnClear = New-Object System.Windows.Forms.Button
$btnClear.Text = "Clear Input"
$btnClear.Dock = "Right"
$btnClear.Width = 100

# --- Preview Button (Re-added) ---
$btnPreview = New-Object System.Windows.Forms.Button
$btnPreview.Text = "Preview"
$btnPreview.Dock = "Fill"

$btnSave = New-Object System.Windows.Forms.Button
$btnSave.Text = "Save Script"
$btnSave.Dock = "Right"
$btnSave.Width = 100
$btnSave.Add_Click({
	$dialog = New-Object System.Windows.Forms.SaveFileDialog
	$dialog.Filter = "PowerShell Script (*.ps1)|*.ps1"
	if ($dialog.ShowDialog() -eq "OK") {
		Set-Content -Path $dialog.FileName -Value $textbox.Text -Encoding UTF8
	}
})


# --- Adding Checkbox ---
$chkCore = New-Object System.Windows.Forms.CheckBox
$chkCore.Text = "Use PowerShell Core"
$chkCore.Dock = "Right"


# --- Add padding using a Panel for bottom buttons ---
$panel = New-Object System.Windows.Forms.Panel
$panel.Dock = "Bottom"
$panel.Height = 60
$panel.Controls.AddRange(@($btnRun, $btnClear, $btnPreview, $btnSave, $chkCore))
$form.Controls.Add($panel)

# --- History storage ---
$historyList = New-Object System.Collections.Generic.List[string]
$historyPath = "$env:USERPROFILE\script_history.txt"
	if (Test-Path $historyPath) {
		try {
			Get-Content $historyPath -Encoding UTF8 | 
				Where-Object { $_.Trim() -ne "" } | 
				ForEach-Object { $historyList.Add($_) }
			} catch {
			$timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
			$historyList.Add("[$timestamp] Failed to load history: $($_.Exception.Message)")
		}
	}
	function Scroll-HistoryBox {$historyBox.SelectionStart = $historyBox.Text.Length
		$historyBox.ScrollToCaret()
	}	
	$historyBox.Lines = $historyList.ToArray()
Scroll-HistoryBox

$form.Add_FormClosing({
	Set-Content -Path $historyPath -Value $historyList -Encoding UTF8
})



# --- Run Script ---
$runScript = {
	$scriptText = $textbox.Text.Trim()
	if (![string]::IsNullOrWhiteSpace($scriptText)) {

		# --- Syntax validation ---
		$errors = Test-Syntax $scriptText
		if ($errors.Count -gt 0) {
			$msg = "Syntax errors detected:`r`n" +($errors | ForEach-Object { $_.Message }) -join "`r`n"
			$timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
			$historyList.Add("[$timestamp] Syntax check failed:" + ($errors | ForEach-Object { $_.Message }) -join "; ")
			$historyBox.Lines = $historyList.ToArray()
			Scroll-HistoryBox

			[System.Windows.Forms.MessageBox]::Show(
				$msg,
				"Syntax Check Failed",
				'OK',
				'Error'
			 )
			return  # stop here if invalid
		} # end syntax check IF

		# --- Execution path ---
		$tempFile = [System.IO.Path]::GetTempFileName() + ".ps1"
			Set-Content -Path $tempFile -Value $scriptText -Encoding UTF8
		$exe = if ($chkCore.Checked) { "pwsh" } else { "powershell" }
		$output = & $exe -NoProfile -ExecutionPolicy Bypass -File $tempFile 2>&1
			Remove-Item $tempFile -ErrorAction SilentlyContinue

		# --- History logging ---
		$timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
		$historyList.Add("[$timestamp] PS $(Get-Location)> $scriptText")
		$historyBox.Lines = $historyList.ToArray()
		Scroll-HistoryBox

		# --- Output window ---
		$outputForm = New-Object System.Windows.Forms.Form
		$outputForm.Text = "Script Output"
		$outputForm.Size = New-Object System.Drawing.Size(700, 400)
		$outputForm.StartPosition = "CenterScreen"
		$outputForm.TopMost = $true
		$outputForm.BringToFront()

		$outputBox = New-Object System.Windows.Forms.TextBox
		$outputBox.Multiline = $true
		$outputBox.ScrollBars = "Both"
		$outputBox.WordWrap = $false
		$outputBox.Font = New-Object System.Drawing.Font("Consolas", 10)
		$outputBox.ReadOnly = $true
		$outputBox.Dock = "Fill"
		$outputBox.Text = $output -join "`r`n"
		$outputForm.Controls.Add($outputBox)
		$scriptIsHelp = $scriptText -match "(--help|\s-h\s|/\?)"



		$trigger = $output | Select-String -Pattern '\b(Exception|Error|Failed)\b' 
			if (-not $scriptIsHelp -and $trigger) {
				$outputBox.BackColor = [System.Drawing.Color]::MistyRose
			Write-Host "Highlight triggered by: $($output | Select-String 'Exception|Error|Failed')"
				}
		        $outputForm.Show()
	}
}


# --- Hook Run button and Enter key ---
$btnRun.Add_Click($runScript)
$textbox.Add_KeyDown({
	if ($_.KeyCode -eq "Enter" -and $_.Modifiers -eq "Control") {
		$_.SuppressKeyPress = $true
		& $runScript
	}
})

# --- Clear input box ---
$btnClear.Add_Click({ $textbox.Clear() })

# --- Preview First Script ---
$btnPreview.Add_Click({
	$previewForm = New-Object System.Windows.Forms.Form
	$previewForm.Text = "Preview Script"
	$previewForm.Size = New-Object System.Drawing.Size(600, 400)
	$previewForm.StartPosition = "CenterScreen"
	$previewForm.TopMost = $true

	$previewBox = New-Object System.Windows.Forms.TextBox
	$previewBox.Multiline = $true
	$previewBox.ScrollBars = "Both"
	$previewBox.WordWrap = $false
	$previewBox.Font = New-Object System.Drawing.Font("Consolas", 10)
	$previewBox.ReadOnly = $true
	$previewBox.Dock = "Fill"
	$previewBox.Text = $textbox.Text
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
		$textbox.Text = $previewBox.Text
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
	$previewForm.Controls.Add(buttonPanel)
	
	# --- Show the preview window ---
	$previewForm.ShowDialog()
	})


# --- Show form ---
$form.ShowDialog()

# ─────────────────────────────────────────────────────────────
# Sync-Shell Module Execution Complete
# Timestamp: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
# Exit Status: Success
# © [2025] [Jon Merriman/Juggalospsyco420] – All Rights Reserved
# ─────────────────────────────────────────────────────────────