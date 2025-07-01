@echo off
setlocal enabledelayedexpansion

REM 执行脚本前关闭QQ进程
:kill
taskkill /IM QQ.exe /F
goto loop

:loop
cls
for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /value') do set datetime=%%I
set current_hour=!datetime:~8,2!
set current_minute=!datetime:~10,2!
REM 设置QQ的启动时间与结束时间范围 (格式 HHMM)
set start_time=1145
set end_time=0130
set /a current_time_minutes=(!current_hour!*60)+!current_minute!
set /a start_time_minutes=(%start_time:~0,2%*60)+%start_time:~2,2%
set /a end_time_minutes=(%end_time:~0,2%*60)+%end_time:~2,2%
REM 支持跨天运行脚本
if !end_time_minutes! lss !start_time_minutes! (
    if !current_time_minutes! geq !start_time_minutes! ( goto run )
    if !current_time_minutes! lss !end_time_minutes! ( goto run )
) else (
    if !current_time_minutes! geq !start_time_minutes! if !current_time_minutes! lss !end_time_minutes! ( goto run )
)
echo 检查时间是否符合条件
timeout /t 60 >nul
goto loop

:run
REM 再执行一次关闭QQ进程，防止在时间范围外已启动QQ再启动QQ冲突
taskkill /IM QQ.exe /F
timeout /t 2
start "" /D "C:\Program Files\Tencent\QQNT" "QQ.exe"
timeout /t 7200
goto kill