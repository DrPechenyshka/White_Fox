function Show-MainMenu {
    <#
    .SYNOPSIS
    Displays the main interactive menu for White Fox tool
    #>
    while ($true) {
        Clear-Host
        Show-AsciiArt
        Write-Host "`n WHITE FOX - System Security Toolkit`n" -ForegroundColor Cyan

        # Menu Options
        Write-Host "1. Run System Scan (KVRT)" -ForegroundColor Green
        Write-Host "2. Reset Hosts & Flush DNS" -ForegroundColor Yellow
        Write-Host "3. View Protection Status" -ForegroundColor Magenta
        Write-Host "Q. Exit`n" -ForegroundColor Red

        $choice = Read-Host "Select action [1/2/3/Q]"

        switch ($choice) {
            "1" { 
                if (Get-Confirmation "Start system scan?") { 
                    Start-ScanWithAnimation
                }
            }
            "2" { 
                if (Get-Confirmation "Reset hosts file and DNS cache?") {
                    Reset-HostsWithAnimation
                }
            }
            "3" {
                Show-ProtectionStatus
            }
            "Q" { Exit-Program }
            default { 
                Write-Host "Invalid selection!" -ForegroundColor Red
                Start-Sleep -Seconds 1
            }
        }
    }
}

function Get-Confirmation {
    <#
    .SYNOPSIS
    Gets user confirmation for critical actions
    .PARAMETER Message
    The confirmation prompt to display
    #>
    param(
        [string]$Message
    )
    
    do {
        $response = Read-Host "$Message [Y/N]"
        if ($response -notmatch '^[yYnN]$') {
            Write-Host "Please enter Y or N" -ForegroundColor Yellow
        }
    } until ($response -match '^[yYnN]$')
    
    return $response -match '^[yY]$'
}

function Show-AsciiArt {
    <#
    .SYNOPSIS
    Displays the White Fox ASCII art logo
    #>
    Write-Host @"
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
"@ -ForegroundColor Cyan
}

function Show-LoadingAnimation {
    <#
    .SYNOPSIS
    Displays a spinning progress animation
    .PARAMETER Text
    The text to display with animation
    .PARAMETER Duration
    Animation duration in seconds (default: 2)
    #>
    param(
        [string]$Text,
        [int]$Duration = 2
    )
    
    $spinner = @('|', '/', '-', '\')
    $endTime = (Get-Date).AddSeconds($Duration)
    
    while ((Get-Date) -lt $endTime) {
        foreach ($frame in $spinner) {
            Write-Host "`r$Text $frame" -NoNewline -ForegroundColor Blue
            Start-Sleep -Milliseconds 100
        }
    }
    Write-Host "`r$Text " -NoNewline
    Write-Host "{da}" -ForegroundColor Green
}

function Show-ProtectionStatus {
    <#
    .SYNOPSIS
    Displays current security protection status
    #>
    try {
        $status = Test-Protection
        Clear-Host
        Show-AsciiArt
        Write-Host "`n PROTECTION STATUS`n" -ForegroundColor Yellow
        
        if ($status) {
            Write-Host " [ ACTIVE ] " -ForegroundColor Black -BackgroundColor Green -NoNewline
            Write-Host " Process termination protection enabled" -ForegroundColor Green
        }
        else {
            Write-Host " [ INACTIVE ] " -ForegroundColor Black -BackgroundColor Red -NoNewline
            Write-Host " No active protection" -ForegroundColor Red
        }
        
        Write-Host "`n Process ID: $PID" -ForegroundColor Cyan
        Write-Host " Script Path: $PSScriptRoot" -ForegroundColor Cyan
        Pause-Exit
    }
    catch {
        Write-Host "Error checking protection status: $_" -ForegroundColor Red
    }
}

function Pause-Exit {
    <#
    .SYNOPSIS
    Pauses script execution before exit
    #>
    Write-Host "`nPress any key to continue..." -ForegroundColor Gray
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
}

function Exit-Program {
    <#
    .SYNOPSIS
    Gracefully exits the program
    #>
    Write-Host "`nExiting White Fox..." -ForegroundColor Magenta
    Start-Sleep -Seconds 1
    exit
}

Export-ModuleMember -Function Show-MainMenu, Get-Confirmation, Show-AsciiArt, 
                     Show-LoadingAnimation, Pause-Exit, Exit-Program, 
                     Show-ProtectionStatus