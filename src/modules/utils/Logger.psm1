<#
.SYNOPSIS
Logging module for White Fox
#>

$logDir = Join-Path $PSScriptRoot "..\..\logs"
if (-not (Test-Path $logDir)) { New-Item -ItemType Directory -Path $logDir -Force | Out-Null }

function Write-Log {
    param(
        [string]$Message,
        [ValidateSet("INFO","WARNING","ERROR")]
        [string]$Level = "INFO"
    )
    
    $logFile = Join-Path $logDir "whitefox_$(Get-Date -Format 'yyyyMMdd').log"
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content -Path $logFile -Value "[$timestamp][$Level] $Message" -Encoding UTF8
    
    if ($Level -eq "ERROR") {
        Write-Host $Message -ForegroundColor Red
    }
    elseif ($Level -eq "WARNING") {
        Write-Host $Message -ForegroundColor Yellow
    }
}

Export-ModuleMember -Function Write-Log