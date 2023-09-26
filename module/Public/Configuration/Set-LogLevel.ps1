function Set-LogLevel () {
    param(
        [Parameter(Mandatory=$true)]
        [ValidateSet("DEBUG", "INFO", "WARN", "ERROR", "CRIT")]
        [string]$LogLevel,

        [ValidateSet("DEBUG", "INFO", "WARN", "ERROR", "CRIT", "NONE")]
        [string]$DisplayLevel
    )
    $LogConfig.LLevel = $LogLevel
    if ($DisplayLevel) {
        $LogConfig.DLevel = $DisplayLevel
    }
    else {
        $LogConfig.DLevel  = $LogLevel
    }
}