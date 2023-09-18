# SanxLog - PowerShell Logging Module
SanxLog is a PowerShell Core module that enables simple logging to file and to a growing number of time-series databases and log aggregation services; currently InfluxDB and Datadog.

Once the module has been imported, use the `Set-Log` cmdlet to specify the logging target. At present, you can only log to one location at a time. Each log target also supports, if required, logging to the Console. Once the log type has been specified, to write log entries, simply call:
`Write-Crit`
`Write-Error`
`Write-Warn`
`Write-Info`
`Write-Debug`

## File logging
Features include:
* Log to any locally accessible path; local disk or UNC paths supported.
* Configurable maximum log size, with automatic rollover
* Timestamps can be local time or UTC

### Log file format
The log files are written in a human-readable (or at least, human parseable) format:
\[Timestamp\] \[ProcessID\] \[Log level - CRIT|ERROR|WARN|INFO|DEBUG\] Message

## InfluxDB logging
Features include:
* Supports InfluxDB on-premises and InfluxDB Cloud - InfluxDB v2.x currently supported and v3.x coming soon
* Organisation name and bucket fully customiable with names and IDs supported
* Entries tagged with a **Source**, **LogLevel**, **Hostname** and **ProcessID** tags for easy filtering

## Datadog logging
Features include:
* **Service** fully configurable
* **Source** and **LogLevel** included as log entry tags. Additional tags can be specified.

Log messages are written in the following format:
\[Log level - CRIT|ERROR|WARN|INFO|DEBUG\] \[ProcessID\] Message


