function Enable-Protection {
    <#
    .SYNOPSIS
    Applies process and filesystem protection to prevent tampering
    #>
    try {
        # 1. Process protection - prevent termination
        $processId = $PID
        $rule = New-Object System.Security.AccessControl.ProcessAccessRule(
            "Everyone",
            [System.Security.AccessControl.ProcessAccessRights]::Terminate,
            [System.Security.AccessControl.AccessControlType]::Deny
        )
        
        $acl = Get-Acl -Path "Process/$processId"
        $acl.AddAccessRule($rule)
        Set-Acl -Path "Process/$processId" -AclObject $acl -ErrorAction Stop

        # 2. Filesystem protection - lock script directory
        $scriptPath = $PSScriptRoot
        $acl = Get-Acl -Path $scriptPath
        $acl.SetAccessRuleProtection($true, $false) # Block inheritance
        Set-Acl -Path $scriptPath -AclObject $acl -ErrorAction Stop

        Write-Host "[Security] Protection enabled (Process ID: $processId)" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Host "❌ Failed to enable protection: $_" -ForegroundColor Red
        return $false
    }
}

function Disable-Protection {
    <#
    .SYNOPSIS
    Restores default security settings
    #>
    try {
        # 1. Restore process permissions
        $processId = $PID
        $acl = Get-Acl -Path "Process/$processId"
        $acl.SetAccessRuleProtection($false, $true) # Allow inheritance
        Set-Acl -Path "Process/$processId" -AclObject $acl -ErrorAction Stop

        # 2. Restore filesystem permissions (optional)
        # $scriptPath = $PSScriptRoot
        # $acl = Get-Acl -Path $scriptPath
        # $acl.SetAccessRuleProtection($false, $true)
        # Set-Acl -Path $scriptPath -AclObject $acl

        Write-Host "[Security] Protection disabled" -ForegroundColor Yellow
        return $true
    }
    catch {
        Write-Host "⚠️ Warning: Could not fully disable protection: $_" -ForegroundColor DarkYellow
        return $false
    }
}

function Test-Protection {
    <#
    .SYNOPSIS
    Verifies if protection is active
    #>
    try {
        $processId = $PID
        $acl = Get-Acl -Path "Process/$processId"
        $rules = $acl.GetAccessRules($true, $true, [System.Security.Principal.NTAccount])
        
        foreach ($rule in $rules) {
            if ($rule.IdentityReference -eq "Everyone" -and 
                $rule.ProcessAccessRights -eq "Terminate" -and 
                $rule.AccessControlType -eq "Deny") {
                return $true
            }
        }
        return $false
    }
    catch {
        Write-Host " Protection test failed: $_" -ForegroundColor Red
        return $false
    }
}

Export-ModuleMember -Function Enable-Protection, Disable-Protection, Test-Protection