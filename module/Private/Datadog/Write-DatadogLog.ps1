function Write-DatadogLog() {
    Param(
        [Parameter(Mandatory=$true)]
        [ValidateSet("DEBUG", "INFO", "WARN", "ERROR", "CRIT")]
        [string]$Level,

        [Parameter(Mandatory=$true)]
        [string]$Message
    )
    $url = "https://http-intake.logs.$($DatadogLogConfig.URL)/api/v2/logs"
    $headers = @{
        "DD-API-KEY" = $DatadogLogConfig.APIKey
        "Content-Type" = "application/json";
        "Accept" = "application/json"
    }
    $tags = $DatadogLogConfig.Tags
    $tags += "level:$($Level.ToUpper()))"
    $hostname = Get-Hostname
    $processID = $PID.ToString()
    $body = @{
        message = "[$($Level.ToLower())] [$processID] $($Message -replace('"', '\"'))"
        ddsource = $DatadogLogConfig.Source
        service = $DatadogLogConfig.Service
        ddtags = "$($tags -join " ")"
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
            Write-Error "Failed to write to Datadog: $($_.Exception.Message)"
            Write-Information "URL: $url"
            Write-Information "Headers: $headers"
            Write-Information "Body: $($body | ConvertTo-Json)"
        }
    }
    $jobid = [guid]::NewGuid().ToString()
    Start-Job -ScriptBlock $scriptblock -Name $jobid -ArgumentList @( $url, $headers, $body) | Out-Null
}