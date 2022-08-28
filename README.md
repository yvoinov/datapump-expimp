# DataPump export/import scripts

* DataPump Export/Import common scripts. Exports both metadata and tables data.

Scripts for export/import of arbitrary scheme in DataPump mode.

They are used for backup and recovery purposes (logical backups), as well as for system migration and for the transit of schemes from development to production and vice versa.

When exported, the dump is archived with the inclusion of these scripts in a zip archive with the template name <schema_owner>_ddp.zip.

This version is dual scripts for Windows and UNIX. The Windows version uses the zip/unzip utilities provided with the RDBMS.
___
ATTENTION! When importing metadata, if objects exist, they are NOT re-created, except for tables (see note below).

Creating and deleting directories is done with SYS rights.
___
The default degree of parallelism is 4.

Note: This is a special version, with the option to recreate tables and reload them with data if they exist.