<#
.SYNOPSIS
Writes a debug message to the log

.DESCRIPTION
Writes a debug message to the log

.PARAMETER Message
The message to write to the log

.EXAMPLE
Write-LogDebug -Message "This is a debug message"
#>
function Write-LogDebug() {
    Param(
        [Parameter(Mandatory=$true)]
        [string]$Message
    )
    switch ($LogConfig.LogType) {
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