function Get-LogLine() {
    Param(
        [Parameter(Mandatory=$true)]
        [ValidateSet("DEBUG", "INFO", "WARN", "ERROR", "CRIT")]
        [string]$Level,

        [Parameter(Mandatory=$true)]
        [string]$Message
    )
    $levelcode = $Level.ToUpper().PadRight(5)
    $timestamp = $global:useutc ? (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ss.fffzzz") : (Get-Date).ToString("yyyy-MM-ddTHH:mm:ss.fffzzz")
    $processID = $PID.ToString().PadLeft(5)
    $logline = "[$timestamp] [$processID] [$levelcode] $Message"
    return $logline
}