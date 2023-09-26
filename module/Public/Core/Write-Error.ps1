<#
.SYNOPSIS
Writes an error message to the log

.DESCRIPTION
Writes an error message to the log

.PARAMETER Message
The message to write to the log

.EXAMPLE
Write-Error -Message "This is an error message"
#>
function Write-Error() {
    Param(
        [Parameter(Mandatory=$true)]
        [string]$Message
    )
    switch ($global:logtype) {
        "File" {
            Write-FileLog -Level "ERROR" -Message $Message
        }
        "InfluxDB" {
            Write-InfluxLog -Level "ERROR" -Message $Message
        }
        "Datadog" {
            Write-DatadogLog -Level "ERROR" -Message $Message
        }
        "Loggly" {
            Write-LogglyLog -Level "ERROR" -Message $Message
        }
        "SumoLogic" {
            Write-SumoLogicLog -Level "ERROR" -Message $Message
        }
    }
    Write-ScreenLog -Level "ERROR" -Message $Message
}