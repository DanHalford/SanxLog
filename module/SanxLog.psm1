$Public  = @(Get-ChildItem -Path "$PSScriptRoot\Public\" -include '*.ps1' -recurse -ErrorAction SilentlyContinue)
$Private = @(Get-ChildItem -Path "$PSScriptRoot\Private\" -include '*.ps1' -recurse -ErrorAction SilentlyContinue)
$Objects = @(Get-ChildItem -Path "$PSScriptRoot\Objects" -include '*.ps1' -recurse -ErrorAction SilentlyContinue)

foreach ($ps1 in $Objects) {
    try {
        . $ps1.fullname -Verbose
    } catch {
        Write-Host "Failed to import function $($ps1.fullname): $_" -ForegroundColor Red
    }
}

foreach ($ps1 in @($Public + $Private)) {
    try {
        . $ps1.fullname -Verbose
    } catch {
        Write-Host "Failed to import function $($ps1.fullname): $_" -ForegroundColor Red
    }
}

foreach ($ps1 in $Public) {
    try {
        Export-ModuleMember -Function ($ps1 | Foreach-Object {$_.BaseName}) -Verbose
    } catch {
        Write-Host "Failed to export function $($ps1.fullname): $_" -ForegroundColor Red
    }
}