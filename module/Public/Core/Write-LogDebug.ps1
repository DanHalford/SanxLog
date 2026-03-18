<#
.SYNOPSIS
Writes a debug message to the log

.DESCRIPTION
Writes a debug message to the log

.PARAMETER Message
The message to write to the log

.PARAMETER ForegroundColor
The foreground color to use when writing to the screen. Overrides the color set in the module preferences.

.PARAMETER BackgroundColor
The background color to use when writing to the screen. Overrides the color set in the module preferences.

.EXAMPLE
Write-LogDebug -Message "This is a debug message"

.EXAMPLE
Write-LogDebug -Message "This is a debug message" -ForegroundColor Cyan -BackgroundColor DarkBlue
#>
function Write-LogDebug() {
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
            Write-FileLog -Level "DEBUG" -Message $Message
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
        "Elasticsearch" {
            Write-ElasticsearchLog -Level "DEBUG" -Message $Message
        }
    }
    $screenParams = @{ Level = "DEBUG"; Message = $Message }
    if ($PSBoundParameters.ContainsKey('ForegroundColor')) { $screenParams['ForegroundColor'] = $ForegroundColor }
    if ($PSBoundParameters.ContainsKey('BackgroundColor')) { $screenParams['BackgroundColor'] = $BackgroundColor }
    Write-ScreenLog @screenParams
}
