<#
.SYNOPSIS
Writes a critical message to the log

.DESCRIPTION
Writes a critical message to the log

.PARAMETER Message
The message to write to the log

.EXAMPLE
Write-LogCritical -Message "This is a critical message"
#>
function Write-LogCritical() {
    Param(
        [Parameter(Mandatory=$true)]
        [string]$Message
    )
    if ($LogConfig.ValidConfig -eq $false) {
        Write-LogError -Message "Log configuration has not been set. Please call Set-Log before calling this function."
        return
    }
    switch ($LogConfig.LogType) {
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
        "SumoLogic" {
            Write-SumoLogicLog -Level "CRIT" -Message $Message
        }
    }
    Write-ScreenLog -Level "CRIT" -Message $Message
}