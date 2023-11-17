function Write-SumoLogicLog() {
    Param(
        [Parameter(Mandatory=$true)]
        [ValidateSet("DEBUG", "INFO", "WARN", "ERROR", "CRIT")]
        [string]$Level,

        [Parameter(Mandatory=$true)]
        [string]$Message
    )
    $url = $SumoLogConfig.CollectorURL
    $hostname = Get-Hostname
    $body = @{
        timestamp = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ss.fffzzz")
        message = "[$($Level.ToLower())] $($Message -replace('"', '\"'))"
        source = $SumoLogConfig.Source
        service = $SumoLogConfig.Category
        loglevel = "$($Level.ToUpper())"
        processid = $PID.ToString()
        hostname = $hostname
    }
    $body += $global:sumometadata

    $scriptblock = {
        param(
            [string]$url,
            [hashtable]$body
        )
        Try {
            Invoke-RestMethod -Method POST -Uri $url -Body ($body | ConvertTo-Json) | Out-Null
        }
        Catch {
            Write-Error "Failed to write to Sumo Logic: $($_.Exception.Message)"
            Write-Information "URL: $url"
            Write-Information "Headers: $headers"
            Write-Information "Body: $($body | ConvertTo-Json)"
        }
    }
    $jobid = [guid]::NewGuid().ToString()
    Start-Job -ScriptBlock $scriptblock -Name $jobid -ArgumentList @( $url, $body) | Out-Null
}