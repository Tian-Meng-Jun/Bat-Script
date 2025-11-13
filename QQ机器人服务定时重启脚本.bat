@echo off
setlocal enabledelayedexpansion

REM 脚本配置
set "QQ_Path=C:\Program Files\Tencent\QQNT"
set "QQ_File=QQ.exe"
set Time-based switch=0
set start_time=1145
set end_time=0130

:Process
cls
tasklist /fi "imagename eq QQ.exe" /nh | find /i "QQ.exe" >nul
if %errorlevel% equ 0 (
    if %Time-based switch% equ 1 (
        call :time
        call :run
    ) else (
        timeout /t 7200
        taskkill /IM QQ.exe /F
        timeout /t 2
        goto :Process
    )
) else (
    if %Time-based switch% equ 1 (
        call :time
        call :run
    ) else (
        echo 未检测到QQ运行
        timeout /t 1 >nul
        goto :Process
    ) 
)

:time
for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /value') do set datetime=%%I
set current_hour=!datetime:~8,2!
set current_minute=!datetime:~10,2!
set /a current_time_minutes=(!current_hour!*60)+!current_minute!
set /a start_time_minutes=(%start_time:~0,2%*60)+%start_time:~2,2%
set /a end_time_minutes=(%end_time:~0,2%*60)+%end_time:~2,2%
exit /b

:run
if !end_time_minutes! lss !start_time_minutes! (
    if !current_time_minutes! geq !start_time_minutes! ( goto Loop )
    if !current_time_minutes! lss !end_time_minutes! ( goto Loop )
) else (
    if !current_time_minutes! geq !start_time_minutes! if !current_time_minutes! lss !end_time_minutes! ( goto Loop )
)
echo 检查时间是否符合条件
echo 当前时间%current_time_minutes%不符合条件
timeout /t 60 >nul
goto Process
exit /b

:Loop
taskkill /IM QQ.exe /F
timeout /t 2
start "" /D "%QQ_Path%" "%QQ_File%"
timeout /t 7200
taskkill /IM QQ.exe /F
goto Process