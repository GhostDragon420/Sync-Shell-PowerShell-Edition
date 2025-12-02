@{
    # Module metadata
    RootModule        = 'Sync-Shell-PWSH-v1.psm1'
    ModuleVersion     = '1.0.0'
    GUID              = 'd3e5f7a2-9c4b-4c1f-bb7e-420f1a7e9a99'  # You can generate a new GUID if needed
    Author            = 'Jon Merriman / Juggalospsyco420'
    CompanyName       = 'Sync-First Essentials'
    Copyright         = '© 2025 Jon Merriman. All rights reserved.'
    Description       = 'Sync-Shell: PowerShell Edition — A syntax-aware, history-persistent GUI runner with preview-before-execute safety and mapped output parsing.'

    # PowerShell compatibility
    PowerShellVersion = '7.0'
    CompatiblePSEditions = @('Core', 'Desktop')

    # Module components
    FunctionsToExport   = @('Start-SyncShell')  # Update if you expose more functions
    CmdletsToExport     = @()
    VariablesToExport   = @()
    AliasesToExport     = @()

    # Optional metadata
    PrivateData = @{
        PSData = @{
            Tags         = @('PowerShell', 'GUI', 'Sync-Shell', 'ShellRunner', 'MappedExecution')
            LicenseUri   = 'https://license.syncfirstessentials.com'
            ProjectUri   = 'https://github.com/GhostDragon420/Sync-Shell-PowerShell-Edition'
            IconUri      = ''
            ReleaseNotes = 'Initial release of Sync-Shell PowerShell Edition. Includes syntax validation, preview window, persistent history, and mapped output parsing.'
        }
    }

}

