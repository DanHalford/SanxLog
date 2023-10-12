<#
.SYNOPSIS
    Returns the hostname of the current machine.
#>

function Get-Hostname() {
    return [System.Net.Dns]::GetHostName().ToString()
}