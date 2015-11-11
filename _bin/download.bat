@echo off

setlocal EnableDelayedExpansion

set url=%1
set url=%url:~1,-1%
set convert=%2
set rotate=%3

cd _bin

:: Extracting token or broadcast id

set token="%url%"
for /l %%a IN (1,1,5) do (
    set token=!token:*/=!
)
set token=%token:~0,-1%

:: Random User-Agent

for /f "tokens=*" %%a in ('curl -s -m 3 http://api.useragent.io/ ^| jq .ua') do set uagent=%%a

if [%uagent%] == [] (
    for /f "tokens=*" %%a in ('curl -s -m 3 http://labs.wis.nu/ua/ ^| jq .ua') do set uagent=%%a
)

if [%uagent%] == [] (
    set uagent="Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/45.0.2454.93 Safari/537.36"
)

:: Check if token (long) or id (short)

if "%token:~13%"=="" (
    set parameter=broadcast_id
) else set parameter=token

:: Fetching broadcast info

for /f "tokens=1-6 delims={]" %%a in ('curl -s -k -A %uagent% -e "%url%" "https://api.periscope.tv/api/v2/getBroadcastPublic?%parameter%=%token%" ^| jq -r "\"\^(.user.username^){]\^(.user.display_name^){]\^(.broadcast.available_for_replay^){]\^(.broadcast.start^){]\^(.broadcast.state^){]\^(.broadcast.status^)\""') do (
    set user_name=%%a
    for /f "tokens=1 delims=" %%A in ('sanitize "%%b"') do set display_name=%%A
    set available=%%c
    set date_time=%%d
    set state=%%e
    for /f "tokens=1 delims=" %%B in ('sanitize "%%f"') do set message=%%B
    
)

if "%user_name%"=="" (
    echo.
    echo --- Error: replay has expired or was deleted by the owner.
    goto end
)

if %message%=="" set message="Untitled"

:: Adjusting date and time, constructing filename

set year=%date_time:~0,4%
set mon_day=%date_time:~5,5%
set time=%date_time:~11,8%
set off_min=%date_time:~-2%
set off_hour=%date_time:~-6,-3%

set server_date=%mon_day%-%year% %time% %off_hour%%off_min%

for /f %%a in ('getTimestamp -D "^'%server_date%^'"') do set your_date=%%a

set date=%your_date:~0,10%
set hours=%your_date:~11,2%
set mins=%your_date:~14,2%

set folder=%user_name% (%display_name:~1,-1%)

set file=[%date% %hours%-%mins%] %message:~1,-1%

:: Checking if live or unavailable

if "%state%"=="RUNNING" goto live

if "%available%"=="false" (
    echo --- Error: replay is not available.
    goto end
)

title Downloading %user_name% - %file%

:: Fetching replay url and cookies

for /f "tokens=1-8" %%a in ('curl -s -k -A %uagent% -e "%url%" "https://api.periscope.tv/api/v2/getAccessPublic?%parameter%=%token%" ^| jq -r "\"\^(.replay_url^) \^(.cookies[0].Name^) \^(.cookies[0].Value^) \^(.cookies[1].Name^) \^(.cookies[1].Value^) \^(.cookies[2].Name^) \^(.cookies[2].Value^)\""') do (
    set replay_url=%%a
    set name1=%%b
    set value1=%%c
    set name2=%%d
    set value2=%%e
    set name3=%%f
    set value3=%%g
)

set base_url=%replay_url:/playlist.m3u8=%

set header="Cookie:%name1%=%value1%;%name2%=%value2%;%name3%=%value3%"

set head_host="Host:replay.periscope.tv"

:: Generating download list and downloading chunks

set unique=%user_name%_%date%_%hours%-%mins%

set down_list=download_%unique%.txt

type NUL>..\_temp\%down_list%

for /f %%a in ('curl -s -k -H %header% -H %head_host% -e "%url%" -A %uagent% "%replay_url%" ^| findstr "chunk"') do (
    echo %base_url%/%%a>>..\_temp\%down_list%
)

if not exist "..\_temp\%unique%" md "..\_temp\%unique%" >nul 2>&1

echo.
echo --- Downloading %user_name% - %file%
echo.

aria2c --console-log-level=error --uri-selector=inorder --allow-overwrite=true --header %header% --header %head_host% --referer="%url%" -U %uagent% --connect-timeout=1 --retry-wait=1 -t 1 -m 0 -s 1 -j 30 -d "..\_temp\%unique%" -i "..\_temp\%down_list%"

:: Merging all chunks into one file

if not exist "..\Videos\%folder%" md "..\Videos\%folder%" >nul 2>&1

cd ..\_temp\%unique%

for %%a in (*.ts) do (
    for /f "tokens=2 delims=_." %%n in ("%%a") do (
       set /a newname=%%n+100000
       ren %%a !newname!.ts >nul 2>&1
	)
)

copy /b "*.ts" "..\..\Videos\%folder%\%file%.ts" >nul 2>&1

del /s /q *.ts >nul 2>&1

cd ..\..\_bin

:convert

:: Converting

if "%convert%"=="1" (
    echo.
    echo --- Started converting to mp4. To stop, press Ctrl+C three times.

    if "%rotate%"=="0" (
        ffmpeg -y -v error -i "..\Videos\%folder%\%file%.ts" -bsf:a aac_adtstoasc -codec copy "..\Videos\%folder%\%file%.mp4"
    )
    
    if "%rotate%"=="1" (
        ffmpeg -y -v error -i "..\Videos\%folder%\%file%.ts" -bsf:a aac_adtstoasc -acodec copy -vf "transpose=2" -crf 21 "..\Videos\%folder%\%file%.mp4"
    ) 
    
    if "%rotate%"=="2" (
        ffmpeg -y -v error -i "..\Videos\%folder%\%file%.ts" -bsf:a aac_adtstoasc -acodec copy -vf "transpose=1" -crf 21 "..\Videos\%folder%\%file%.mp4"
    )     
)

echo.
echo +-----------------------------------------------------------^>
echo ^|  Done^^! Saved in %user_name%'s folder as %file%
echo +-----------------------------------------------------------^>

goto end

:live

for /f %%a in ('curl -s -k -A %uagent% -e "%url%" "https://api.periscope.tv/api/v2/getAccessPublic?%parameter%=%token%" ^| jq -r ".hls_url"') do set hls_url=%%a

set file=[%date% %hours%-%mins%] -LIVE- %message:~1,-1%

title Recording %user_name% - %file%

if not exist "..\Videos\%folder%" md "..\Videos\%folder%" 2>NUL

echo.
echo --- Started recording. To stop, press Ctrl+C three times.
echo.
ffmpeg -y -v error -headers "Referer:%url%; User-Agent:%uagent:~1,-1%" -i "%hls_url%" -c copy "..\Videos\%folder%\%file%.ts"

goto convert

:end
echo.
pause
exit
