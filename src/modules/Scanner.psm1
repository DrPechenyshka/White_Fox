function Start-KVRTScan {
    [CmdletBinding()]
    param()

    try {
        $tempDir = "$env:TEMP\WhiteFox\"
        $kvrtPath = Join-Path -Path $tempDir -ChildPath "KVRT.exe"
        
        if (-not (Test-Path $kvrtPath)) {
            Write-Host "Downloading KVRT..." -ForegroundColor Cyan
            New-Item -ItemType Directory -Path $tempDir -Force | Out-Null
            Invoke-WebRequest -Uri "https://devbuilds.s.kaspersky-labs.com/devbuilds/KVRT/latest/full/KVRT.exe" -OutFile $kvrtPath
        }

        Write-Host "Starting scan..." -ForegroundColor Cyan
        Start-Process -FilePath $kvrtPath -ArgumentList "-accepteula -dontencrypt -silent" -Wait
        
        Write-Host " Scan completed successfully!" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Host " Error: $_" -ForegroundColor Red
        return $false
    }
}

Export-ModuleMember -Function Start-KVRTScan