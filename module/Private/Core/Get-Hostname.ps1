function Get-Hostname() {
    return [System.Net.Dns]::GetHostName().ToString()
}