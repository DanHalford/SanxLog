![PowerShell 7.2+](https://img.shields.io/badge/PowerShell-7.2+-blue)
![Cross-platform](https://img.shields.io/badge/Cross--platform-Yes-green)
![Logging Targets](https://img.shields.io/badge/Targets-File%20%7C%20Console%20%7C%20Cloud-blueviolet)
![License](https://img.shields.io/github/license/DanHalford/SanxLog)

# SanxLog - Structured logs for grown-up scripts
SanxLog is a PowerShell Core module that enables simple logging to file and to a growing number of time-series databases and log aggregation services; currently InfluxDB, Datadog, Sumo Logic, Loggly and Elasticsearch. For each option, simultaneous logging to console is also supported.

Once the module has been imported, use the `Set-Log` cmdlet to specify the logging target. At present, you can only log to one location at a time. Each log target also supports, if required, logging to the Console. Once the log type has been specified, to write log entries, simply call:
`Write-LogCritical`
`Write-LogError`
`Write-LogWarn`
`Write-LogInfo`
`Write-LogDebug`

### Logging settings
All logging parameters are set using the `Set-Log` cmdlet. Specific options to note include:
* `-LogType` - Mandatory option. Must be one of **File**, **InfluxDB**, **Datadog**, **SumoLogic** or **Loggly**
* `-LogLevel` - Mandatory option. Specifies the minimum log level to write to the specified log target. Log entries with a lower level are ignored. Must be one of **CRIT**, **ERROR**, **WARN**, **INFO** and **DEBUG**.
* `-DisplayLevel` - Specifies the minimum log level to write to the console. Log entries with a lower level are ignored. Must be one of **CRIT**, **ERROR**, **WARN**, **INFO** and **DEBUG**, or **NONE** to disable console logging entirely. If not specifed, defaults to the `-LogLevel` value.

## File logging
Features include:
* Log to any locally accessible path; local disk or UNC paths supported.
* Configurable maximum log size, with automatic rollover
* Timestamps can be local time or UTC

### Log file format
The log files are written in a human-readable (or at least, human parseable) format:

`[Timestamp] [ProcessID] [Log level - CRIT|ERROR|WARN|INFO|DEBUG] Message`

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

`[Log level - CRIT|ERROR|WARN|INFO|DEBUG] [ProcessID] Message`

## Loggly logging
Features include:
* Log messages written as JSON to take advantage of Loggly's excellent filtering and searching functions
* Each message tagged with **Hostname**, **LogLevel**, **ProcessID** and a configurable **Source** and **Service**
* Tags are also supported.

## Sumo Logic logging
To ingest logs into Sumo Logic, you first need to create an collector and then create a *HTTP Logs & Metrics* source. During the source creation process, be sure to select the One Message Per Request option, otherwise the JSON log entries are processed as individual lines. Once it's created, use the source URL as the **ServerURL** parameter.
Features include:
* Log messages written as JSON to take advantage of Loggly's excellent filtering and searching functions
* Each message tagged with **Hostname**, **LogLevel**, **ProcessID** and a configurable **Source** and **Service**
* Additional metadata tags can be specified as key/value pairs

## Elasticsearch logging
To ingest logs into Elastic search, you first need to have created an index to receive them.
Features include:
* Log messages written as JSON to take advantage of filtering and searching functions
* Each message tagged with **Hostname**, **LogLevel**, **ProcessID** and a configurable **Source** and **Service**
* Tags are also supported.
Use the **Set-Log -SkipCertificateCheck** option to turn off SSL certificate checking if testing against a development instance.
