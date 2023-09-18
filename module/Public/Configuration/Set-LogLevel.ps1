function Set-LogLevel () {
    param(
        [Parameter(Mandatory=$true)]
        [ValidateSet("DEBUG", "INFO", "WARN", "ERROR", "CRIT")]
        [string]$LogLevel,
        
        [ValidateSet("DEBUG", "INFO", "WARN", "ERROR", "CRIT", "NONE")]
        [string]$DisplayLevel
    )
    $global:llevel = $LogLevel
    if ($DisplayLevel) {
        $global:dlevel = $DisplayLevel
    }
    else {
        $global:dlevel = $LogLevel
    }
}