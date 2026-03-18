<#
.SYNOPSIS
Writes a critical message to the log

.DESCRIPTION
Writes a critical message to the log

.PARAMETER Message
The message to write to the log

.PARAMETER ForegroundColor
The foreground color to use when writing to the screen. Overrides the color set in the module preferences.

.PARAMETER BackgroundColor
The background color to use when writing to the screen. Overrides the color set in the module preferences.

.EXAMPLE
Write-LogCritical -Message "This is a critical message"

.EXAMPLE
Write-LogCritical -Message "This is a critical message" -ForegroundColor White -BackgroundColor DarkRed
#>
function Write-LogCritical() {
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
        "Elasticsearch" {
            Write-ElasticsearchLog -Level "CRIT" -Message $Message
        }
    }
    $screenParams = @{ Level = "CRIT"; Message = $Message }
    if ($PSBoundParameters.ContainsKey('ForegroundColor')) { $screenParams['ForegroundColor'] = $ForegroundColor }
    if ($PSBoundParameters.ContainsKey('BackgroundColor')) { $screenParams['BackgroundColor'] = $BackgroundColor }
    Write-ScreenLog @screenParams
}
