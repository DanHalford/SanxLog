function Write-Warn() {
    Param(
        [Parameter(Mandatory=$true)]
        [string]$Message
    )
    switch ($global:logtype) {
        "File" {
            Write-FileLog -Level "WARN" -Message $Message
        }
        "InfluxDB" {
            Write-InfluxLog -Level "WARN" -Message $Message
        }
        "Datadog" {
            Write-DatadogLog -Level "WARN" -Message $Message
        }
    }
    Write-ScreenLog -Level "WARN" -Message $Message
}