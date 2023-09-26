function Write-Info() {
    Param(
        [Parameter(Mandatory=$true)]
        [string]$Message
    )
    switch ($global:logtype) {
        "File" {
            Write-FileLog -Level "INFO" -Message $Message
        }
        "InfluxDB" {
            Write-InfluxLog -Level "INFO" -Message $Message
        }
        "Datadog" {
            Write-DatadogLog -Level "INFO" -Message $Message
        }
        "Loggly" {
            Write-LogglyLog -Level "INFO" -Message $Message
        }
        "SumoLogic" {
            Write-SumoLogicLog -Level "INFO" -Message $Message
        }
    }
    Write-ScreenLog -Level "INFO" -Message $Message
}