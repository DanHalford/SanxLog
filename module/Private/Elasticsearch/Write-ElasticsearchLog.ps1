function Write-ElasticsearchLog() {
    Param(
        [Parameter(Mandatory=$true)]
        [ValidateSet("DEBUG", "INFO", "WARN", "ERROR", "CRIT")]
        [string]$Level,

        [Parameter(Mandatory=$true)]
        [string]$Message
    )
    $url = "$($ElasticsearchConfig.URL)/$($ElasticsearchConfig.Index)/_doc"
    $headers = @{
        "Authorization" = "ApiKey $($ElasticsearchConfig.APIKey)"
        "Content-Type" = "application/json"
    }
    $tags = $ElasticsearchConfig.Tags
    $tags += "level:$($Level.ToUpper()))"
    $hostname = Get-Hostname
    $processID = $PID.ToString()
    $body = @{
        timestamp = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ss.fffzzz")
        message = "[$($Level.ToLower())] [$processID] $($Message -replace('"', '\"'))"
        source = $ElasticsearchConfig.Source
        service = $ElasticsearchConfig.Service
        tags = $tags
        processid = $PID.ToString()
        hostname = $hostname
    }

    $scriptblock = {
        param(
            [string]$url,
            [hashtable]$headers,
            [hashtable]$body,
            [bool]$SkipCertificateCheck = $false
        )
        Try {
            if ($SkipCertificateCheck) {
                Invoke-RestMethod -Method POST -Uri $url -Headers $headers -Body ($body | ConvertTo-Json) -SkipCertificateCheck| Out-Null
            } else {
                Invoke-RestMethod -Method POST -Uri $url -Headers $headers -Body ($body | ConvertTo-Json) | Out-Null
            }
        }
        Catch {
            Write-Error "Failed to write to Elasticsearch: $($_.Exception.Message)"
            Write-Information "URL: $url"
            Write-Information "Headers: $headers"
            Write-Information "Body: $($body | ConvertTo-Json)"
        }
    }
    $jobid = [guid]::NewGuid().ToString()
    Start-Job -ScriptBlock $scriptblock -Name $jobid -ArgumentList @( $url, $headers, $body, $ElasticsearchConfig.SkipCertificateCheck) | Out-Null
}