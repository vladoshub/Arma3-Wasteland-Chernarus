@echo off
setlocal EnableExtensions DisableDelayedExpansion

title ARMA 3 WASTELAND - Watchdog
color 0A

rem ============================================================================
rem Configuration
rem ============================================================================

rem Arma 3 server executable location.
set "ARMA3_DIR=C:\Program Files (x86)\Steam\steamapps\common\Arma 3"

rem Profiles and Workshop location.
rem If everything is in the same Arma 3 folder, replace the next line with:
rem set "ARMA3_CONTENT_DIR=%ARMA3_DIR%"
set "ARMA3_CONTENT_DIR=C:\Program Files (x86)\Steam\steamapps\common\Arma 3"

set "SERVER_EXE=arma3server_x64.exe"

set "PROFILE_DIR=%ARMA3_CONTENT_DIR%"
set "WORKSHOP_DIR=%ARMA3_CONTENT_DIR%\!Workshop"

rem Health-check / restart timing, in seconds.
set "CHECK_INTERVAL=5"
set "RESTART_DELAY=10"
rem Allow the server up to five minutes to start answering Steam queries.
set "SERVER_INIT_DELAY=300"
rem Restart a running process only after continuous failed health checks.
set "SERVER_UNRESPONSIVE_TIMEOUT=120"
set "QUERY_TIMEOUT_MS=2000"
rem Local Steam query address. Change only if the server binds a specific IP.
set "QUERY_ADDRESS=127.0.0.1"
set "WATCHDOG_LOG=%~dp0arma3-watchdog.log"


rem Server parameters.
set "SERVER_PORT=2302"
set "SERVER_FPS_LIMIT=300"
set "SERVER_CONFIG=server.cfg"
set "SERVER_MOD=@extDB3;"

set "MODS=%WORKSHOP_DIR%\@CUP Terrains - Core;%WORKSHOP_DIR%\@CUP Terrains - Maps;%WORKSHOP_DIR%\@CUP Weapons;%WORKSHOP_DIR%\@CUP Units;%WORKSHOP_DIR%\@CUP Vehicles;%WORKSHOP_DIR%\@CBA_A3"

rem ============================================================================
rem Start the supervisor. Keep autoRestartSheduler.ps1 next to this BAT file.
rem ============================================================================

if not exist "%~dp0autoRestartSheduler.ps1" (
    echo [ERROR] Missing "%~dp0autoRestartSheduler.ps1".
    goto fatal
)

"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" ^
    -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%~dp0autoRestartSheduler.ps1"
if errorlevel 1 goto fatal
exit /b 0

:fatal
echo.
echo Watchdog stopped. See the error above and "%WATCHDOG_LOG%".
pause
exit /b 1
