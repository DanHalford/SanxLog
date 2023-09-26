<#
.SYNOPSIS
Specifies the type of logging to use, and the parameters for that logging type.

.DESCRIPTION
This function is used to specify the type of logging to use, and the parameters for that logging type. It must be called before any logging functions are used.

.PARAMETER LogType
The type of logging to use. Must be one of 'File', 'InfluxDB', 'Datadog', 'SumoLogic' or 'Loggly'.

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
Applicable only when LogType is 'InfluxDB', 'SumoLogic' or 'Datadog'.
If LogType is Influx, specify the full URL to the InfluxDB server, including port number.
For DataDog, specify the Datadog site URL. Do not include the https:// prefix.
For Sumo Logic, specify the full HTTP collector URL.

.PARAMETER Token
Applicable only when LogType is 'InfluxDB' or 'Loggly'.
For InfluxDB, the API token for InfluxDB authentication. The token will require, at a minimum, write access to the specified bucket.
For Loggly, use the customer token for Loggly authentication. Do not use an API token.

.PARAMETER Bucket
Applicable only when LogType is 'InfluxDB'.
The name or ID of the bucket to write logs to. The bucket must already exist.

.PARAMETER OrgName
Applicable only when LogType is 'InfluxDB'.
The name or ID of the InfluxDB organisation. The organisation must already exist.

.PARAMETER Source
Applicable only when LogType is 'InfluxDB', 'Datadog', 'SumoLogic' or 'Loggly'
The name of the source for the logs. This will be used as a tag in Loggly, SumoLogic, Datadog and InfluxDB. Defaults to 'SanxLog'.

.PARAMETER APIKey
Applicable only when LogType is 'Datadog'.
The API key for Datadog authentication.

.PARAMETER Service
Applicable only when LogType is 'SumoLogic', 'Datadog' or 'Loggly'.
The service name to tag log entries with.

.PARAMETER Tags
Applicable only when LogType is 'Datadog' or 'Loggly'.
An array of metadata tags to add to log entries.

.PARAMETER Metadata
Applicable only when LogType is 'SumoLogic'
An dictionary of key/value pairs to add to log entries.

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
        [ValidateSet("File", "InfluxDB", "Datadog", "Loggly", "SumoLogic", IgnoreCase=$true, ErrorMessage="Invalid log type - must be one of 'File', 'InfluxDB', or 'Datadog'")]
        [string]$LogType,

        [Parameter(ParameterSetName="File", Mandatory=$true)]
        [string]$Path,

        [Parameter(ParameterSetName="File", HelpMessage="Log file size in bytes")]
        [int]$MaxSize,

        [Parameter(ParameterSetName="File", HelpMessage="Write log timestamps in UTC")]
        [switch]$UniversalTime,

        [Parameter(ParameterSetName="InfluxDB", Mandatory=$true, HelpMessage="The full URL to the InfluxDB server, including port number.")]
        [Parameter(ParameterSetName="Datadog", Mandatory=$true, HelpMessage="The Datadog site URL")]
        [Parameter(ParameterSetName="SumoLogic", Mandatory=$true, HelpMessage="The SumoLogic HTTP collector URL")]
        [string]$ServerURL,

        [Parameter(ParameterSetName="InfluxDB", Mandatory=$true, HelpMessage="API token for InfluxDB authentication. The token will require, at a minimum, write access to the specified bucket.")]
        [Parameter(ParameterSetName="Loggly", Mandatory=$true, HelpMessage="Customer token for Loggly authentication. Do no use an API token.")]
        [string]$Token,

        [Parameter(ParameterSetName="InfluxDB", Mandatory=$true, HelpMessage="The name or ID of the bucket to write logs to. The bucket must already exist.")]
        [string]$Bucket,

        [Parameter(ParameterSetName="InfluxDB", Mandatory=$true, HelpMessage="The name or ID of the InfluxDB organisation. The organisation must already exist.")]
        [string]$OrgName,

        [Parameter(ParameterSetName="InfluxDB", HelpMessage="The name of the source for the logs. This will be used as a tag in InfluxDB. Defaults to 'SanxLog'")]
        [Parameter(ParameterSetName="Datadog", HelpMessage="The source name to tag log entries with. Defaults to 'SanxLog'")]
        [Parameter(ParameterSetName="Loggly", HelpMessage="The source name to tag log entries with. Defaults to 'SanxLog'")]
        [Parameter(ParameterSetName="SumoLogic", HelpMessage="The source name to tag log entries with. Defaults to 'SanxLog'")]
        [string]$Source,

        [Parameter(ParameterSetName="Datadog", Mandatory=$true, HelpMessage="API key for Datadog authentication.")]
        [string]$APIKey,

        [Parameter(ParameterSetName="Datadog", Mandatory=$true, HelpMessage="The service name to tag log entries with.")]
        [Parameter(ParameterSetName="Loggly", Mandatory=$true, HelpMessage="The service name to tag log entries with.")]
        [Parameter(ParameterSetName="SumoLogic", Mandatory=$true, HelpMessage="The service name to tag log entries with. This is used to override the Source Category configured on the Sumo Logic HTTP collector.")]
        [string]$Service,

        [Parameter(ParameterSetName="Datadog", HelpMessage="Metadata tags to add to log entries.")]
        [Parameter(ParameterSetName="Loggly", HelpMessage="Metadata tags to add to log entries.")]
        [string[]]$Tags,

        [Parameter(ParameterSetName="SumoLogic", HelpMessage="Metadata fields to tag log entries with.")]
        [hashtable]$Metadata,

        [Parameter(Mandatory=$true, HelpMessage="The minimum log level to write to the log. Must be one of 'DEBUG', 'INFO', 'WARN', 'ERROR', or 'CRIT'")]
        [ValidateSet("DEBUG", "INFO", "WARN", "ERROR", "CRIT")]
        [string]$LogLevel,

        [Parameter(HelpMessage="The minimum log level to display on the console. Must be one of 'DEBUG', 'INFO', 'WARN', 'ERROR', 'CRIT', or 'NONE'")]
        [ValidateSet("DEBUG", "INFO", "WARN", "ERROR", "CRIT", "NONE")]
        [string]$DisplayLevel
    )

    if ($DisplayLevel) {
        Set-LogLevel -LogLevel $LogLevel -DisplayLevel $DisplayLevel
    }
    else {
        Set-LogLevel -LogLevel $LogLevel
    }

    switch ($LogType.ToLower()) {
        "file" {
            if ($Path) {
                $FileLogConfig.Path = $Path
            }
            if ($MaxSize) {
                $FileLogConfig.MaxSize = $MaxSize
            }
            $LogConfig.LogType = "File"
            Open-FileLog -Path $FileLogConfig.Path
        }
        "influxdb" {
            $LogConfig.LogType = "InfluxDB"
            if ($ServerURL) {
                $InfluxLogConfig.URL = $ServerURL
            }
            if ($Token) {
                $InfluxLogConfig.Token = $Token
            }
            if ($Bucket) {
                $InfluxLogConfig.Bucket = $Bucket
            }
            if ($OrgName) {
                $InfluxLogConfig.Org = $OrgName
            }
            if ($Source) {
                $InfluxLogConfig.Source = $Source
            }
        }
        "datadog" {
            $LogConfig.LogType = "Datadog"
            if ($ServerURL) {
                $DatadogLogConfig.URL = $ServerURL
            }
            if ($APIKey) {
                $DatadogLogConfig.APIKey = $APIKey
            }
            if ($Service) {
                $DatadogLogConfig.Service = $Service
            }
            if ($Source) {
                $DatadogLogConfig.Source = $Source
            }
            if ($Tags) {
                $DatadogLogConfig.Tags = $Tags
            }
        }
        "loggly" {
            $LogConfig.LogType = "Loggly"
            if ($Token) {
                $LogglyLogConfig.Token = $Token
            }
            if ($Service) {
                $LogglyLogConfig.Service = $Service
            }
            if ($Source) {
                $LogglyLogConfig.Source = $Source
            }
            if ($Tags) {
                $LogglyLogConfig.Tags = $Tags
            }
        }
        "sumologic" {
            $LogConfig.LogType = "SumoLogic"
            if ($ServerURL) {
                $SumoLogConfig.CollectorURL = $ServerURL
            }
            if ($Service) {
                $SumoLogConfig.Category = $Service
            }
            if ($Source) {
                $SumoLogConfig.Source = $Source
            }
            if ($Metadata) {
                $SumoLogConfig.Metadata = $Metadata
            }
        }
    }

    if ($UniversalTime) {
        $LogConfig.UseUTC = $true
    }
    else {
        $LogConfig.UseUTC = $false
    }

}