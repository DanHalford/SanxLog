<#
.SYNOPSIS
This cmdlet displays the current logging configuration.

.DESCRIPTION
Show-LogConfig displays the details of the current logging configuration.
If the logging configuration is invalid, it prompts the user to configure the logging by calling Set-Log cmdlet.

.EXAMPLE
Show-LogConfig

This command displays the current logging configuration.

.NOTES
The cmdlet displays different information based on the LogType property of the LogConfig object. It supports multiple log types including File, InfluxDB, Datadog, Loggly, and SumoLogic.
It also displays screen logging configuration if the DLevel property of the LogConfig object is not set to "NONE".

.LINK
Set-Log
#>
function Show-LogConfig() {
    if ($LogConfig.ValidConfig -eq $false) {
        Write-Output "Log configuration has not been set. Please call Set-Log to configure logging destination and parameters."
    } else {
        $LogConfig | Format-List
        switch ($LogConfig.LogType) {
            "File" {
                $FileLogConfig | Format-Table
            }
            "InfluxDB" {
                $InfluxLogConfig | Format-Table
            }
            "Datadog" {
                $DatadogLogConfig | Format-Table
            }
            "Loggly" {
                $LogglyLogConfig | Format-Table
            }
            "SumoLogic" {
                $SumoLogicLogConfig | Format-Table
            }
        }
        if ($LogConfig.DLevel -ne "NONE") {
            Write-Host "Screen logging configuration:" -ForegroundColor Green
            $ScreenLogConfig | Format-Table
        }
    }
}