function Open-FileLog() {
    param(
        [Parameter(Mandatory=$true)]
        [string]$path
    )
    try {
        if (Test-Path -Path $path) {
            $file = Get-Item -Path $path -ErrorAction Stop | Out-Null
        } else {
            $file = New-Item -Path $path -ItemType File -ErrorAction Stop | Out-Null
        }
        return $file
    }
    catch {
        Write-Error -Message "Cannot create log file: $path"
        Write-Error $_.Exception.Message
    }
}