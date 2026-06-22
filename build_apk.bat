@echo off
REM ============================================================
REM  MovieTrack - Build release APK
REM  Output: build\app\outputs\flutter-apk\app-release.apk
REM ============================================================

setlocal
set "FLUTTER_BIN=C:\Users\User\flutter\bin"
set "PATH=%FLUTTER_BIN%;%PATH%"
cd /d "%~dp0"

echo ============================================================
echo  MovieTrack - Build APK
echo ============================================================
echo.

echo [..] flutter pub get...
call flutter pub get

echo.
echo [..] Building release APK (this can take a few minutes)...
call flutter build apk --release

echo.
echo [OK] Done. APK location:
echo     build\app\outputs\flutter-apk\app-release.apk
echo.
endlocal
pause
