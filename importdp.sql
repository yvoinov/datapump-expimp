rem --------------------------------------------------------------------------
rem -- PROJECT_NAME: DP_ExpImp                                              --
rem -- RELEASE_VERSION: 1.0.0.5                                             --
rem -- RELEASE_STATUS: Release                                              --
rem --                                                                      --
rem -- REQUIRED_ORACLE_VERSION: 10.2.0.x                                    --
rem -- MINIMUM_ORACLE_VERSION: 10.1.x.x                                     --
rem -- MAXIMUM_ORACLE_VERSION: 11.x.x.x                                     --
rem -- PLATFORM_IDENTIFICATION: UNIX                                        --
rem --                                                                      --
rem -- IDENTIFICATION: importdp.sql                                         --
rem -- DESCRIPTION: Calling DataPump import script. Must be run as schema   --
rem --              owner.                                                  --
rem --                                                                      --
rem --                                                                      --
rem -- INTERNAL_FILE_VERSION: 0.0.0.5                                       --
rem --                                                                      --
rem -- COPYRIGHT: Yuri Voinov (C) 2004, 2008                                --
rem --                                                                      --
rem -- MODIFICATIONS:                                                       --
rem -- 28.10.2005 -Parallel degree subst var added, datapump content var    --
rem --             added.                                                   --
rem -- 21.10.2005 -Initial code written.                                    --
rem --------------------------------------------------------------------------

set verify off

prompt -------------------------------------

prompt DataPump import common script.
prompt Imports data in specified mode.

prompt -------------------------------------

prompt Specify schema owner password, SYS password,
prompt export mode (ALL,METADATA_ONLY,DATA_ONLY), parallel degree
prompt and directory import from (example: /export/home)
prompt 

spool importdp.log

ACCEPT exp_dp_dir CHAR -
PROMPT 'Input export directory: '
ACCEPT exp_mode CHAR DEFAULT 'ALL' -
PROMPT 'Input export mode (all,metadata_only,data_only), default ALL: '
ACCEPT par_degree CHAR DEFAULT '4' -
PROMPT 'Input parallel degree for operation, default 4: '
ACCEPT schema_owner CHAR -
PROMPT 'Input schema owner: '
ACCEPT own_pwd CHAR -
PROMPT 'Input schema owner password: ' HIDE
ACCEPT sys_pwd CHAR -
PROMPT 'Input SYS password: ' HIDE

prompt -------------------------------------

prompt Starting ...

prompt -------------------------------------

connect sys/&&sys_pwd as sysdba

set echo on

create directory data_pump_dir1 as '&&exp_dp_dir';

grant read on directory data_pump_dir1 to &&schema_owner;
grant write on directory data_pump_dir1 to &&schema_owner;

set echo off
prompt Unarchiving...
host unzip "&&schema_owner"_ddp.zip "&&schema_owner".ddp
prompt Unarchiving finished.

set echo on

host impdp &&schema_owner/&&own_pwd directory=data_pump_dir1 dumpfile="&&schema_owner".ddp logfile="&&schema_owner".log content=&&exp_mode parallel=&&par_degree table_exists_action=replace

set echo off
prompt Clean up ...
column del_clean_cmd new_value del_cmd
select decode(substr(dbms_utility.port_string,instr(dbms_utility.port_string,'WIN'),3),
       'WIN','del /q "&&schema_owner".ddp "&&schema_owner".log',
       'rm -f "&&schema_owner".ddp "&&schema_owner".log') del_clean_cmd
from dual;
host &del_cmd
prompt Clean up finished. 
host echo Complete dump "&&schema_owner".ddp still in file "&&schema_owner"_ddp.zip

set echo on

drop directory data_pump_dir1;

set echo off

prompt -------------------------------------

prompt Finished.

prompt -------------------------------------

spool off

exit
