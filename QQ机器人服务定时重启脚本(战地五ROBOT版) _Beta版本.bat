@echo off
setlocal enabledelayedexpansion
TITLE  QQ机器人服务定时重启脚本(战地五ROBOT版) v9.1.0
REM 设置ROBOT和QQ的存放路径
set "ROBOT_Path=C:\Program Files Green"
set "QQ_Path=C:\Program Files\Tencent\QQNT"
REM 设置ROBOT和QQ的启动文件
set "ROBOT_File=catclient.exe"
set "QQ_File=QQ.exe"
REM 设置脚本的启动与结束时间范围 (格式 HHMM)
set "start_time=1200"
set "end_time=0200"
REM 设置QQ多长时间重启
set Gap=6100

:: 功能：选项页面
:UI
cls
echo. 
echo. 
echo.                      选择要执行的方案                 
echo. =========================================================
echo. 
echo.     1. 指定时间范围内循环        (结束后保留ROBOT程序)
echo. 
echo.     2. 指定时间范围内循环       (结束后不保留ROBOT程序)
echo. 
echo.     3. 指定次数范围内循环        (结束后保留ROBOT程序)
echo. 
echo.     4. 指定次数范围内循环        (结束后不保留ROBOT程序)
echo. 
echo.     5. 二十四小时一直循环         (需手动结束ROBOT程序)
echo. 
echo.     6. 只启动[BFV ROBOT]         (需手动结束ROBOT程序)
echo. 
echo. =========================================================
choice /c 123456 /n /M "请输入要执行的选项："
if %errorlevel%==1 goto Time_to_Run
if %errorlevel%==2 goto Time_to_Run
if %errorlevel%==3 goto Loop_to_Run
if %errorlevel%==4 goto Loop_to_Run
if %errorlevel%==5 goto 24H
if %errorlevel%==6 goto ROBOT  

:: 方案跳转分区
:Time_to_Run
cls
call :Time
if !end_time_minutes! lss !start_time_minutes! (
    if !current_time_minutes! geq !start_time_minutes! ( goto Run_%errorlevel% )
    if !current_time_minutes! lss !end_time_minutes! ( goto Run_%errorlevel% )
) else (
    if !current_time_minutes! geq !start_time_minutes! if !current_time_minutes! lss !end_time_minutes! ( goto Run_%errorlevel% )
)
echo 检查时间是否符合条件
timeout /t 1 >nul
goto Time_to_Run

:Loop_to_Run
cls
set /p count=请输入要循环的次数(必须为正整数)：
goto Run_%errorlevel%


:: 方案执行分区

:: 指定时间范围内循环 (结束后不保留ROBOT程序)
:Run_1
cls
call :Loop_1
goto Time_to_Run

:: 指定时间范围内循环 (结束后保留ROBOT程序)
:Run_2
cls
call :Loop_1
goto Time_to_Run

:: 指定次数循环 (结束后不保留ROBOT程序)
:Run_3
for /l %%i in (1,1,%count%) do (
    cls
    echo 第 %%i 次循环
    call :Loop_1
)
goto UI

:: 指定次数循环 (结束后保留ROBOT程序)
:Run_4
for /l %%i in (1,1,%count%) do (
    cls
    echo 第 %%i 次循环
    call :Loop_2
)
goto UI

:: 功能模块

:: 指定次数循环 (结束后保留ROBOT程序)
:24H
cls
call :Loop_2
goto 24H

:: 获取当前时间
:Time
for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /value') do set datetime=%%I
set current_hour=!datetime:~8,2!
set current_minute=!datetime:~10,2!
:: 将当前时间转换为分钟数以便比较
set /a current_time_minutes=(!current_hour!*60)+!current_minute!
set /a start_time_minutes=(%start_time:~0,2%*60)+%start_time:~2,2%
set /a end_time_minutes=(%end_time:~0,2%*60)+%end_time:~2,2%
exit /b

:: 结束后保留ROBOT程序
:Loop_1
call :Kill
timeout /t 6
start "" /D "%QQ_Path%" /MIN "%QQ_File%"
timeout /t 10
call :ROBOT
timeout /t %Gap%
taskkill /IM QQ.exe /F
exit /b

:: 结束后不保留ROBOT程序
:Loop_2
call :Kill
timeout /t 6
start "" /D "%QQ_Path%" /MIN "%QQ_File%"
timeout /t 10
call :ROBOT
timeout /t %Gap%
call :Kill
exit /b

:: ROBOT程序启动
:ROBOT
start "" /D "%ROBOT_Path%" /MIN "%ROBOT_File%"
cls
exit /b

:: 结束ROBOT程序与QQ程序
:Kill
taskkill /IM QQ.exe /F
taskkill /IM CatClientD.exe
taskkill /IM CatClientE.exe
taskkill /IM CatClientL.exe
cls
exit /b