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
rem -- IDENTIFICATION: exportdp.sql                                         --
rem -- DESCRIPTION: Calling DataPump export script. Must be run as schema   --
rem --              owner.                                                  --
rem --                                                                      --
rem --                                                                      --
rem -- INTERNAL_FILE_VERSION: 0.0.0.5                                       --
rem --                                                                      --
rem -- COPYRIGHT: Yuri Voinov (C) 2004, 2008                                --
rem --                                                                      --
rem -- MODIFICATIONS:                                                       --
rem -- 07.09.2008 -Add PL/SQL block to put owner name to OS archive block.  --
rem -- 28.10.2005 -Parallel degree subst var added, datapump content var    --
rem --             added.                                                   --
rem -- 21.10.2005 -Initial code written.                                    --
rem --------------------------------------------------------------------------

set verify off

prompt -------------------------------------

prompt DataPump export common script.
prompt Exports data in specified mode.

prompt -------------------------------------

prompt Specify schema owner password, SYS password
prompt export mode (ALL,METADATA_ONLY,DATA_ONLY), parallel degree
prompt and directory to export (example: /export/home)
prompt 

spool exportdp.log

accept exp_dp_dir char -
prompt 'Input export directory: '
accept exp_mode char default 'ALL' -
prompt 'Input export mode (all,metadata_only,data_only), default ALL: '
accept par_degree char default '4' -
prompt 'Input parallel degree for operation, default 4: '
accept schema_owner char -
prompt 'Input schema owner: '
accept own_pwd char -
prompt 'Input schema owner password: ' hide
accept sys_pwd char -
prompt 'Input SYS password: ' hide

prompt -------------------------------------

prompt Starting ...

prompt -------------------------------------

connect sys/&&sys_pwd as sysdba

set echo on

create directory data_pump_dir1 as '&&exp_dp_dir';

grant read on directory data_pump_dir1 to &&schema_owner;
grant write on directory data_pump_dir1 to &&schema_owner;

host expdp &&schema_owner/&&own_pwd directory=data_pump_dir1 dumpfile="&&schema_owner".ddp logfile="&&schema_owner".log content=&&exp_mode parallel=&&par_degree estimate=statistics

set echo off

declare
 v_file utl_file.file_type;
 v_owner varchar2(50) := '&&schema_owner';
begin
 -- Put schema owner name to text file for archiving
 begin
  v_file := utl_file.fopen('DATA_PUMP_DIR1','exportdp.txt','w',1024);
 exception
  when utl_file.invalid_path then
   raise_application_error(-20220, 'Path your specified not found or permission denied.');
  when utl_file.invalid_filehandle then
   raise_application_error (-20221, 'File handle is invalid.');
  when others then
   raise_application_error (-20223, 'Unknown OS error.');
 end;

 utl_file.put_line(v_file, v_owner, true);
 utl_file.fclose(v_file);

exception
 when utl_file.write_error then
  raise_application_error (-20222, 'Write error. Path not found or permission denied.');
end;
/

set echo on

drop directory data_pump_dir1;

set echo off

prompt -------------------------------------

prompt Finished.

prompt -------------------------------------

spool off

exit
