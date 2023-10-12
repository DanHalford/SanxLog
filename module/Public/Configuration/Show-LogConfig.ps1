<#
.SYNOPSIS
    Displays the current log configuration.

.DESCRIPTION
    Displays the current log configuration.

.EXAMPLE
    Show-LogConfig
#>

function Show-LogConfig() {
    if ($LogConfig.ValidConfig -eq $false) {
        Write-Output "Log configuration has not been set. Please call Set-Log to configure logging destination and parameters."
    } else {
        $LogConfig | Format-List
        switch ($LogConfig.LogType) {
            "File" {
                $FileLogConfig | Format-List
            }
            "InfluxDB" {
                $InfluxLogConfig | Format-List
            }
            "Datadog" {
                $DatadogLogConfig | Format-List
            }
            "Loggly" {
                $LogglyLogConfig | Format-List
            }
            "SumoLogic" {
                $SumoLogicLogConfig | Format-List
            }
        }
        if ($LogConfig.DLevel -ne "NONE") {
            $ScreenLogConfig | Format-List
        }
    }
    
}