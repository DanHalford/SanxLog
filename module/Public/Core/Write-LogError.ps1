<#
.SYNOPSIS
Writes an error message to the log

.DESCRIPTION
Writes an error message to the log

.PARAMETER Message
The message to write to the log

.PARAMETER ForegroundColor
The foreground color to use when writing to the screen. Overrides the color set in the module preferences.

.PARAMETER BackgroundColor
The background color to use when writing to the screen. Overrides the color set in the module preferences.

.EXAMPLE
Write-LogError -Message "This is an error message"

.EXAMPLE
Write-LogError -Message "This is an error message" -ForegroundColor White -BackgroundColor Red
#>
function Write-LogError() {
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
        "Elasticsearch" {
            Write-ElasticsearchLog -Level "ERROR" -Message $Message
        }
    }
    $screenParams = @{ Level = "ERROR"; Message = $Message }
    if ($PSBoundParameters.ContainsKey('ForegroundColor')) { $screenParams['ForegroundColor'] = $ForegroundColor }
    if ($PSBoundParameters.ContainsKey('BackgroundColor')) { $screenParams['BackgroundColor'] = $BackgroundColor }
    Write-ScreenLog @screenParams
}
