function Write-InfluxLog() {
    Param(
        [Parameter(Mandatory=$true)]
        [ValidateSet("DEBUG", "INFO", "WARN", "ERROR", "CRIT")]
        [string]$Level,

        [Parameter(Mandatory=$true)]
        [string]$Message
    )
    $url = "$global:influxurl/api/v2/write?org=$global:influxorg&bucket=$global:influxbucket&precision=ms"
    $headers = @{
        "Authorization" = "Token $global:influxtoken";
        "Content-Type" = "text/plain; charset=utf-8";
        "Accept" = "application/json"
    }
    $timestamp = Get-InfluxTimestamp
    $hostname = Get-Hostname
    $body = "$global:influxsource,level=$($Level.ToLower()),pid=$PID,$host=$hostname message=`"$($Message -replace('"', '\"'))`" $timestamp"

    $scriptblock = {
        param(
            [string]$url,
            [hashtable]$headers,
            [string]$body
        )
        Try {
            $response = Invoke-RestMethod -Method POST -Uri $url -Headers $headers -Body $body
        }
        Catch {
            Write-Host "Failed to write to InfluxDB: $($_.Exception.Message)" -ForegroundColor Red
            Write-Host "URL: $url"
            Write-Host "Body: $($body | ConvertTo-Json)"
        }
    }

    $jobid = [guid]::NewGuid().ToString()
    Start-Job -ScriptBlock $scriptblock -Name $jobid -ArgumentList @( $url, $headers, $body) | Out-Null
}