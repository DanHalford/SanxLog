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
    Invoke-RestMethod -Method POST -Uri $url -Headers $headers -Body $body
}