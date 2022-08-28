#!/bin/sh

# --------------------------------------------------------------------------
# -- PROJECT_NAME: DP_ExpImp                                              --
# -- RELEASE_VERSION: 1.0.0.5                                             --
# -- RELEASE_STATUS: Release                                              --
# --                                                                      --
# -- PLATFORM_IDENTIFICATION: UNIX                                        --
# -- OS SHELL: Borne                                                      --
# --                                                                      --
# -- IDENTIFICATION: exportdp.sh                                          --
# -- DESCRIPTION: DataPump Export common internals script. Exports both   --
# --              metadata and tables data.                               --
# --                                                                      --
# --                                                                      --
# -- INTERNAL_FILE_VERSION: 0.0.0.5                                       --
# --                                                                      --
# -- COPYRIGHT: Yuri Voinov (C) 2004, 2008                                --
# --                                                                      --
# -- MODIFICATIONS:                                                       --
# -- 07.09.2008 -System utilities variables added, Oracle binaries check  --
# --             added, rewrite archivation block.                        --
# -- 08.05.2006 -ORACLE_HOME environment variable check added.            --
# -- 28.01.2005 -Initial code written.                                    --
# --------------------------------------------------------------------------

# System utilities 
ECHO=`which echo`
RM=`which rm`
ZIP=`which zip`

# NLS Setting
NLS_SETTING="RUSSIAN_CIS.CL8MSWIN1251"

# Check ORACLE_HOME environment variable
if [ -z "$ORACLE_HOME" ]; then
 $ECHO "ERROR: ORACLE_HOME environment variable not set!"
 $ECHO "Exiting ..."
 exit 1
fi

# Set NLS_LANG if it not set before
if [ -z "NLS_LANG" -o "NLS_LANG" != $NLS_SETTING ]; then
 NLS_LANG=$NLS_SETTING
 export NLS_LANG
fi

# Check sqlplus binary and run command
if [ -x "$ORACLE_HOME/bin/sqlplus" ]; then
 $ORACLE_HOME/bin/sqlplus /nolog @exportdp.sql
else
 $ECHO "ERROR: Oracle executables not found!"
 $ECHO "Exiting ..."
 exit 1
fi

# Get export owner name from file
owner_name="`cat exportdp.txt`"

# Now remove temporary file
if [ -f "exportdp.txt" ]; then
 $RM -f exportdp.txt
fi

# Archiving export dump file
$ECHO "Archiving..."

$ZIP -9 "$owner_name"_ddp.zip "$owner_name".ddp "$owner_name".log exportdp.* importdp.*
$RM -f "$owner_name".ddp
$RM -f "$owner_name".log

$ECHO "Archiving finished in file ""$owner_name""_ddp.zip"

exit 0
