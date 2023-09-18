function New-FileLog() {
    param(
        [Parameter(Mandatory=$true)]
        [string]$path
    )
    try {
        $file = New-Item -Path $path -ItemType File -ErrorAction Stop
        return $file
    }
    catch {
        Write-Error -Message "Cannot create log file: $path"
        Write-Error $_.Exception.Message
    }
}