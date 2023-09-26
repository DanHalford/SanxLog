<#
.SYNOPSIS
Writes an informational message to the log

.DESCRIPTION
Writes an informational message to the log

.PARAMETER Message
The message to write to the log

.EXAMPLE
Write-LogInfo -Message "This is an informational message"
#>
function Write-LogInfo() {
    Param(
        [Parameter(Mandatory=$true)]
        [string]$Message
    )
    switch ($LogConfig.LogType) {
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