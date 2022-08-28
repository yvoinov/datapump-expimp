@Echo off

rem --------------------------------------------------------------------------
rem -- PROJECT_NAME: DP_ExpImp                                              --
rem -- RELEASE_VERSION: 1.0.0.5                                             --
rem -- RELEASE_STATUS: Release                                              --
rem --                                                                      --
rem -- PLATFORM_IDENTIFICATION: Windows                                     --
rem -- OS SHELL: cmd.exe                                                    --
rem --                                                                      --
rem -- IDENTIFICATION: exportdp.bat                                         --
rem -- DESCRIPTION: DataPump Export common internals script. Exports both   --
rem --              metadata and tables data.                               --
rem --                                                                      --
rem --                                                                      --
rem -- INTERNAL_FILE_VERSION: 0.0.0.5                                       --
rem --                                                                      --
rem -- COPYRIGHT: Yuri Voinov (C) 2004, 2008                                --
rem --                                                                      --
rem -- MODIFICATIONS:                                                       --
rem -- 07.09.2008 -System utilities variables added, Oracle binaries check  --
rem --             added, rewrite archivation block.                        --
rem -- 08.05.2006 -ORACLE_HOME environment variable check added.            --
rem -- 28.01.2005 -Initial code written.                                    --
rem --------------------------------------------------------------------------

rem NLS Setting
set NLS_SETTING=RUSSIAN_CIS.CL8MSWIN1251

rem Check ORACLE_HOME environment variable
if not "%ORACLE_HOME%" == "" goto ora_home_set
echo ERROR: ORACLE_HOME environment variable not set!
echo Exiting ...
exit 1

:ora_home_set

rem Set NLS_LANG if it not set before
if not defined "%NLS_LANG%" set NLS_LANG=%NLS_SETTING%

rem Check sqlplus binary and run command
if exist "%ORACLE_HOME%\bin\sqlplus.exe" goto run
echo ERROR: Oracle executables not found!
echo Exiting ...
exit 1

:run
%ORACLE_HOME%\bin\sqlplus /nolog @exportdp.sql

rem Get export owner name from file
set owner_name=%owner_name%
for /f "tokens=*" %%a in (exportdp.txt) do set owner_name=%owner_name%%%a

rem Now remove temporary file for UNIX version
if exist exportdp.txt del /q exportdp.txt

%ORACLE_HOME%\bin\zip -9 %owner_name%_ddp.zip %owner_name%.ddp %owner_name%.log exportdp.* importdp.*
del /q %owner_name%.ddp
del /q %owner_name%.log

exit 0
