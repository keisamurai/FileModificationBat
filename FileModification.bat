@echo off
rem #===========================
rem #name:FIleModification.bat
rem #===========================

rem ----Valable Definition in Common-----
set LOGFILE=.\log\log.txt
set PCLIST=.\PCList.txt
rem -----------------------------------

rem make folders
cd %~dp0
mkdir .\backup
mkdir .\log

rem check PCList.txt existance
if not exist %PCLIST% (
    echo [ERROR] : no %PCLIST% !! 2>&1
    goto END
)

rem --------START_Main---------
setlocal enabledelayedexpansion
for /f "delims=" %%a in (%PCLIST%) do (
    rem ----Valable Definition in Main-----
    set PCNAME=%%a
    rem FOLDERPATH
    set FOLDERPATH=C:\temp
    set FILENAME=test.txt
    set FILEPATH=!FOLDERPATH!\!FILENAME!
    rem -----------------------------------
    
    call :00_START_LOG
    call :01_CHECK_FILE_BEFORE
    call :02_BACKUP_FILE
    call :03_REPLACE_STRING
    call :04_CHECK_FILE_AFTER
    call :05_END_LOG
)
endlocal
exit /b
rem --------END_Main-----------


rem --------SUB ROUTINS-------------
:00_START_LOG
echo ----------LOGGING_START------------ >> %LOGFILE%
echo [PCNAME]:%PCNAME% >> %LOGFILE%
exit /b


:01_CHECK_FILE_BEFORE
if exist %FILEPATH% (
    echo [SUCCESS] : FILE exists >> %LOGFILE%
) else (
    echo [ERROR] : %errorlevel% FILE doesnot exists >> %LOGFILE%
    echo           FILEPATH=%FILEPATH% >> %LOGFILE%
    goto END
)
exit /b


:02_BACKUP_FILE
move %FILEPATH% .\backup\%FILENAME%_%PCNAME%
if not %errorlevel%==0 (
    echo [ERROR] : %errorlevel%  %FILENAME%_%PCNAME% couldn't be backuped >> %LOGFILE%
    goto END
) else (
    echo [SUCCESS] : FILE is successfully backuped >> %LOGFILE%
)
exit /b


:03_REPLACE_STRING
rem based by http://jj-blues.com/cms/wantto-replacestring/
setlocal enabledelayedexpansion
for /f "delims=" %%a in (.\backup\%FILENAME%_%PCNAME%) do (
    set LINE=%%a
    set LINE=!LINE:m01hvyf1=M01HVYF1!
    echo !LINE! >> %FILEPATH%
    if not %errorlevel%==0 (
        echo [ERROR] : %errorlevel% New File fails to write down >> %LOGFILE%
    ) else (
        echo [SUCCESS] : New File successfully wirte down >> %LOGFILE%
        goto END
    )
)
endlocal
exit /b


:04_CHECK_FILE_AFTER
if exist %FILEPATH% (
    echo [SUCCESS] : New File is successfully deployed >> %LOGFILE%
) else (
    echo [ERROR] : %errorlevel%  New File fails to be deployed >> %LOGFILE%
    goto END
)
exit /b


:05_END_LOG
echo ----------LOGGING_END-------------- >> %LOGFILE%
exit /b

:END
exit /b
rem --------------------------------