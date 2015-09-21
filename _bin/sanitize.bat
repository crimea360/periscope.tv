@echo off

set string=%1

set string="%string:"=%"

set string=%string:|=%

set string=%string:<=%

set string=%string:>=%

set string=%string:^=^^%

set string=%string:&=^&%

for /f "tokens=1 delims=" %%a in ('echo %string% ^| jrepl "[%:/\\*?\x00-\x1F\x7F]" "" ^| jrepl "\s+" " " ^| jrepl "\s+$" ""') do set string=%%a

echo %string%