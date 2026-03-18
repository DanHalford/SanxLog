<#
.SYNOPSIS
Writes an informational message to the log

.DESCRIPTION
Writes an informational message to the log

.PARAMETER Message
The message to write to the log

.PARAMETER ForegroundColor
The foreground color to use when writing to the screen. Overrides the color set in the module preferences.

.PARAMETER BackgroundColor
The background color to use when writing to the screen. Overrides the color set in the module preferences.

.EXAMPLE
Write-LogInfo -Message "This is an informational message"

.EXAMPLE
Write-LogInfo -Message "This is an informational message" -ForegroundColor Green
#>
function Write-LogInfo() {
    Param(
        [Parameter(Mandatory=$true)]
        [string]$Message,

        [Parameter(Mandatory=$false)]
        [System.ConsoleColor]$ForegroundColor,

        [Parameter(Mandatory=$false)]
        [System.ConsoleColor]$BackgroundColor
    )
    if ($LogConfig.ValidConfig -eq $false) {
        Write-LogError -Message "Log configuration has not been set. Please call Set-Log before calling this function."
        return
    }
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
        "Elasticsearch" {
            Write-ElasticsearchLog -Level "INFO" -Message $Message
        }
    }
    $screenParams = @{ Level = "INFO"; Message = $Message }
    if ($PSBoundParameters.ContainsKey('ForegroundColor')) { $screenParams['ForegroundColor'] = $ForegroundColor }
    if ($PSBoundParameters.ContainsKey('BackgroundColor')) { $screenParams['BackgroundColor'] = $BackgroundColor }
    Write-ScreenLog @screenParams
}
