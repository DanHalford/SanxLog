function Write-InfluxLog() {
    Param(
        [Parameter(Mandatory=$true)]
        [ValidateSet("DEBUG", "INFO", "WARN", "ERROR", "CRIT")]
        [string]$Level,

        [Parameter(Mandatory=$true)]
        [string]$Message
    )
    $url = "$($InfluxLogConfig.URL)/api/v2/write?org=$($InfluxLogConfig.Org)&bucket=$($InfluxLogConfig.Bucket)&precision=ms"
    $headers = @{
        "Authorization" = "Token $($InfluxLogConfig.Token)";
        "Content-Type" = "text/plain; charset=utf-8";
        "Accept" = "application/json"
    }
    $timestamp = Get-InfluxTimestamp
    $hostname = Get-Hostname
    $body = "$($InfluxLogConfig.Source),level=$($Level.ToLower()),pid=$PID,$host=$hostname message=`"$($Message -replace('"', '\"'))`" $timestamp"

    $scriptblock = {
        param(
            [string]$url,
            [hashtable]$headers,
            [string]$body
        )
        Try {
            Invoke-RestMethod -Method POST -Uri $url -Headers $headers -Body $body | Out-Null
        }
        Catch {
            Write-Error "Failed to write to InfluxDB: $($_.Exception.Message)"
            Write-Information "URL: $url"
            Write-Information "Body: $($body | ConvertTo-Json)"
        }
    }

    $jobid = [guid]::NewGuid().ToString()
    Start-Job -ScriptBlock $scriptblock -Name $jobid -ArgumentList @( $url, $headers, $body) | Out-Null
}