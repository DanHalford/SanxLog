<#
.SYNOPSIS
Writes a warning message to the log

.DESCRIPTION
Writes a warning message to the log

.PARAMETER Message
The message to write to the log

.EXAMPLE
Write-LogWarn -Message "This is a warning message"
#>
function Write-LogWarn() {
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
        "Elasticsearch" {
            Write-ElasticsearchLog -Level "WARN" -Message $Message
        }
    }
    Write-ScreenLog -Level "WARN" -Message $Message
}