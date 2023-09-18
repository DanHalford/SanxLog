
function Write-FileLog() {
    Param(
        [Parameter(Mandatory=$true)]
        [ValidateSet("DEBUG", "INFO", "WARN", "ERROR", "CRIT")]
        [string]$Level,

        [Parameter(Mandatory=$true)]
        [string]$Message
    )

    $logline = Get-LogLine -Level $Level -Message $Message
    $logline | Out-File -FilePath $global:logpath -Append -Encoding "UTF8"
    Test-FileLogSize
}