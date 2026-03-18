function Write-ScreenLog() {
    param(
        [Parameter(Mandatory=$true)]
        [ValidateSet("DEBUG", "INFO", "WARN", "ERROR", "CRIT")]
        [string]$Level,

        [Parameter(Mandatory=$true)]
        [string]$Message,

        [Parameter(Mandatory=$false)]
        [System.ConsoleColor]$ForegroundColor,

        [Parameter(Mandatory=$false)]
        [System.ConsoleColor]$BackgroundColor
    )
    $logline = Get-LogLine -Level $Level -Message $Message
    switch ($Level) {
        "DEBUG" {
            if ($LogConfig.DLevel -eq "DEBUG") {
                $fg = if ($PSBoundParameters.ContainsKey('ForegroundColor')) { $ForegroundColor } else { $ScreenLogConfig.DebugForegroundColor }
                $bg = if ($PSBoundParameters.ContainsKey('BackgroundColor')) { $BackgroundColor } else { $ScreenLogConfig.DebugBackgroundColor }
                Write-Host $logline -ForegroundColor $fg -BackgroundColor $bg
            }
        }
        "INFO" {
            if ($LogConfig.DLevel -eq "DEBUG" -or $LogConfig.DLevel -eq "INFO") {
                $fg = if ($PSBoundParameters.ContainsKey('ForegroundColor')) { $ForegroundColor } else { $ScreenLogConfig.InfoForegroundColor }
                $bg = if ($PSBoundParameters.ContainsKey('BackgroundColor')) { $BackgroundColor } else { $ScreenLogConfig.InfoBackgroundColor }
                Write-Host $logline -ForegroundColor $fg -BackgroundColor $bg
            }
        }
        "WARN" {
            if ($LogConfig.DLevel -eq "DEBUG" -or $LogConfig.DLevel -eq "INFO" -or $LogConfig.DLevel -eq "WARN") {
                $fg = if ($PSBoundParameters.ContainsKey('ForegroundColor')) { $ForegroundColor } else { $ScreenLogConfig.WarnForegroundColor }
                $bg = if ($PSBoundParameters.ContainsKey('BackgroundColor')) { $BackgroundColor } else { $ScreenLogConfig.WarnBackgroundColor }
                Write-Host $logline -ForegroundColor $fg -BackgroundColor $bg
            }
        }
        "ERROR" {
            if ($LogConfig.DLevel -eq "DEBUG" -or $LogConfig.DLevel -eq "INFO" -or $LogConfig.DLevel -eq "WARN" -or $LogConfig.DLevel -eq "ERROR") {
                $fg = if ($PSBoundParameters.ContainsKey('ForegroundColor')) { $ForegroundColor } else { $ScreenLogConfig.ErrorForegroundColor }
                $bg = if ($PSBoundParameters.ContainsKey('BackgroundColor')) { $BackgroundColor } else { $ScreenLogConfig.ErrorBackgroundColor }
                Write-Host $logline -ForegroundColor $fg -BackgroundColor $bg
            }
        }
        "CRIT" {
            if ($LogConfig.DLevel -eq "DEBUG" -or $LogConfig.DLevel -eq "INFO" -or $LogConfig.DLevel -eq "WARN" -or $LogConfig.DLevel -eq "ERROR" -or $LogConfig.DLevel -eq "CRIT") {
                $fg = if ($PSBoundParameters.ContainsKey('ForegroundColor')) { $ForegroundColor } else { $ScreenLogConfig.CritForegroundColor }
                $bg = if ($PSBoundParameters.ContainsKey('BackgroundColor')) { $BackgroundColor } else { $ScreenLogConfig.CritBackgroundColor }
                Write-Host $logline -ForegroundColor $fg -BackgroundColor $bg
            }
        }
    }
}
