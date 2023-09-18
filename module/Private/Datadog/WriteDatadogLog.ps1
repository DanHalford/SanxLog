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
    $tags += "level:$($Level.ToUpper))"
    $hostname = Get-Hostname
    $processID = $PID.ToString()
    $body = @{
        message = "[$($Level.ToLower())] [$processID] $($Message -replace('"', '\"'))"
        ddsource = "$global:datadogsource"
        service = "$global:datadogservice"
        ddtags = "$($tags -join " ")"
        hostname = "$hostname"
    }
    Invoke-RestMethod -Method POST -Uri $url -Headers $headers -Body ($body | ConvertTo-Json)
}