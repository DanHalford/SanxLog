function Test-FileLogSize() {
    $file = Get-Item -Path $global:logpath
    if ($file.Length -gt $global:logmaxsize) {
        $timestamp = $global:useutc ? (Get-Date).ToUniversalTime().ToString("yyyyMMddTHHmmss") : (Get-Date).ToString("yyyyMMddTHHmmss")
        $file | Rename-Item -NewName "$($file.Name).$timestamp.log"
        New-FileLog -Path $global:logpath
    }
}