@echo off
setlocal enabledelayedexpansion
TITLE  �������ʱ�����ű�

REM �����·���������ļ�������ʱ������
set "Browser-1_Path=C:\Program Files\Google\Chrome"
set "Browser-1_File=chrome.exe"
set "Browser-1_Gap=20000"
set "Browser-2_Path=C:\Program Files\Twinkstar Browser"
set "Browser-2_File=twinkstar.exe"
set "Browser-2_Gap=20000"
REM ����ʱ��ͽ���ʱ������
set start_time=1030
set end_time=1630


REM ��ѭ��
:loop
cls
REM ��ȡ��ǰʱ��
for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /value') do set datetime=%%I
set current_hour=!datetime:~8,2!
set current_minute=!datetime:~10,2!
REM ����ǰʱ��ת��Ϊ�������Ա�Ƚ�
set /a current_time_minutes=(!current_hour!*60)+!current_minute!
set /a start_time_minutes=(%start_time:~0,2%*60)+%start_time:~2,2%
set /a end_time_minutes=(%end_time:~0,2%*60)+%end_time:~2,2%
REM ֧�ֿ���ҹ�����
if !end_time_minutes! lss !start_time_minutes! (
    if !current_time_minutes! geq !start_time_minutes! ( goto Run )
    if !current_time_minutes! lss !end_time_minutes! ( goto Run )
) else (
    if !current_time_minutes! geq !start_time_minutes! if !current_time_minutes! lss !end_time_minutes! ( goto Run )
)
REM �������ʱ����ڣ��ȴ�1���Ӻ��ټ��һ��
echo ���ʱ���Ƿ��������
timeout /t 1 >nul
goto loop

REM ��������õ�ʱ����ڣ�������г����ָ��
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