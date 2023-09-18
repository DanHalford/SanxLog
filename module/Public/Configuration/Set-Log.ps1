<#
.SYNOPSIS
Specifies the type of logging to use, and the parameters for that logging type.
#

.DESCRIPTION
This function is used to specify the type of logging to use, and the parameters for that logging type. It must be called before any logging functions are used.

.PARAMETER LogType
The type of logging to use. Must be one of 'File', 'InfluxDB', or 'Datadog'.

.PARAMETER Path
Applicable only when LogType is 'File'.
The path to the log file. If the file does not exist, it will be created. If the file does exist, it will be appended to. If the file is larger than the MaxSize parameter, it will be renamed with a timestamp and a new file will be created. If the MaxSize parameter is not specified, the default is 10MB.

.PARAMETER MaxSize
Applicable only when LogType is 'File'.
The maximum size of the log file in bytes. If the file is larger than this, it will be renamed with a timestamp and a new file will be created. If this parameter is not specified, the default is 10MB.

.PARAMETER UniversalTime
Applicable only when LogType is 'File'.
If this switch is specified, timestamps in the log file will be written in UTC. If this switch is not specified, timestamps will be written in the local time zone.

.PARAMETER ServerURL
Applicable only when LogType is 'InfluxDB' or 'Datadog'.
If LogType is Influx, specify the full URL to the InfluxDB server, including port number.
For DataDog, specify the Datadog site URL.

.PARAMETER Token
Applicable only when LogType is 'InfluxDB'.
The API token for InfluxDB authentication. The token will require, at a minimum, write access to the specified bucket.

.PARAMETER Bucket
Applicable only when LogType is 'InfluxDB'.
The name or ID of the bucket to write logs to. The bucket must already exist.

.PARAMETER OrgName
Applicable only when LogType is 'InfluxDB'.
The name or ID of the InfluxDB organisation. The organisation must already exist.

.PARAMETER Source
Applicable only when LogType is 'InfluxDB' or 'Datadog'.
The name of the source for the logs. This will be used as a tag in Datadog and InfluxDB. Defaults to 'SanxLog'.

.PARAMETER APIKey
Applicable only when LogType is 'Datadog'.
The API key for Datadog authentication.

.PARAMETER Service
Applicable only when LogType is 'Datadog'.
The service name to tag log entries with.

.PARAMETER Tags
Applicable only when LogType is 'Datadog'.
Metadata tags to add to log entries.

.PARAMETER LogLevel
The minimum log level to write to the log. Must be one of 'DEBUG', 'INFO', 'WARN', 'ERROR', or 'CRIT'.

.PARAMETER DisplayLevel
The minimum log level to display on the console. Must be one of 'DEBUG', 'INFO', 'WARN', 'ERROR', 'CRIT', or 'NONE'. If this parameter is not specified, the value of LogLevel will be used.

.EXAMPLE
Set-Log -LogType File -Path "C:\Logs\SanxLog.log" -MaxSize 10000000 -LogLevel INFO -DisplayLevel WARN
#>
function Set-Log() {
    param (
        [Parameter(Mandatory=$true, Position=0)]
        [ValidateSet("File", "InfluxDB", "Datadog", IgnoreCase=$true, ErrorMessage="Invalid log type - must be one of 'File', 'InfluxDB', or 'Datadog'")]
        [string]$LogType,

        [Parameter(ParameterSetName="File", Mandatory=$true)]
        [string]$Path,

        [Parameter(ParameterSetName="File", HelpMessage="Log file size in bytes")]
        [int]$MaxSize,

        [Parameter(ParameterSetName="File", HelpMessage="Write log timestamps in UTC")]
        [switch]$UniversalTime,

        [Parameter(ParameterSetName="InfluxDB", Mandatory=$true, HelpMessage="The full URL to the InfluxDB server, including port number.")]
        [Parameter(ParameterSetName="Datadog", Mandatory=$true, HelpMessage="The Datadog site URL")]
        [string]$ServerURL,

        [Parameter(ParameterSetName="InfluxDB", Mandatory=$true, HelpMessage="API token for InfluxDB authentication. The token will require, at a minimum, write access to the specified bucket.")]
        [string]$Token,

        [Parameter(ParameterSetName="InfluxDB", Mandatory=$true, HelpMessage="The name or ID of the bucket to write logs to. The bucket must already exist.")]
        [string]$Bucket,

        [Parameter(ParameterSetName="InfluxDB", Mandatory=$true, HelpMessage="The name or ID of the InfluxDB organisation. The organisation must already exist.")]
        [string]$OrgName,

        [Parameter(ParameterSetName="InfluxDB", HelpMessage="The name of the source for the logs. This will be used as a tag in InfluxDB. Defaults to 'SanxLog'")]
        [Parameter(ParameterSetName="Datadog", HelpMessage="The source name to tag log entries with. Defaults to 'SanxLog'")]
        [string]$Source,

        [Parameter(ParameterSetName="Datadog", Mandatory=$true, HelpMessage="API key for Datadog authentication.")]
        [string]$APIKey,

        [Parameter(ParameterSetName="Datadog", Mandatory=$true, HelpMessage="The service name to tag log entries with.")]
        [string]$Service,

        [Parameter(ParameterSetName="Datadog", HelpMessage="Metadata tags to add to log entries.")]
        [string[]]$Tags,

        [Parameter(Mandatory=$true)]
        [ValidateSet("DEBUG", "INFO", "WARN", "ERROR", "CRIT")]
        [string]$LogLevel,
        
        [ValidateSet("DEBUG", "INFO", "WARN", "ERROR", "CRIT", "NONE")]
        [string]$DisplayLevel
    )

    if ($DisplayLevel) {
        Set-LogLevel -LogLevel $LogLevel -DisplayLevel $DisplayLevel
    }
    else {
        Set-LogLevel -LogLevel $LogLevel
    }
    
    switch ($LogType) {
        "File" {
            if ($Path) {
                $global:logpath = $Path
            }
            if ($MaxSize) {
                $global:logmaxsize = $MaxSize
            }
            New-LogFile -Path $global:logpath
        }
        "InfluxDB" {
            $global:logtype = "InfluxDB"
            if ($ServerURL) {
                $global:influxurl = $ServerURL
            }
            if ($Token) {
                $global:influxtoken = $Token
            }
            if ($Bucket) {
                $global:influxbucket = $Bucket
            }
            if ($OrgName) {
                $global:influxorg = $OrgName
            }
            if ($Source) {
                $global:influxsource = $Source
            }
        }
        "Datadog" {
            $global:logtype = "Datadog"
            if ($ServerURL) {
                $global:datadogsite = $ServerURL
            }
            if ($APIKey) {
                $global:datadogapikey = $APIKey
            }
            if ($Service) {
                $global:datadogservice = $Service
            }
            if ($Source) {
                $global:datadogsource = $Source
            }
            if ($Tags) {
                $global:datadogtags = $Tags
            }
        }
    }

    if ($UniversalTime) {
        $global:useutc = $true
    }
    else {
        $global:useutc = $false
    }

}