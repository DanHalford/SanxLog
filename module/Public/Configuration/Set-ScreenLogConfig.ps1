<#
.SYNOPSIS
Sets the configuration for the screen logger.

.DESCRIPTION
Sets the background and foreground colors for the screen logger. If no parameters are specified, the default colors are used.

.PARAMETER DebugForegroundColor
The foreground color for debug messages. Defaults to Gray.

.PARAMETER InfoForegroundColor
The foreground color for informational messages. Defaults to the current console foreground color.

.PARAMETER WarnForegroundColor
The foreground color for warning messages. Defaults to Yellow.

.PARAMETER ErrorForegroundColor
The foreground color for error messages. Defaults to Red.

.PARAMETER CritForegroundColor
The foreground color for critical messages. Defaults to Red.

.PARAMETER DebugBackgroundColor
The background color for debug messages. Defaults to the current console background color.

.PARAMETER InfoBackgroundColor
The background color for informational messages. Defaults to the current console background color.

.PARAMETER WarnBackgroundColor
The background color for warning messages. Defaults to the current console background color.

.PARAMETER ErrorBackgroundColor
The background color for error messages. Defaults to the current console background color.

.PARAMETER CritBackgroundColor
The background color for critical messages. Defaults to the current console foreground color.

.PARAMETER ForegroundColor
Sets the foreground color for all messages. If individual colors are specified, those parameters take precedence.

.PARAMETER BackgroundColor
Sets the background color for all messages. If individual colors are specified, those parameters take precedence.

.PARAMETER UseDefault
Sets the colors to the default colors. If this switch is specified, all other parameters are ignored.
The default colors are:
- Debug: Gray on the default console background color
- Info: The default console foreground and background colors
- Warn: Yellow on the default console background color
- Error: Red on the default console background color
- Crit: Red on the default console foreground color

.EXAMPLE
Set-ScreenLogConfig -BackgroundColor White -CritBackgroundColor Red -CritForegroundColor White
Sets the critical background color to red, and the critical foreground color to white. The background for all other messages is set to white and the foreground colors for all other messages are left as per the defaults.

Set-ScreenLogConfig -UseDefault
Sets or resets the colors to the default colors.
#>

function Set-ScreenLogConfig {
    Param (
        [System.ConsoleColor]$DebugForegroundColor,
        [System.ConsoleColor]$InfoForegroundColor,
        [System.ConsoleColor]$WarnForegroundColor,
        [System.ConsoleColor]$ErrorForegroundColor,
        [System.ConsoleColor]$CritForegroundColor,
        [System.ConsoleColor]$DebugBackgroundColor,
        [System.ConsoleColor]$InfoBackgroundColor,
        [System.ConsoleColor]$WarnBackgroundColor,
        [System.ConsoleColor]$ErrorBackgroundColor,
        [System.ConsoleColor]$CritBackgroundColor,
        [System.ConsoleColor]$ForegroundColor,
        [System.ConsoleColor]$BackgroundColor,
        [switch]$UseDefault
    )

    if ($DebugForegroundColor -eq $null -and $InfoForegroundColor -eq $null -and $WarnForegroundColor -eq $null -and $ErrorForegroundColor -eq $null -and $CritForegroundColor -eq $null -and $DebugBackgroundColor -eq $null -and $InfoBackgroundColor -eq $null -and $WarnBackgroundColor -eq $null -and $ErrorBackgroundColor -eq $null -and $CritBackgroundColor -eq $null -and $ForegroundColor -eq $null -and $BackgroundColor -eq $null -and $UseDefault -eq $false) {
        Write-Warning -Message "No parameters specified. Using default colors."
        $UseDefault = $true
    }
    
    if ($UseDefault) {
        $DefaultForegroundColor = [System.Console]::ForegroundColor
        $DefaultBackgroundColor = [System.Console]::BackgroundColor
        if ([System.Console]::ForegroundColor -eq -1) {
            $DefaultForegroundColor = [System.ConsoleColor]::White
        }
        if ([System.Console]::BackgroundColor -eq -1) {
            $DefaultBackgroundColor = [System.ConsoleColor]::Black
        }
        $ScreenLogConfig.DebugForegroundColor = [System.ConsoleColor]::Gray
        $ScreenLogConfig.InfoForegroundColor = $DefaultForegroundColor
        $ScreenLogConfig.WarnForegroundColor = [System.ConsoleColor]::Yellow
        $ScreenLogConfig.ErrorForegroundColor = [System.ConsoleColor]::Red
        $ScreenLogConfig.CritForegroundColor = [System.ConsoleColor]::Red
        $ScreenLogConfig.DebugBackgroundColor = $DefaultBackgroundColor
        $ScreenLogConfig.InfoBackgroundColor = $DefaultBackgroundColor
        $ScreenLogConfig.WarnBackgroundColor = $DefaultBackgroundColor
        $ScreenLogConfig.ErrorBackgroundColor = $DefaultBackgroundColor
        $ScreenLogConfig.CritBackgroundColor = $DefaultForegroundColor
        return
    }
    if ($ForegroundColor) {
        $ScreenLogConfig.DebugForegroundColor = $ForegroundColor
        $ScreenLogConfig.InfoForegroundColor = $ForegroundColor
        $ScreenLogConfig.WarnForegroundColor = $ForegroundColor
        $ScreenLogConfig.ErrorForegroundColor = $ForegroundColor
        $ScreenLogConfig.CritForegroundColor = $ForegroundColor
    }
    if ($BackgroundColor) {
        $ScreenLogConfig.DebugBackgroundColor = $BackgroundColor
        $ScreenLogConfig.InfoBackgroundColor = $BackgroundColor
        $ScreenLogConfig.WarnBackgroundColor = $BackgroundColor
        $ScreenLogConfig.ErrorBackgroundColor = $BackgroundColor
        $ScreenLogConfig.CritBackgroundColor = $BackgroundColor
    }
    if ($DebugForegroundColor) {
        $ScreenLogConfig.DebugForegroundColor = $DebugForegroundColor
    }
    if ($InfoForegroundColor) {
        $ScreenLogConfig.InfoForegroundColor = $InfoForegroundColor
    }
    if ($WarnForegroundColor) {
        $ScreenLogConfig.WarnForegroundColor = $WarnForegroundColor
    }
    if ($ErrorForegroundColor) {
        $ScreenLogConfig.ErrorForegroundColor = $ErrorForegroundColor
    }
    if ($CritForegroundColor) {
        $ScreenLogConfig.CritForegroundColor = $CritForegroundColor
    }
    if ($DebugBackgroundColor) {
        $ScreenLogConfig.DebugBackgroundColor = $DebugBackgroundColor
    }
    if ($InfoBackgroundColor) {
        $ScreenLogConfig.InfoBackgroundColor = $InfoBackgroundColor
    }
    if ($WarnBackgroundColor) {
        $ScreenLogConfig.WarnBackgroundColor = $WarnBackgroundColor
    }
    if ($ErrorBackgroundColor) {
        $ScreenLogConfig.ErrorBackgroundColor = $ErrorBackgroundColor
    }
    if ($CritBackgroundColor) {
        $ScreenLogConfig.CritBackgroundColor = $CritBackgroundColor
    }
}