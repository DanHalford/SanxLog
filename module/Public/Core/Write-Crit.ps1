function Write-Crit() {
    Param(
        [Parameter(Mandatory=$true)]
        [string]$Message
    )
    switch ($global:logtype) {
        "File" {
            Write-FileLog -Level "CRIT" -Message $Message
        }
        "InfluxDB" {
            Write-InfluxLog -Level "CRIT" -Message $Message
        }
        "Datadog" {
            Write-DatadogLog -Level "CRIT" -Message $Message
        }
        "Loggly" {
            Write-LogglyLog -Level "CRIT" -Message $Message
        }
    }
    Write-ScreenLog -Level "CRIT" -Message $Message
}