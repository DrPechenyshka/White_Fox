function Reset-HostsAndDNS {
    [CmdletBinding()]
    param()

    $defaultHosts = @"
# Restored by White Fox
127.0.0.1 localhost
::1 localhost
"@

    try {
        # Reset hosts file
        Write-Host "Resetting hosts file..." -ForegroundColor Cyan
        $hostsPath = "C:\Windows\System32\drivers\etc\hosts"
        
        if (-not (Test-Path $hostsPath)) {
            New-Item -Path $hostsPath -ItemType File -Force | Out-Null
        }
        
        $defaultHosts | Out-File -FilePath $hostsPath -Encoding UTF8 -Force

        # Flush DNS
        Write-Host "Clearing DNS cache..." -ForegroundColor Cyan
        Clear-DnsClientCache

        Write-Host " Hosts and DNS reset successfully!" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Host " Error: $_" -ForegroundColor Red
        Write-Host "Administrator rights required!" -ForegroundColor Yellow
        return $false
    }
}

Export-ModuleMember -Function Reset-HostsAndDNS