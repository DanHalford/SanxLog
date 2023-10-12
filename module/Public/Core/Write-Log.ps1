<#
.SYNOPSIS
Writes a message to the specified log

.DESCRIPTION
Writes a message to the specified log. Ensure that Set-LogType has been called before calling this function.

.PARAMETER Message
The message to write to the log

.PARAMETER DebugMessage
Specifies that the message is a debug message

.PARAMETER Info
Specifies that the message is an informational message

.PARAMETER Warn
Specifies that the message is a warning message

.PARAMETER Error
Specifies that the message is an error message

.PARAMETER Critical
Specifies that the message is a critical error message

.EXAMPLE
Write-Log -Message "This is an informational message"
Write-Log -Message "This is a warning message" -Warn

.NOTES
If no message type is specified, the message will be written as an informational message.
#>
function Write-Log() {
    [CmdletBinding(DefaultParameterSetName="Info")]
    Param(
        [Parameter(Mandatory=$true, Position=0, ValueFromPipeline=$true,HelpMessage="The message to write to the log")]
        [string]$Message,
        [Parameter(ParameterSetName="Debug", Mandatory=$false, HelpMessage="Specifies that the message is a debug message")]
        [switch]$DebugMessage,
        [Parameter(ParameterSetName="Info", Mandatory=$false, HelpMessage="Specifies that the message is an informational message")]
        [switch]$Info,
        [Parameter(ParameterSetName="Warn", Mandatory=$false, HelpMessage="Specifies that the message is a warning message")]
        [switch]$Warn,
        [Parameter(ParameterSetName="Error", Mandatory=$false, HelpMessage="Specifies that the message is an error message")]
        [switch]$Error,
        [Parameter(ParameterSetName="Critical", Mandatory=$false, HelpMessage="Specifies that the message is a critical error message")]
        [switch]$Critical
    )
    Begin {
        if ($LogConfig.ValidConfig -eq $false) {
            Write-LogError -Message "Log configuration has not been set. Please call Set-Log before calling this function."
            return
        }
        if ($DebugMessage) {
            Write-LogDebug -Message $Message
        } elseif ($Info) {
            Write-LogInfo -Message $Message
        } elseif ($Warn) {
            Write-LogWarn -Message $Message
        } elseif ($Error) {
            Write-LogError -Message $Message
        } elseif ($Critical) {
            Write-LogCritical -Message $Message
        } else {
            Write-LogInfo -Message $Message
        }
    }
}