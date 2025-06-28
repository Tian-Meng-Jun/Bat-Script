@echo off
setlocal enabledelayedexpansion
:loop
cls
REM 傻逼QQ版本文件更新目录
set "QQ_Path=P:\11111111111111\versions"
REM 傻逼QQ要保留的版本文件夹名
set "QQ_version=9.9.19-34362"
cd /d "%QQ_Path%"
REM 删除傻逼QQ的更新包文件
for %%F in (*) do (
    set "keep=0"
    if /i "%%F"=="channel.json" set "keep=1"
    if /i "%%F"=="config.json" set "keep=1"
    if /i "%%F"=="setting.json" set "keep=1"
    if "!keep!"=="0" (
        echo 正在删除文件: %%F
        del /f /q "%%F"
    )
)
REM 删除傻逼QQ解压了的更新包文件夹
for /d %%D in (*) do (
    set "keep=0"
    if /i "%%D"=="%QQ_version%" set "keep=1"
    if "!keep!"=="0" (
        echo 正在删除文件夹: %%D
        rmdir /s /q "%%D"
    )
)
REM 间隔多少秒后再删除一次
timeout /t 1800 
goto loop
