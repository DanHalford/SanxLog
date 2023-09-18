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
            if ($global:dlevel -eq "DEBUG") {
                Write-Host $logline -ForegroundColor Gray
            }
        }
        "INFO" {
            if ($global:dlevel -eq "DEBUG" -or $global:dlevel -eq "INFO") {
                Write-Host $logline
            }
        }
        "WARN" {
            if ($global:dlevel -eq "DEBUG" -or $global:dlevel -eq "INFO" -or $global:dlevel -eq "WARN") {
                Write-Host $logline -ForegroundColor Yellow
            }
        }
        "ERROR" {
            if ($global:dlevel -eq "DEBUG" -or $global:dlevel -eq "INFO" -or $global:dlevel -eq "WARN" -or $global:dlevel -eq "ERROR") {
                Write-Host $logline -ForegroundColor Red
            }
        }
        "CRIT" {
            if ($global:dlevel -eq "DEBUG" -or $global:dlevel -eq "INFO" -or $global:dlevel -eq "WARN" -or $global:dlevel -eq "ERROR" -or $global:dlevel -eq "CRIT") {
                Write-Host $logline -ForegroundColor Red -BackgroundColor White
            }
        }
    }
}