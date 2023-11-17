function Write-LogglyLog() {
    Param(
        [Parameter(Mandatory=$true)]
        [ValidateSet("DEBUG", "INFO", "WARN", "ERROR", "CRIT")]
        [string]$Level,

        [Parameter(Mandatory=$true)]
        [string]$Message
    )

    $tags = $LogglyLogConfig.Tags
    $tags += "level.$($Level.ToUpper())"
    $tagstring = $tags | ForEach-Object { $_.Trim().Replace(" ", "_") } | Join-String -Separator ","

    $url = "https://logs-01.loggly.com/inputs/$($LogglyLogConfig.Token)/tag/$tagstring/"
    $headers = @{
        "Content-Type" = "application/json";
        "Accept" = "application/json"
    }
    $hostname = Get-Hostname
    $body = @{
        message = "[$($Level.ToLower())] [$($PID.ToString())] $($Message -replace('"', '\"'))"
        level = "$($Level.ToUpper())"
        source = $LogglyLogConfig.Source
        service = $LogglyLogConfig.Service
        processID = $PID.ToString()
        hostname = $hostname
    }

    $scriptblock = {
        param(
            [string]$url,
            [hashtable]$headers,
            [hashtable]$body
        )
        Try {
            Invoke-RestMethod -Method POST -Uri $url -Headers $headers -Body ($body | ConvertTo-Json) | Out-Null
        }
        Catch {
            Write-Error "Failed to write to Loggly: $($_.Exception.Message)"
            Write-Information "URL: $url"
            Write-Information "Body: $($body | ConvertTo-Json)"
        }
    }

    $jobid = [guid]::NewGuid().ToString()
    Start-Job -ScriptBlock $scriptblock -Name $jobid -ArgumentList @( $url, $headers, $body) | Out-Null
}