function Write-ScreenLog() {
    param(
        [Parameter(Mandatory=$true)]
        [ValidateSet("DEBUG", "INFO", "WARN", "ERROR", "CRIT")]
        [string]$Level,

        [Parameter(Mandatory=$true)]
        [string]$Message
    )
    $logline = Get-LogLine -Level $Level -Message $Message
    switch ($Level) {
        "DEBUG" {
            if ($LogConfig.DLevel -eq "DEBUG") {
                Write-Host $logline -ForegroundColor $ScreenLogConfig.DebugBackgroundColor -BackgroundColor $ScreenLogConfig.DebugBackgroundColor
            }
        }
        "INFO" {
            if ($LogConfig.DLevel -eq "DEBUG" -or $LogConfig.DLevel -eq "INFO") {
                Write-Host $logline -ForegroundColor $ScreenLogConfig.InfoForegroundColor -BackgroundColor $ScreenLogConfig.InfoBackgroundColor
            }
        }
        "WARN" {
            if ($LogConfig.DLevel -eq "DEBUG" -or $LogConfig.DLevel -eq "INFO" -or $LogConfig.DLevel -eq "WARN") {
                Write-Host $logline -ForegroundColor $ScreenLogConfig.WarnForegroundColor -BackgroundColor $ScreenLogConfig.WarnBackgroundColor
            }
        }
        "ERROR" {
            if ($LogConfig.DLevel -eq "DEBUG" -or $LogConfig.DLevel -eq "INFO" -or $LogConfig.DLevel -eq "WARN" -or $LogConfig.DLevel -eq "ERROR") {
                Write-Host $logline -ForegroundColor $ScreenLogConfig.ErrorForegroundColor -BackgroundColor $ScreenLogConfig.ErrorBackgroundColor
            }
        }
        "CRIT" {
            if ($LogConfig.DLevel -eq "DEBUG" -or $LogConfig.DLevel -eq "INFO" -or $LogConfig.DLevel -eq "WARN" -or $LogConfig.DLevel -eq "ERROR" -or $LogConfig.DLevel -eq "CRIT") {
                Write-Host $logline -ForegroundColor $ScreenLogConfig.CritForegroundColor -BackgroundColor $ScreenLogConfig.CritBackgroundColor
            }
        }
    }
}