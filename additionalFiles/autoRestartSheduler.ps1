#Requires -Version 5.1
# Configuration is inherited from autoRestartSheduler.bat. No extra modules needed.

function Write-WatchdogLog {
    param([string]$Message, [string]$Level = 'INFO')
    $line = '[{0:yyyy-MM-dd HH:mm:ss}] [{1}] {2}' -f (Get-Date), $Level, $Message
    Write-Host $line
    try { Add-Content -LiteralPath $env:WATCHDOG_LOG -Value $line -Encoding UTF8 -ErrorAction Stop }
    catch { Write-Warning "Cannot write watchdog log: $($_.Exception.Message)" }
}

function ConvertTo-NativeArgument {
    param([string]$Value)
    # Windows CommandLineToArgvW quoting, including trailing backslashes.
    $escaped = [regex]::Replace($Value, '(\\*)"', '$1$1\"')
    $escaped = [regex]::Replace($escaped, '(\\+)$', '$1$1')
    return '"' + $escaped + '"'
}

function Get-ServerProcess {
    param([string]$ServerPath, [int]$Port)
    $name = [IO.Path]::GetFileName($ServerPath).Replace("'", "''")
    $matchesForServer = @(Get-CimInstance Win32_Process -Filter "Name = '$name'" -ErrorAction Stop | Where-Object {
        if (-not $_.ExecutablePath -or -not $_.CommandLine) {
            throw 'Cannot identify an existing Arma process. Run the BAT with the same permissions as the server.'
        }
        $samePath = $_.ExecutablePath -ieq $ServerPath
        $isClient = $_.CommandLine -match '(?i)(?:^|\s)"?-client(?:"|\s|$)'
        $portMatch = [regex]::Match($_.CommandLine, '(?i)(?:^|\s)"?-port=(\d+)(?:"|\s|$)')
        $processPort = 2302
        if ($portMatch.Success) { $processPort = [int]$portMatch.Groups[1].Value }
        $samePath -and -not $isClient -and $processPort -eq $Port
    })
    if ($matchesForServer.Count -gt 1) {
        throw "Multiple servers use the same executable and port $Port. Close duplicate servers first."
    }
    if ($matchesForServer.Count -eq 1) {
        return Get-Process -Id $matchesForServer[0].ProcessId -ErrorAction SilentlyContinue
    }
    return $null
}

function Test-SteamQuery {
    param([string]$Address, [int]$Port, [int]$TimeoutMs)
    $client = New-Object Net.Sockets.UdpClient
    try {
        $client.Client.ReceiveTimeout = $TimeoutMs
        $client.Connect($Address, $Port)
        [byte[]]$query = @(255, 255, 255, 255, 84) + [Text.Encoding]::ASCII.GetBytes("Source Engine Query`0")
        $remote = New-Object Net.IPEndPoint ([Net.IPAddress]::Any, 0)
        # A2S_INFO may first return an S2C_CHALLENGE; resend with its four bytes.
        for ($attempt = 0; $attempt -lt 2; $attempt++) {
            [void]$client.Send($query, $query.Length)
            [byte[]]$reply = $client.Receive([ref]$remote)
            if ($reply.Length -ge 6 -and [BitConverter]::ToInt32($reply, 0) -eq -1) {
                if ($reply[4] -eq 73 -and $reply.Length -gt 20) { return $true }
                if ($reply[4] -eq 65 -and $reply.Length -ge 9 -and $attempt -eq 0) {
                    $query = $query + $reply[5..8]
                    continue
                }
            }
            # A split A2S reply also demonstrates that this server is responding.
            if ($reply.Length -ge 12 -and [BitConverter]::ToInt32($reply, 0) -eq -2) { return $true }
            return $false
        }
        return $false
    }
    catch [Net.Sockets.SocketException] { return $false }
    finally { $client.Close() }
}

function Test-ServerReady {
    param([Diagnostics.Process]$ServerProcess, [int]$Port, [string]$Address, [int]$TimeoutMs)
    if ($ServerProcess.HasExited) { return $false }
    # Do not mistake a reply from another server for this process being ready.
    # Enumeration errors must propagate, rather than trigger a false restart.
    $ownedPorts = @(Get-NetUDPEndpoint -ErrorAction Stop | Where-Object {
        $_.OwningProcess -eq $ServerProcess.Id
    } | Select-Object -ExpandProperty LocalPort)
    if ($ownedPorts -notcontains $Port -or $ownedPorts -notcontains ($Port + 1)) { return $false }
    return Test-SteamQuery -Address $Address -Port ($Port + 1) -TimeoutMs $TimeoutMs
}

function Stop-UnhealthyServer {
    param([Diagnostics.Process]$ServerProcess)
    if (-not $ServerProcess.HasExited) {
        Stop-Process -InputObject $ServerProcess -Force -ErrorAction Stop
        if (-not $ServerProcess.WaitForExit(10000)) { throw "PID $($ServerProcess.Id) did not stop." }
    }
}

function Invoke-ArmaWatchdog {
    $ErrorActionPreference = 'Stop'
    $mutex = $null
    $ownsMutex = $false
    try {
        if ($env:OS -ne 'Windows_NT' -or -not $env:ARMA3_DIR) { throw 'Start autoRestartSheduler.bat on Windows.' }
        $serverPath = [IO.Path]::GetFullPath((Join-Path $env:ARMA3_DIR $env:SERVER_EXE))
        $configPath = $env:SERVER_CONFIG
        if (-not [IO.Path]::IsPathRooted($configPath)) { $configPath = Join-Path $env:ARMA3_DIR $configPath }
        foreach ($path in @($serverPath, $configPath)) {
            if (-not (Test-Path -LiteralPath $path -PathType Leaf)) { throw "File not found: $path" }
        }
        foreach ($mod in (($env:MODS + ';' + $env:SERVER_MOD) -split ';')) {
            if ([string]::IsNullOrWhiteSpace($mod)) { continue }
            $modPath = $mod
            if (-not [IO.Path]::IsPathRooted($modPath)) { $modPath = Join-Path $env:ARMA3_DIR $modPath }
            if (-not (Test-Path -LiteralPath $modPath -PathType Container)) { throw "Mod directory not found: $modPath" }
        }
        $serverPort = [int]$env:SERVER_PORT
        if ($serverPort -lt 1 -or $serverPort -gt 65531) { throw 'SERVER_PORT must be between 1 and 65531.' }
        foreach ($setting in @('CHECK_INTERVAL', 'RESTART_DELAY', 'SERVER_INIT_DELAY', 'SERVER_UNRESPONSIVE_TIMEOUT', 'QUERY_TIMEOUT_MS')) {
            $value = [Environment]::GetEnvironmentVariable($setting)
            if ($value -notmatch '^\d+$' -or [int]$value -lt 1) { throw "$setting must be a positive number." }
        }
        # Fail visibly if Windows cannot inspect UDP ownership; never kill a server
        # merely because a health-check command is unavailable or access is denied.
        Get-NetUDPEndpoint -ErrorAction Stop | Out-Null
        $hash = [Security.Cryptography.SHA256]::Create()
        try { $key = [BitConverter]::ToString($hash.ComputeHash([Text.Encoding]::UTF8.GetBytes("$($serverPath.ToLowerInvariant()):$serverPort"))).Replace('-', '') }
        finally { $hash.Dispose() }
        $mutex = New-Object Threading.Mutex ($false, "Global\Arma3WastelandWatchdog-$key")
        try { $ownsMutex = $mutex.WaitOne(0) }
        catch [Threading.AbandonedMutexException] { $ownsMutex = $true }
        if (-not $ownsMutex) {
            Write-WatchdogLog 'A watchdog for this server and port is already running.' 'WARN'
            return 0
        }

        $serverArguments = @(
            "-profiles=$env:PROFILE_DIR", "-limitFPS=$env:SERVER_FPS_LIMIT", '-netlog', "-port=$serverPort",
            "-serverMod=$env:SERVER_MOD", '-autoInit', '-dologs', '-adminlog', '-freezecheck',
            "-config=$configPath", '-world=empty', "-mod=$env:MODS"
        ) | ForEach-Object { ConvertTo-NativeArgument $_ }
        $serverProcess = $null
        $startupTimer = $null
        $failureTimer = $null
        $ready = $false
        Write-WatchdogLog "Watchdog started. Server: $serverPath; game port: $serverPort; Steam query: $($env:QUERY_ADDRESS):$($serverPort + 1)."
        Write-WatchdogLog "Startup timeout: $($env:SERVER_INIT_DELAY)s; unresponsive timeout: $($env:SERVER_UNRESPONSIVE_TIMEOUT)s."

        while ($true) {
            try {
                if ($null -eq $serverProcess -or $serverProcess.HasExited) {
                    if ($null -ne $serverProcess) {
                        Write-WatchdogLog "Server PID $($serverProcess.Id) exited, code $($serverProcess.ExitCode)." 'WARN'
                        $serverProcess.Dispose()
                        $serverProcess = $null
                    }
                    # Adopt an existing matching server, including one started manually.
                    $serverProcess = Get-ServerProcess -ServerPath $serverPath -Port $serverPort
                    if ($null -eq $serverProcess) {
                        Write-WatchdogLog "Starting server in $($env:RESTART_DELAY)s..."
                        Start-Sleep -Seconds ([int]$env:RESTART_DELAY)
                        # Recheck after the delay to avoid racing a manual launch.
                        $serverProcess = Get-ServerProcess -ServerPath $serverPath -Port $serverPort
                        if ($null -eq $serverProcess) {
                            $serverProcess = Start-Process -FilePath $serverPath -WorkingDirectory $env:ARMA3_DIR -ArgumentList ($serverArguments -join ' ') -PassThru -ErrorAction Stop
                        }
                    }
                    Write-WatchdogLog "Monitoring PID $($serverProcess.Id). Waiting for server response..."
                    $startupTimer = [Diagnostics.Stopwatch]::StartNew()
                    $failureTimer = $null
                    $ready = $false
                }

                if (Test-ServerReady -ServerProcess $serverProcess -Port $serverPort -Address $env:QUERY_ADDRESS -TimeoutMs ([int]$env:QUERY_TIMEOUT_MS)) {
                    if (-not $ready) { Write-WatchdogLog "Server PID $($serverProcess.Id) is responding to Steam queries." }
                    elseif ($null -ne $failureTimer) { Write-WatchdogLog 'Server response recovered; restart cancelled.' }
                    $ready = $true
                    $startupTimer = $null
                    $failureTimer = $null
                }
                elseif (-not $ready) {
                    if ($startupTimer.Elapsed.TotalSeconds -ge [int]$env:SERVER_INIT_DELAY) {
                        Write-WatchdogLog "PID $($serverProcess.Id) did not respond within $($env:SERVER_INIT_DELAY)s. Stopping it before retry. Check the newest RPT in $env:PROFILE_DIR." 'ERROR'
                        Stop-UnhealthyServer $serverProcess
                    }
                }
                else {
                    if ($null -eq $failureTimer) {
                        Write-WatchdogLog "PID $($serverProcess.Id) stopped responding; waiting $($env:SERVER_UNRESPONSIVE_TIMEOUT)s before restart." 'WARN'
                        $failureTimer = [Diagnostics.Stopwatch]::StartNew()
                    }
                    elseif ($failureTimer.Elapsed.TotalSeconds -ge [int]$env:SERVER_UNRESPONSIVE_TIMEOUT) {
                        Write-WatchdogLog "PID $($serverProcess.Id) remains unresponsive. Stopping it before retry." 'ERROR'
                        Stop-UnhealthyServer $serverProcess
                    }
                }
            }
            catch {
                Write-WatchdogLog $_.Exception.Message 'ERROR'
                # An inspection/permission error is not evidence of a dead server.
                $failureTimer = $null
                if ($null -ne $startupTimer) { $startupTimer.Restart() }
            }
            Start-Sleep -Seconds ([int]$env:CHECK_INTERVAL)
        }
    }
    catch {
        Write-WatchdogLog $_.Exception.Message 'ERROR'
        return 1
    }
    finally {
        if ($ownsMutex) { $mutex.ReleaseMutex() }
        if ($null -ne $mutex) { $mutex.Dispose() }
        # Closing the watchdog leaves a healthy server running.
    }
}

# Dot-sourcing exposes the functions for diagnostics without starting a server.
if ($MyInvocation.InvocationName -ne '.') { exit (Invoke-ArmaWatchdog) }
