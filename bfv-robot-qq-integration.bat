@echo off
setlocal enabledelayedexpansion
TITLE  BFV ROBOT 自动连接 QQ 脚本
:: 自定义ROBOT和QQ存放路径
set "ROBOT_Path=C:\Program Files Green"
set "QQ_Path=C:\Program Files Green\NapCat.Shell"
:: 自定义ROBOT和QQ的启动文件
set "QQ_File=napcat.quick.bat"
:: 自定义启动与结束时间范围 (格式 HHMM)
set "start_time=1200"
set "end_time=0200"
:: 自定义QQ多长时间重启
set Gap=6100

:: 功能：选项页面
:UI
cls
echo. 
echo. 
echo.                      选择要执行的方案                 
echo. =========================================================
echo. 
echo.     1. 指定时间范围内循环       (结束后不保留ROBOT程序)
echo. 
echo.     2. 指定时间范围内循环        (结束后保留ROBOT程序)
echo. 
echo.     3. 指定次数范围内循环       (结束后不保留ROBOT程序)
echo. 
echo.     4. 指定次数范围内循环        (结束后保留ROBOT程序)
echo. 
echo.     5. 只启动[BFV ROBOT]         (需手动结束ROBOT程序)
echo. 
echo. =========================================================
choice /c 12345 /n /M "请输入要执行的选项："
if %errorlevel%==1 goto Time_1
if %errorlevel%==2 goto Time_2
if %errorlevel%==3 goto UI_1
if %errorlevel%==4 goto UI_2
if %errorlevel%==5 goto ROBOT  

:UI_1
cls
set /p count=请输入要循环的次数(必须为正整数)：
goto Run_3

:UI_2
cls
set /p count=请输入要循环的次数(必须为正整数)：
goto Run_4

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

:Time_1
cls
call :Time
if !end_time_minutes! lss !start_time_minutes! (
    if !current_time_minutes! geq !start_time_minutes! ( goto Run_1 )
    if !current_time_minutes! lss !end_time_minutes! ( goto Run_1 )
) else (
    if !current_time_minutes! geq !start_time_minutes! if !current_time_minutes! lss !end_time_minutes! ( goto Run_1 )
)
echo 检查时间是否符合条件
timeout /t 1 >nul
goto Time_1

:Time_2
cls
call :Time
if !end_time_minutes! lss !start_time_minutes! (
    if !current_time_minutes! geq !start_time_minutes! ( goto Run_2 )
    if !current_time_minutes! lss !end_time_minutes! ( goto Run_2 )
) else (
    if !current_time_minutes! geq !start_time_minutes! if !current_time_minutes! lss !end_time_minutes! ( goto Run_2 )
)
echo 检查时间是否符合条件
timeout /t 1 >nul
goto Time_2

:: 指定时间范围内循环 (结束后不保留ROBOT程序)
:Run_1
cls
call :Loop_1
goto time_1

:: 指定时间范围内循环 (结束后保留ROBOT程序)
:Run_2
cls
call :Loop_1
goto time_2

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

:: 结束后不保留ROBOT程序
:Loop_1
call :Kill
timeout /t 6
start "" /D "%QQ_Path%" /MIN "%QQ_File%"
timeout /t 10
call :ROBOT
timeout /t %Gap%
call :Kill
exit /b

:: 结束后保留ROBOT程序
:Loop_2
call :Kill
timeout /t 6
start "" /D "%QQ_Path%" /MIN "%QQ_File%"
timeout /t 10
call :ROBOT
timeout /t %Gap%
taskkill /IM QQ.exe /F
exit /b

:ROBOT
start "" /D "%ROBOT_Path%\CatClientD" /MIN "catclientD.exe"
start "" /D "%ROBOT_Path%\CatClientE" /MIN "catclientE.exe"
start "" /D "%ROBOT_Path%\CatClientL" /MIN "catclientL.exe"
cls
exit /b

:Kill
taskkill /IM QQ.exe /F
taskkill /IM CatClientD.exe /F
taskkill /IM CatClientE.exe /F
taskkill /IM CatClientL.exe /F
cls
exit /b
