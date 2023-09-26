function Write-SumoLogicLog() {
    Param(
        [Parameter(Mandatory=$true)]
        [ValidateSet("DEBUG", "INFO", "WARN", "ERROR", "CRIT")]
        [string]$Level,

        [Parameter(Mandatory=$true)]
        [string]$Message
    )
    $url = $global:sumocollectorurl
    $hostname = Get-Hostname
    $processID = $PID.ToString()
    $body = @{
        timestamp = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ss.fffzzz")
        message = "[$($Level.ToLower())] $($Message -replace('"', '\"'))"
        source = "$global:sumosource"
        service = "$global:sumocategory"
        loglevel = "$($Level.ToUpper())"
        processid = "$processID"
        hostname = "$hostname"
    }
    $body += $global:sumometadata

    $scriptblock = {
        param(
            [string]$url,
            [hashtable]$body            
        )
        Try {
            $response = Invoke-RestMethod -Method POST -Uri $url -Body ($body | ConvertTo-Json)
        }
        Catch {
            Write-Host "Failed to write to Sumo Logic: $($_.Exception.Message)" -ForegroundColor Red
            Write-Host "URL: $url"
            Write-Host "Headers: $headers"
            Write-Host "Body: $($body | ConvertTo-Json)"
        }
    }
    $jobid = [guid]::NewGuid().ToString()
    Start-Job -ScriptBlock $scriptblock -Name $jobid -ArgumentList @( $url, $body) | Out-Null
}