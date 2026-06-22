@echo off
REM ============================================================
REM  MovieTrack - Run on Android emulator
REM  Double-click this file to launch the app on Android.
REM ============================================================

setlocal

REM --- Config: adjust these paths if your setup differs ---
set "FLUTTER_BIN=C:\Users\User\flutter\bin"
set "ADB=C:\Users\User\AppData\Local\Android\sdk\platform-tools\adb.exe"
set "EMULATOR_ID=Pixel_9_Pro_XL"

REM --- Add Flutter to PATH for this session ---
set "PATH=%FLUTTER_BIN%;%PATH%"

cd /d "%~dp0"

echo ============================================================
echo  MovieTrack - Android Launcher
echo ============================================================
echo.

REM --- Check if an Android device/emulator is already running ---
"%ADB%" get-state >nul 2>&1
if %errorlevel%==0 (
    echo [OK] Android device already connected.
    goto :run
)

echo [..] No device found. Starting emulator "%EMULATOR_ID%"...
start "" flutter emulators --launch %EMULATOR_ID%

echo [..] Waiting for the emulator to boot (this can take 1-2 minutes)...
"%ADB%" wait-for-device
:wait_boot
for /f "tokens=*" %%i in ('"%ADB%" shell getprop sys.boot_completed 2^>nul') do set BOOT=%%i
if not "%BOOT%"=="1" (
    timeout /t 3 /nobreak >nul
    goto :wait_boot
)
echo [OK] Emulator is ready.

:run
echo.
echo [..] flutter pub get...
call flutter pub get

echo.
echo [..] Launching MovieTrack on Android...
echo     (Press 'r' to hot reload, 'R' to hot restart, 'q' to quit)
echo.
call flutter run

endlocal
pause
