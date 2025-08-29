@echo off
setlocal enabledelayedexpansion
TITLE  浏览器定时启动脚本

REM 浏览器路径与启动文件、运行时间配置
set "Browser-1_Path=C:\Program Files\Google\Chrome"
set "Browser-1_File=chrome.exe"
set "Browser-1_Gap=20000"
set "Browser-2_Path=C:\Program Files\Twinkstar Browser"
set "Browser-2_File=twinkstar.exe"
set "Browser-2_Gap=20000"
REM 启动时间和结束时间配置
set start_time=1030
set end_time=1630


REM 主循环
:loop
cls
REM 获取当前时间
for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /value') do set datetime=%%I
set current_hour=!datetime:~8,2!
set current_minute=!datetime:~10,2!
REM 将当前时间转换为分钟数以便比较
set /a current_time_minutes=(!current_hour!*60)+!current_minute!
set /a start_time_minutes=(%start_time:~0,2%*60)+%start_time:~2,2%
set /a end_time_minutes=(%end_time:~0,2%*60)+%end_time:~2,2%
REM 支持跨午夜的情况
if !end_time_minutes! lss !start_time_minutes! (
    if !current_time_minutes! geq !start_time_minutes! ( goto Run )
    if !current_time_minutes! lss !end_time_minutes! ( goto Run )
) else (
    if !current_time_minutes! geq !start_time_minutes! if !current_time_minutes! lss !end_time_minutes! ( goto Run )
)
REM 如果不在时间段内，等待1秒钟后再检查一次
echo 检查时间是否符合条件
timeout /t 1 >nul
goto loop

REM 如果在设置的时间段内，则会运行程序此指令
:Run
taskkill /IM "%Browser-1_File%"
timeout /t 2
start "" /D "%Browser-1_Path%" "%Browser-1_File%"
timeout /t %Browser-1_Gap%
taskkill /IM "%Browser-1_File%"
taskkill /IM "%Browser-2_File%"
timeout /t 2
start "" /D "%Browser-2_Path%" "%Browser-2_File%"
timeout /t %Browser-2_Gap%
taskkill /IM "%Browser-2_File%"
goto loop