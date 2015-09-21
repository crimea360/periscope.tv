@echo off

setlocal EnableDelayedExpansion

title Periscope video downloader v2.0

echo +-----------------------------------------------+
echo ^|        Periscope video downloader v2.0        ^|
echo +-----------------------------------------------+
echo ^|          Made by n3tman   2015-09-21          ^|
echo +-----------------------------------------------+
echo.
echo Paste URL below (right click - Paste) and press Enter
echo.
echo Example 1: https://www.periscope.tv/w/1LyxBeXmWObJN
echo.
echo Example 2: https://www.periscope.tv/w/aM1wNjE1ODAxMHwxcm14UGF2UkxOREtOGeN8ChyFlAXW4ihB_3NA9h3UysetWhz5G8WQdi7dsro=
echo.
echo Example 3: https://www.periscope.tv/Flad_Land/1zqJVmdaBvXGB
echo.
echo Example 4: http://www.perisearch.net/w/aM7_kzIzMjk1NTJ8MU1ZR05iWkFhUnZHd2_M8lSATtJLmbT0wvem7Ml6TTJgRS4_ReuSeQNGN73z
echo.

:: Erasing _temp folder

if exist _temp (
    rd /s /q _temp >nul 2>&1
    md _temp >nul 2>&1
) else md _temp >nul 2>&1

if not exist Videos md Videos >nul 2>&1

:start

set convert=
set rotate=

set /p url="URL (leave blank to exit): " || goto end

set /p convert="- Convert to mp4? (leave blank if no) "

if not [%convert%]==[] (
    set /p rotate="- Rotate? (leave blank if no) "
)

if not "%convert%"=="" set convert=1
if not "%rotate%"=="" set rotate=1

start /min _bin\download.bat "%url%" %convert% %rotate%

echo.
echo -- OK^^! Started downloading in a separate window.
echo.

goto start

:end

echo.
pause