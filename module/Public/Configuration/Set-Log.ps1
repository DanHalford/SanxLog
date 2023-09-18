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