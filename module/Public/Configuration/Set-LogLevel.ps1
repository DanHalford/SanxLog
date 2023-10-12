<#
.SYNOPSIS
    Sets the display and log levels for the module.

.DESCRIPTION
    Sets the display and log levels for the module. The log level determines which messages are written to the log. The display level determines which messages are written to the screen.

.PARAMETER LogLevel
    The log level to set. Valid values are DEBUG, INFO, WARN, ERROR, CRIT.

.PARAMETER DisplayLevel
    The display level to set. Valid values are DEBUG, INFO, WARN, ERROR, CRIT, NONE.

.EXAMPLE
    Set-LogLevel -LogLevel "DEBUG" -DisplayLevel "INFO"
#>

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