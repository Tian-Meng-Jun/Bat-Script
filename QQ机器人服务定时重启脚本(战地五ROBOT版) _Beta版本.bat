@echo off
setlocal enabledelayedexpansion
TITLE  QQ机器人服务定时重启脚本(战地五ROBOT版) v9.3.1_Beta


REM 脚本配置
:: |设置ROBOT和QQ的存放路径|
set "ROBOT_Path_1=C:\Program Files\Catclient1"
set "ROBOT_Path_2=C:\Program Files\Catclient2"
set "ROBOT_Path_3=C:\Program Files\Catclient3"
set "ROBOT_Path_4=C:\Program Files\Catclient4"
set "ROBOT_Path_5=C:\Program Files\Catclient5"
set "QQ_Path=C:\Program Files\Tencent\QQNT"
:: |设置ROBOT和QQ的启动文件|
set "ROBOT_File_1=catclient1.exe"
set "ROBOT_File_2=catclient2.exe"
set "ROBOT_File_3=catclient3.exe"
set "ROBOT_File_4=catclient4.exe"
set "ROBOT_File_5=catclient5.exe"
set "QQ_File=QQ.exe"
:: |设置脚本的启动与结束时间范围(格式:HHMM)|
set "start_time=1200"
set "end_time=0200"
:: |设置QQ多长时间重启|
set Gap=6100


REM 选项页面
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
echo.     4. 指定次数范围内循环       (结束后不保留ROBOT程序)
echo. 
echo.     5. 二十四小时一直循环        (需手动结束ROBOT程序)
echo. 
echo.     6. 只启动[BFV ROBOT]         (需手动结束ROBOT程序)
echo. 
echo.     7. 浏览本项目在github仓库上的代码
echo. 
echo. =========================================================
choice /c 1234567 /n /M "请输入要执行的选项："
set "Figure=%errorlevel%"
if %errorlevel%==1 goto Time_to_Run
if %errorlevel%==2 goto Time_to_Run
if %errorlevel%==3 goto Loop_to_Run
if %errorlevel%==4 goto Loop_to_Run
if %errorlevel%==5 goto Run_5
if %errorlevel%==6 goto Run_6  
if %errorlevel%==7 goto Run_7 


REM 方案跳转分区:
:Time_to_Run
cls
call :Time
if !end_time_minutes! lss !start_time_minutes! (
    if !current_time_minutes! geq !start_time_minutes! ( goto Run_to_loop )
    if !current_time_minutes! lss !end_time_minutes! ( goto Run_to_loop )
) else (
    if !current_time_minutes! geq !start_time_minutes! if !current_time_minutes! lss !end_time_minutes! ( goto Run_to_loop )
)
echo 检查时间是否符合条件
timeout /t 1 >nul
goto Time_to_Run


REM 方案执行分区:

::  1.指定时间范围内循环
::  ===========================================================
:Run_to_loop
cls
call :Loop
goto Time_to_Run

::  3.指定次数循环
::  ===========================================================
:Loop_to_Run
cls
set /p count=请输入要循环的次数(必须为正整数)：
for /l %%i in (1,1,%count%) do (
    cls
    echo 第 %%i 次循环
    call :Loop
)
goto UI

::  5.二十四小时一直循环
::  ===========================================================
:Run_5
cls
call :Loop
goto Run_5

::  6.只启动[BFV ROBOT]
::  ===========================================================
:Run_6
cls
call :ROBOT
timeout /t 2
goto UI

::  7.浏览本项目在github仓库上的代码
::  ===========================================================
:Run_7
cls
start "" "https://github.com/Tian-Meng-Jun/Bat-Script"
timeout /t 2
goto UI

REM 功能模块:

::  获取当前时间和转换时间格式
::  ===========================================================
:Time
for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /value') do set datetime=%%I
set current_hour=!datetime:~8,2!
set current_minute=!datetime:~10,2!
set /a current_time_minutes=(!current_hour!*60)+!current_minute!
set /a start_time_minutes=(%start_time:~0,2%*60)+%start_time:~2,2%
set /a end_time_minutes=(%end_time:~0,2%*60)+%end_time:~2,2%
exit /b

::  方案循环模块
::  ===========================================================
:Loop
call :Kill
timeout /t 6
start "" /D "%QQ_Path%" /MIN "%QQ_File%"
timeout /t 10
call :ROBOT
timeout /t %Gap%
::  结束后保留ROBOT程序
::  ===========================================================
echo %Figure%|findstr "^1$ ^3$" >nul && taskkill /IM QQ.exe /F
::  结束后不保留ROBOT程序
::  ===========================================================
echo %Figure%|findstr "^2$ ^4$ ^5$" >nul && call :Kill
exit /b


::  ROBOT程序启动
::  ===========================================================
:ROBOT
::  ROBOT程序 1
if defined ROBOT_Path_1 (
    if defined ROBOT_File_1 (
        start "" /D "%ROBOT_Path_1%" /MIN "%ROBOT_File_1%"
    ) else (
        echo 错误：[ROBOT_File_1] 参数未设置，已跳过执行
    )
) else (
    echo 错误：[ROBOT_Path_1] 参数未设置，已跳过执行
)
::  ROBOT程序 2
if defined ROBOT_Path_2 (
    if defined ROBOT_File_2 (
        start "" /D "%ROBOT_Path_2%" /MIN "%ROBOT_File_2%"
    ) else (
        echo 错误：[ROBOT_File_2] 参数未设置，已跳过执行
    )
) else (
    echo 错误：[ROBOT_Path_2] 参数未设置，已跳过执行
)
::  ROBOT程序 3
if defined ROBOT_Path_3 (
    if defined ROBOT_File_3 (
        start "" /D "%ROBOT_Path_3%" /MIN "%ROBOT_File_3%"
    ) else (
        echo 错误：[ROBOT_File_3] 参数未设置，已跳过执行
    )
) else (
    echo 错误：[ROBOT_Path_3] 参数未设置，已跳过执行
)
::  ROBOT程序 4
if defined ROBOT_Path_4 (
    if defined ROBOT_File_4 (
        start "" /D "%ROBOT_Path_4%" /MIN "%ROBOT_File_4%"
    ) else (
        echo 错误：[ROBOT_File_4] 参数未设置，已跳过执行
    )
) else (
    echo 错误：[ROBOT_Path_4] 参数未设置，已跳过执行
)
::  ROBOT程序 5
if defined ROBOT_Path_5 (
    if defined ROBOT_File_5 (
        start "" /D "%ROBOT_Path_5%" /MIN "%ROBOT_File_5%"
    ) else (
        echo 错误：[ROBOT_File_5] 参数未设置，已跳过执行
    )
) else (
    echo 错误：[ROBOT_Path_5] 参数未设置，已跳过执行
)
cls
exit /b

::  结束ROBOT程序与QQ程序
::  ===========================================================
:Kill
taskkill /IM QQ.exe /F
if defined ROBOT_File_1 (
    taskkill /IM %ROBOT_File_1%
    ) else (
    echo 错误：[ROBOT_File_1] 参数未设置，已跳过执行
)
if defined ROBOT_File_2 (
    taskkill /IM %ROBOT_File_2%
    ) else (
    echo 错误：[ROBOT_File_2] 参数未设置，已跳过执行
)
if defined ROBOT_File_3 (
    taskkill /IM %ROBOT_File_3%
    ) else (
    echo 错误：[ROBOT_File_3] 参数未设置，已跳过执行
)
if defined ROBOT_File_4 (
    taskkill /IM %ROBOT_File_4%
    ) else (
    echo 错误：[ROBOT_File_4] 参数未设置，已跳过执行
)
if defined ROBOT_File_5 (
    taskkill /IM %ROBOT_File_5%
    ) else (
    echo 错误：[ROBOT_File_5] 参数未设置，已跳过执行
)
cls
exit /b