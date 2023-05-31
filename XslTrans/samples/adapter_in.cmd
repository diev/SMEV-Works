@echo off
rem Edition 2023-05-31

rem echo %date%
rem 31.05.2023
set YYYY=%DATE:~-4%
set MM=%DATE:~-7,2%
set DD=%DATE:~-10,2%

rem Set path to files
set files=C:\SmevAdapter\integration\files\123456

rem Set path to output
set out=%files%\out
md %out%

rem Set path to Archive
set tag=%YYYY%-%MM%-%DD%
set arc=%files%\arc\%tag%
md %arc%

rem Set path for unknown
set unknown=%files%\unknown\%tag%
md %unknown%

for %%f in (%files%\in\*) do call :switch %%f
goto :eof

rem ----------------------------------------------
:switch
echo %1
find ":UVSMERTFLRequest" %1>nul
if %errorlevel%==0 goto 313-19

rem Add below other incoming requests

rem find ":OtherRequest" %1>nul
rem if %errorlevel%==0 goto other

goto unknown

rem ----------------------------------------------
:313-19
rem Set path to Archive and a new name
set a=%arc%\%tag%-313-19-

rem Put the source file to Archive
copy %1 %a%%~nx1

rem Make reply file in Archive and put it to output
XslTrans\XslTrans %1 XslTrans\XSLT\313-19a.xslt %a%%~n1.reply.xml
copy %arc%%~n1.reply.xml %out%

rem Make a printable report and send it to subscribers
XslTrans\XslTrans %1 XslTrans\XSLT\313-19p.xslt %a%%~n1.html
mailer - "New SMEV:313-19 Report" *%a%%~n1.txt %a%%~n1.html

rem Make a data text and send it to ABS
XslTrans\XslTrans %1 XslTrans\XSLT\313-19t.xslt %a%%~n1.txt
mailer - "New SMEV:313-19 DATA" "Load it to ABS" %a%%~n1.txt

rem Done, delete the source file
if exist %a%%~nx1 del %1
goto :eof

rem ----------------------------------------------
:unknown
rem Set path to Archive and a new name
set a=%unknown%\%tag%-unknown-

rem Put the source file to Archive
copy %1 %a%%~nx1

rem Send it to our IT Lab
mailer - "New SMEV:UNKNOWN Request" "Unknown %a%%~nx1" %a%%~nx1

rem Done, delete the source file
if exist %a%%~nx1 del %1
goto :eof
