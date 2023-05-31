@echo off
rem Solution for .NET Framework 4.8
rem call $(SolutionDir)PostBuild.bat

setlocal
set pack="C:\Program Files\7-Zip\7z.exe" a
set outdir=bin\Release
rem echo %date%
rem 31.05.2023
set ymd=%date:~-4%-%date:~3,2%-%date:~0,2%
set home=%~dp0

for /d %%i in (%home%*) do call :proj %%i

endlocal
goto :eof

:proj
set proj=%1

set bin="%proj%_%ymd%.zip"
set src="%proj%_%ymd%_sources.zip"

echo Clean old packs
if exist %bin% del %bin%
if exist %src% del %src%

echo Build samples
pushd %proj%\%outdir%\samples
call samples.bat
popd

echo Pack binaries
pushd %proj%\%outdir%
%pack% %bin% -x!*.pdb
popd

echo Pack sources
pushd %home%
for %%i in (.) do set repo=%%~nxi

echo Copyright (c) %date:~-4% Dmitrii Evdokimov>author.txt
echo Source https://github.com/diev/%repo%>>author.txt

%pack% %bin% author.txt *.md
%pack% %src% author.txt *.md LICENSE *.sln packages
%pack% %src% %proj% -xr!bin -xr!obj -xr!*.user
del author.txt
goto :eof
