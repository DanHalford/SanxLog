<#
.SYNOPSIS
    Sets the display and log levels for the module.

.DESCRIPTION
    Sets the display and log levels for the module. The log level determines which messages are written to the log. The display level determines which messages are written to the screen.
    Log level and display level can be set to different values. For example, you can set the log level to DEBUG and the display level to INFO. This will write all DEBUG, INFO, WARN, ERROR and CRIT messages to the log, but only INFO, WARN, ERROR and CRIT messages to the screen.
    While display and log level can also be set using the Set-Log cmdlet, Set-LogLevel is provided as a shortcut to change the log level without specifying a new logging target.

.PARAMETER LogLevel
    The log level to set. Valid values are DEBUG, INFO, WARN, ERROR, CRIT.

.PARAMETER DisplayLevel
    The display level to set. Valid values are DEBUG, INFO, WARN, ERROR, CRIT, NONE.

.EXAMPLE
    Set-LogLevel -LogLevel "DEBUG" -DisplayLevel "INFO"

.LINK
    Set-Log
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