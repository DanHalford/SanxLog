function Get-InfluxTimestamp() {
    $epochStart = [System.DateTime]::new(1970, 1, 1, 0, 0, 0, 0, [System.DateTimeKind]::Utc)
    $milliseconds = [System.Math]::Truncate(([System.DateTime]::UtcNow - $epochStart).TotalMilliseconds)
    Return $milliseconds
}