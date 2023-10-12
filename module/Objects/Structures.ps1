$LogConfig = @{
    LogType = "File"
    LLevel = "ERROR"
    DLevel = "ERROR"
    UseUTC = $false
}
New-Variable -Name LogConfig -Value $LogConfig -Scope Script -Force

$FileLogConfig = @{
    Path = ".\sanxlog.log"
    MaxSize = 10000000
}
New-Variable -Name FileLogConfig -Value $FileLogConfig -Scope Script -Force

$InfluxLogConfig = @{
    URL = ""
    Token = ""
    Bucket = ""
    Org = ""
    Source = "SanxLog"
}
New-Variable -Name InfluxLogConfig -Value $InfluxLogConfig -Scope Script -Force

$DatadogLogConfig = @{
    Site = "datadoghq.com"
    APIKey = ""
    Service = ""
    Source = ""
    Tags = @()
}
New-Variable -Name DatadogLogConfig -Value $DatadogLogConfig -Scope Script -Force

$LogglyLogConfig = @{
    Token = ""
    Tags = @()
    Source = ""
    Service = ""
}
New-Variable -Name LogglyLogConfig -Value $LogglyLogConfig -Scope Script -Force

$SumoLogConfig = @{
    CollectorURL = ""
    Source = ""
    Category = ""
    Metadata = @{}
}
New-Variable -Name SumoLogConfig -Value $SumoLogConfig -Scope Script -Force