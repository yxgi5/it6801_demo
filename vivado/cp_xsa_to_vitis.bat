@echo off
cls

set source_file=%cd%\system_wrapper.xsa
::echo source_file=%source_file%
set destination_dir=%cd%\..\vitis\xsa\
::echo destination_dir=%destination_dir%

if not exist %source_file% (
    echo %source_file% is not exist!
    exit /b %ERRORLEVEL%
) else if not exist %destination_dir% (
    echo %destination_dir% is not exist!
    exit /b %ERRORLEVEL%
) else (
    echo copying %source_file% to %destination_dir%
    xcopy %source_file% %destination_dir% /f /y
)

rem Check whether the copy was successful
set err=%ERRORLEVEL%
IF %err%==1 goto :FAIL
goto :SUCCESS

:FAIL
echo faild,!!!!!!Check, please!!!!

:SUCCESS
echo successed!!

pause

