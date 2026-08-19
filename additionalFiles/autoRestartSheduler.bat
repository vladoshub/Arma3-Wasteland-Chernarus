@echo off
setlocal EnableExtensions

title ARMA 3 WASTELAND - Watchdog
color 0A

rem ============================================================================
rem Configuration
rem ============================================================================

rem Arma 3 server executable / BEC location.
set "ARMA3_DIR=D:\SteamLibrary\steamapps\common\Arma 3"

rem Profiles and Workshop location.
rem If everything is in the same Arma 3 folder, replace the next line with:
rem set "ARMA3_CONTENT_DIR=%ARMA3_DIR%"
set "ARMA3_CONTENT_DIR=D:\SteamLibrary\steamapps\common\Arma 3"

set "SERVER_EXE=arma3server_x64.exe"

set "PROFILE_DIR=%ARMA3_CONTENT_DIR%"
set "WORKSHOP_DIR=%ARMA3_CONTENT_DIR%\!Workshop"

rem Health-check / restart timing, in seconds.
set "CHECK_INTERVAL=5"
set "RESTART_DELAY=10"
set "SERVER_INIT_DELAY=120"


rem Server parameters.
set "SERVER_PORT=2302"
set "SERVER_FPS_LIMIT=300"
set "SERVER_CONFIG=server.cfg"
set "SERVER_MOD=@extDB3;"

set "MODS=%WORKSHOP_DIR%\@CUP Terrains - Core;%WORKSHOP_DIR%\@CUP Terrains - Maps;%WORKSHOP_DIR%\@CUP Weapons;%WORKSHOP_DIR%\@CUP Units;%WORKSHOP_DIR%\@CUP Vehicles;%WORKSHOP_DIR%\@CBA_A3"

rem ============================================================================
rem Startup validation
rem ============================================================================

if not exist "%ARMA3_DIR%\%SERVER_EXE%" (
    echo [ERROR] Arma 3 server executable not found:
    echo         "%ARMA3_DIR%\%SERVER_EXE%"
    goto fatal
)

if "%ENABLE_BEC%"=="1" (
    if not exist "%BEC_DIR%\%BEC_EXE%" (
        echo [ERROR] BEC executable not found:
        echo         "%BEC_DIR%\%BEC_EXE%"
        goto fatal
    )
)

echo [%date% %time%] Watchdog started.
echo [%date% %time%] Direct server watchdog mode enabled.
echo.

goto checkServer


rem ============================================================================
rem Watchdog
rem ============================================================================

:checkServer
tasklist /FI "IMAGENAME eq %SERVER_EXE%" /NH 2>nul | find /I "%SERVER_EXE%" >nul

if errorlevel 1 (
    echo [%date% %time%] [WARN] Arma 3 server is not running.
    goto restartServer
)

if "%ENABLE_BEC%"=="1" goto checkBEC
goto waitNextCheck



:waitNextCheck
echo [%date% %time%] [OK] Arma 3 server is running. Next check in %CHECK_INTERVAL%s.
timeout /t %CHECK_INTERVAL% /nobreak >nul
goto checkServer


rem ============================================================================
rem Server restart
rem ============================================================================

:restartServer
echo [%date% %time%] Starting server in %RESTART_DELAY%s...
timeout /t %RESTART_DELAY% /nobreak >nul

goto startServer


:startServer
echo [%date% %time%] Starting ARMA 3 WASTELAND...

rem /D sets the server working directory, so relative files such as server.cfg
rem are resolved from the Arma 3 server folder.
start "" /D "%ARMA3_DIR%" "%ARMA3_DIR%\%SERVER_EXE%" ^
    "-profiles=%PROFILE_DIR%" ^
    -limitFPS=%SERVER_FPS_LIMIT% ^
    -netlog ^
    -port=%SERVER_PORT% ^
    "-serverMod=%SERVER_MOD%" ^
    -autoInit ^
    -dologs ^
    -adminlog ^
    -freezecheck ^
    "-config=%SERVER_CONFIG%" ^
    -world=empty ^
    "-mod=%MODS%"

if errorlevel 1 (
    echo [%date% %time%] [ERROR] Failed to execute "%SERVER_EXE%".
    timeout /t %CHECK_INTERVAL% /nobreak >nul
    goto checkServer
)

echo [%date% %time%] Server process launch command sent.
echo [%date% %time%] Waiting %SERVER_INIT_DELAY%s for server initialization...
timeout /t %SERVER_INIT_DELAY% /nobreak >nul

rem Verify that the server actually stayed alive after startup.
tasklist /FI "IMAGENAME eq %SERVER_EXE%" /NH 2>nul | find /I "%SERVER_EXE%" >nul
if errorlevel 1 (
    echo [%date% %time%] [ERROR] Server exited during startup. Retrying later...
    timeout /t %CHECK_INTERVAL% /nobreak >nul
    goto checkServer
)

goto checkServer


rem ============================================================================
rem Fatal configuration error
rem ============================================================================

:fatal
echo.
echo Watchdog stopped because of a configuration error.
pause
exit /b 1
