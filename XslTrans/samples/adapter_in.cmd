@echo off
rem Edition 2025-05-14

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

find "MNSV03" %1>nul
if %errorlevel%==0 goto persons-list-to-ko

find "MNSV188" %1>nul
if %errorlevel%==0 goto persons-list-to-ko

find ":NALFLPROCRequest" %1>nul
if %errorlevel%==0 goto 310-71

find ":UVSMERTFLRequest" %1>nul
if %errorlevel%==0 goto 313-19

rem Add below other incoming requests

rem find ":OtherRequest" %1>nul
rem if %errorlevel%==0 goto other

find "ErrorMessage" %1>nul
if %errorlevel%==0 goto error

goto unknown

rem ----------------------------------------------
:persons-list-to-ko
rem Set path to Archive and a new name
set a=%arc%\%tag%-persons-list-to-ko-

rem Put the source file to Archive
copy %1 %a%%~nx1
rem Delete if success
if exist %a%%~nx1 del %1

rem Put result files in Archive
rem Make a response file for sending back
XslTrans\XslTrans %a%%~nx1 XslTrans\XSLT\persons-list-to-ko.xslt %a%%~n1.reply.xml
rem Make a printable report for subscribers
rem XslTrans\XslTrans %a%%~nx1 XslTrans\XSLT\persons-list-to-ko-t.xslt %a%%~n1.txt

rem Do actions with result files from Archive
rem Put the response file to send
copy %a%%~n1.reply.xml %out%
rem Send the printable report to subscribers
mailer - "New SMEV:persons-list-to-ko" SUCCEEDED
goto :eof

rem ----------------------------------------------
:310-71
rem Set path to Archive and a new name
set a=%arc%\%tag%-310-71-

rem Put the source file to Archive
copy %1 %a%%~nx1
rem Delete if success
if exist %a%%~nx1 del %1

rem Put result files in Archive
rem Make a response file for sending back
XslTrans\XslTrans %a%%~nx1 XslTrans\XSLT\310-71x.xslt %a%%~n1.reply.xml
rem Make a printable report for subscribers
XslTrans\XslTrans %a%%~nx1 XslTrans\XSLT\310-71t.xslt %a%%~n1.txt

rem Do actions with result files from Archive
rem Put the response file to send
copy %a%%~n1.reply.xml %out%
rem Send the printable report to subscribers
mailer - "New SMEV:310-71" =%a%%~n1.txt %a%%~n1.txt
goto :eof

rem ----------------------------------------------
:313-19
rem Set path to Archive and a new name
set a=%arc%\%tag%-313-19-

rem Put the source file to Archive
copy %1 %a%%~nx1
rem Delete if success
if exist %a%%~nx1 del %1

rem Put result files in Archive
rem Make a response file for sending back
XslTrans\XslTrans %a%%~nx1 XslTrans\XSLT\313-19x.xslt %a%%~n1.reply.xml
rem Make a printable report for subscribers
XslTrans\XslTrans %a%%~nx1 XslTrans\XSLT\313-19h.xslt %a%%~n1.html
rem Make a data text for ABS
XslTrans\XslTrans %a%%~nx1 XslTrans\XSLT\313-19t.xslt %a%%~n1.txt

rem Do actions with result files from Archive
rem Put the response file to send
copy %a%%~n1.reply.xml %out%
rem Send the printable report to subscribers
rem mailer - "New SMEV:313-19 Report for Clients Dept" =%a%%~n1.txt %a%%~n1.html
rem Send the data text to ABS
mailer - "New SMEV:313-19" =%a%%~n1.txt %a%%~n1.txt
goto :eof

rem ----------------------------------------------
:error
rem Set path to Archive and a new name
set a=%unknown%\%tag%-error-

rem Put the source file to Archive
copy %1 %a%%~nx1
rem Delete if success
if exist %a%%~nx1 del %1

rem Send it to our IT Lab
mailer - "New SMEV:ERROR" *%a%%~nx1 %a%%~nx1
goto :eof

rem ----------------------------------------------
:unknown
rem Set path to Archive and a new name
set a=%unknown%\%tag%-unknown-

rem Put the source file to Archive
copy %1 %a%%~nx1
rem Delete if success
if exist %a%%~nx1 del %1

rem Send it to our IT Lab
mailer - "New SMEV:UNKNOWN" *%a%%~nx1 %a%%~nx1
goto :eof
