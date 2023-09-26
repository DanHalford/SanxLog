function Test-FileLogSize() {
    $file = Get-Item -Path $FileLogConfig.Path -ErrorAction SilentlyContinue
    if ($file.Length -gt $FileLogConfig.MaxSize) {
        $timestamp = $LogConfig.UseUTC ? (Get-Date).ToUniversalTime().ToString("yyyyMMddTHHmmss") : (Get-Date).ToString("yyyyMMddTHHmmss")
        $file | Rename-Item -NewName "$($file.Name).$timestamp.log"
        Open-FileLog -Path $FileLogConfig.Path
    }
}