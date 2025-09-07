<#
.SYNOPSIS
White Fox - System Security and Hosts Management Tool
#>

#region Initialization
param (
    [switch]$ScanOnly,
    [switch]$FixHostsOnly,
    [switch]$CheckProtection
)

# 1. Initialize paths
$modulePath = Join-Path -Path $PSScriptRoot -ChildPath "modules"

# 2. Custom pause function (replacement for missing Pause-Exit)
function Pause-Exit {
    Write-Host "Press any key to exit..." -ForegroundColor Yellow
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
    exit 1
}

# 3. Simplified logger (temporary)
function Write-Log {
    param([string]$Message)
    $logFile = Join-Path $PSScriptRoot "..\whitefox.log"
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content -Path $logFile -Value "[$timestamp] $Message" -Encoding UTF8
    Write-Host $Message -ForegroundColor Cyan
}

try {
    # 4. Load modules (with basic logging)
    Write-Log "Loading modules..."
    
    $modules = @(
        "Scanner.psm1",
        "HostsManager.psm1", 
        "UI.psm1",
        "utils\AntiTamper.psm1"
    )

    foreach ($module in $modules) {
        $fullPath = Join-Path $modulePath $module
        if (Test-Path $fullPath) {
            Import-Module $fullPath -Force -ErrorAction Stop
            Write-Log "Loaded: $module"
        }
        else {
            Write-Log "ERROR: Missing $module"
            Pause-Exit
        }
    }

    # 5. Main logic
    if ($CheckProtection) {
        Write-Log "Checking protection status..."
        Show-ProtectionStatus
    }
    elseif ($ScanOnly) {
        Write-Log "Starting scan..."
        Start-ScanWithAnimation
    }
    elseif ($FixHostsOnly) {
        Write-Log "Resetting hosts..."
        Reset-HostsWithAnimation
    }
    else {
        Write-Log "Starting interactive mode..."
        Show-MainMenu
    }
}
catch {
    Write-Host "ERROR: $_" -ForegroundColor Red
    Write-Log "ERROR: $_"
    Pause-Exit
}
finally {
    Write-Log "Cleanup completed"
    Write-Host "Operation finished. Check whitefox.log for details." -ForegroundColor Green
    Start-Sleep -Seconds 3
}
#endregion