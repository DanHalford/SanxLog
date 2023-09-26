function Write-DatadogLog() {
    Param(
        [Parameter(Mandatory=$true)]
        [ValidateSet("DEBUG", "INFO", "WARN", "ERROR", "CRIT")]
        [string]$Level,

        [Parameter(Mandatory=$true)]
        [string]$Message
    )
    $url = "https://http-intake.logs.$global:datadogsite/api/v2/logs"
    $headers = @{
        "DD-API-KEY" = "$global:datadogapikey";
        "Content-Type" = "application/json";
        "Accept" = "application/json"
    }
    $tags = $global:datadogtags
    $tags += "level:$($Level.ToUpper()))"
    $hostname = Get-Hostname
    $processID = $PID.ToString()
    $body = @{
        message = "[$($Level.ToLower())] [$processID] $($Message -replace('"', '\"'))"
        ddsource = "$global:datadogsource"
        service = "$global:datadogservice"
        ddtags = "$($tags -join " ")"
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
        }
        Catch {
            Write-Host "Failed to write to Datadog: $($_.Exception.Message)" -ForegroundColor Red
            Write-Host "URL: $url"
            Write-Host "Headers: $headers"
            Write-Host "Body: $($body | ConvertTo-Json)"
        }
    }
    $jobid = [guid]::NewGuid().ToString()
    Start-Job -ScriptBlock $scriptblock -Name $jobid -ArgumentList @( $url, $headers, $body) | Out-Null
}