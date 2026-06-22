@echo off
REM ============================================================
REM  MovieTrack - Regenerate freezed / json_serializable code
REM  Run this after editing any model in lib\core\models\
REM ============================================================

setlocal
set "FLUTTER_BIN=C:\Users\User\flutter\bin"
set "PATH=%FLUTTER_BIN%;%PATH%"
cd /d "%~dp0"

echo ============================================================
echo  MovieTrack - Code Generation (build_runner)
echo ============================================================
echo.

echo [..] flutter pub get...
call flutter pub get

echo.
echo [..] Running build_runner (generates *.freezed.dart + *.g.dart)...
call dart run build_runner build --delete-conflicting-outputs

echo.
echo [OK] Code generation complete.
echo.
endlocal
pause
