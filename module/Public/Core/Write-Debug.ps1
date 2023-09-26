function Write-Debug() {
    Param(
        [Parameter(Mandatory=$true)]
        [string]$Message
    )
    switch ($global:logtype) {
        "File" {
            Write-FileLog -Level "DEBUG" -Message $Message
            Write-ScreenLog -Level "DEBUG" -Message $Message
        }
        "InfluxDB" {
            Write-InfluxLog -Level "DEBUG" -Message $Message
        }
        "Datadog" {
            Write-DatadogLog -Level "DEBUG" -Message $Message
        }
        "Loggly" {
            Write-LogglyLog -Level "DEBUG" -Message $Message
        }
        "SumoLogic" {
            Write-SumoLogicLog -Level "DEBUG" -Message $Message
        }
    }
    Write-ScreenLog -Level "DEBUG" -Message $Message
}