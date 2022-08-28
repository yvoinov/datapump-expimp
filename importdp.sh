#!/bin/sh

# --------------------------------------------------------------------------
# -- PROJECT_NAME: DP_ExpImp                                              --
# -- RELEASE_VERSION: 1.0.0.5                                             --
# -- RELEASE_STATUS: Release                                              --
# --                                                                      --
# -- PLATFORM_IDENTIFICATION: UNIX                                        --
# -- OS SHELL: Borne                                                      --
# --                                                                      --
# -- IDENTIFICATION: importdp.sh                                          --
# -- DESCRIPTION: DataPump Import common internals script. Imports both   --
# --              metadata and tables data.                               --
# --                                                                      --
# --                                                                      --
# -- INTERNAL_FILE_VERSION: 0.0.0.5                                       --
# --                                                                      --
# -- COPYRIGHT: Yuri Voinov (C) 2004, 2008                                --
# --                                                                      --
# -- MODIFICATIONS:                                                       --
# -- 07.09.2008 -System utilities variables added, Oracle binaries check  --
# --             added.                                                   --
# -- 08.05.2006 -ORACLE_HOME environment variable check added.            --
# -- 28.10.2005 - Error with incorrect sql script call fixed.             --
# -- 28.01.2005 -Initial code written.                                    --
# --------------------------------------------------------------------------

# System utilities
ECHO=`which echo`

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
 $ORACLE_HOME/bin/sqlplus /nolog @importdp.sql
else
 $ECHO "ERROR: Oracle executables not found!"
 $ECHO "Exiting ..."
 exit 1
fi

exit 0
