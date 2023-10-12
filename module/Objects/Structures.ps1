$LogConfig = @{
    LogType = "File"
    LLevel = "ERROR"
    DLevel = "ERROR"
    UseUTC = $false
    ValidConfig = $false
}
New-Variable -Name LogConfig -Value $LogConfig -Scope Script -Force

$ForegroundColor = [System.Console]::ForegroundColor
$BackgroundColor = [System.Console]::BackgroundColor
if ([System.Console]::ForegroundColor -eq -1) {
    $ForegroundColor = [System.ConsoleColor]::White
}
if ([System.Console]::BackgroundColor -eq -1) {
    $BackgroundColor = [System.ConsoleColor]::Black
}
$ScreenLogConfig = @{
    [System.ConsoleColor]$DebugForegroundColor = [System.ConsoleColor]::Gray
    [System.ConsoleColor]$InfoForegroundColor = $ForegroundColor
    [System.ConsoleColor]$WarnForegroundColor = [System.ConsoleColor]::Yellow
    [System.ConsoleColor]$ErrorForegroundColor = [System.ConsoleColor]::Red
    [System.ConsoleColor]$CritForegroundColor = [System.ConsoleColor]::Red
    [System.ConsoleColor]$DebugBackgroundColor = $BackgroundColor
    [System.ConsoleColor]$InfoBackgroundColor = $BackgroundColor
    [System.ConsoleColor]$WarnBackgroundColor = $BackgroundColor
    [System.ConsoleColor]$ErrorBackgroundColor = $BackgroundColor
    [System.ConsoleColor]$CritBackgroundColor = $ForegroundColor
}
New-Variable -Name ScreenLogConfig -Value $ScreenLogConfig -Scope Script -Force

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