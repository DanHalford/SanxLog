<#
.SYNOPSIS
Writes a warning message to the log

.DESCRIPTION
Writes a warning message to the log

.PARAMETER Message
The message to write to the log

.EXAMPLE
Write-Warn -Message "This is a warning message"
#>
function Write-Warn() {
    Param(
        [Parameter(Mandatory=$true)]
        [string]$Message
    )
    switch ($global:logtype) {
        "File" {
            Write-FileLog -Level "WARN" -Message $Message
        }
        "InfluxDB" {
            Write-InfluxLog -Level "WARN" -Message $Message
        }
        "Datadog" {
            Write-DatadogLog -Level "WARN" -Message $Message
        }
        "Loggly" {
            Write-LogglyLog -Level "WARN" -Message $Message
        }
        "SumoLogic" {
            Write-SumoLogicLog -Level "WARN" -Message $Message
        }
    }
    Write-ScreenLog -Level "WARN" -Message $Message
}