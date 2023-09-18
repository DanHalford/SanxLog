$global:llevel = "ERROR"
$global:dlevel = "ERROR"
$global:logpath = ".\sanxlog.log"
$global:logmaxsize = 10000000
$global:useutc = $false
[LogType]$global:logtype = [LogType]::File
$global:inluxurl = ""
$global:influxtoken = ""
$global:influxbucket = ""
$global:influxorg = ""
$global:influxsource = "SanxLog"
$global:datadogsite = "datadoghq.com"
$global:datadogapikey = ""
$global:datadogservice = ""
$global:datadogsource = "SanxLog"
$global:datadogtags = @()

$Public  = @(Get-ChildItem -Path "$PSScriptRoot\Public\" -include '*.ps1' -recurse -ErrorAction SilentlyContinue)
$Private = @(Get-ChildItem -Path "$PSScriptRoot\Private\" -include '*.ps1' -recurse -ErrorAction SilentlyContinue)

foreach ($ps1 in @($Public + $Private)) {
    try {
        . $ps1.fullname
    } catch {
        Write-Error -Message "Failed to import function $($ps1.fullname): $_"
    }
}

Export-ModuleMember -Function $Public.Basename