<#
.SYNOPSIS
Writes a warning message to the log

.DESCRIPTION
Writes a warning message to the log

.PARAMETER Message
The message to write to the log

.PARAMETER ForegroundColor
The foreground color to use when writing to the screen. Overrides the color set in the module preferences.

.PARAMETER BackgroundColor
The background color to use when writing to the screen. Overrides the color set in the module preferences.

.EXAMPLE
Write-LogWarn -Message "This is a warning message"

.EXAMPLE
Write-LogWarn -Message "This is a warning message" -ForegroundColor DarkYellow
#>
function Write-LogWarn() {
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
    $screenParams = @{ Level = "WARN"; Message = $Message }
    if ($PSBoundParameters.ContainsKey('ForegroundColor')) { $screenParams['ForegroundColor'] = $ForegroundColor }
    if ($PSBoundParameters.ContainsKey('BackgroundColor')) { $screenParams['BackgroundColor'] = $BackgroundColor }
    Write-ScreenLog @screenParams
}
