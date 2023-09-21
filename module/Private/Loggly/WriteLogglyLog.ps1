function Write-LogglyLog() {
    Param(
        [Parameter(Mandatory=$true)]
        [ValidateSet("DEBUG", "INFO", "WARN", "ERROR", "CRIT")]
        [string]$Level,

        [Parameter(Mandatory=$true)]
        [string]$Message
    )
    
    $tags = $global:logglytags
    $tags += "level.$($Level.ToUpper())"
    $tagstring = $tags | ForEach-Object { $_.Trim().Replace(" ", "_") } | Join-String -Separator ","

    $url = "https://logs-01.loggly.com/inputs/$global:logglytoken/tag/$tagstring/"
    $headers = @{
        "Content-Type" = "application/json";
        "Accept" = "application/json"
    }
    $hostname = Get-Hostname
    $processID = $PID.ToString()
    $body = @{
        message = "[$($Level.ToLower())] [$processID] $($Message -replace('"', '\"'))"
        level = "$($Level.ToUpper())"
        source = "$global:logglysource"
        service = "$global:logglyservice"
        processID = "$processID"
        hostname = "$hostname"
    }

    $scriptblock = {
        param(
            [string]$url,
            [hashtable]$headers,
            [hashtable]$body
        )
        Try {
            $response = Invoke-RestMethod -Method POST -Uri $url -Headers $headers -Body ($body | ConvertTo-Json)
            Write-Host "Loggly response: $($response | ConvertTo-Json)"
        }
        Catch {
            Write-Host "Failed to write to Loggly: $($_.Exception.Message)" -ForegroundColor Red
            Write-Host "URL: $url"
            Write-Host "Body: $($body | ConvertTo-Json)"
        }
    }

    $jobid = [guid]::NewGuid().ToString()
    Start-Job -ScriptBlock $scriptblock -Name $jobid -ArgumentList @( $url, $headers, $body) | Out-Null
}