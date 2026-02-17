#!/bin/sh

## Enforce as needed, this is the happy path

### First database

echo "Initializing the main database ${EX04_WM_DB_NAME}"

__l_db_url="jdbc:wm:postgresql://db:5432;databaseName=${EX04_WM_DB_NAME}"
__l_components=${EX04_WM_DB_COMPONENTS:-all}

"${EX04_DBC_WM_HOME}"/common/db/bin/dbConfigurator.sh \
--action create \
--dbms pgsql \
--component "${__l_components}" \
--version latest \
--url "${__l_db_url}" \
--printActions \
--user "${EX04_WM_DB_USER_NAME}" \
--password "${EX04_WM_DB_USER_PASS}"

echo "Initializing the archive database ${EX04_WM_ARCHIVE_DB_NAME}"

__l_db_url="jdbc:wm:postgresql://db:5432;databaseName=${EX04_WM_ARCHIVE_DB_NAME}"
__l_arc_components="${EX04_WM_ARCHIVE_DB_COMPONENTS:-ActiveTransferArchive,ComponentTracker,TaskArchive}"

"${EX04_DBC_WM_HOME}"/common/db/bin/dbConfigurator.sh \
--action create \
--dbms pgsql \
--component "${__l_arc_components}" \
--version latest \
--url "${__l_db_url}" \
--printActions \
--user "${EX04_WM_ARCHIVE_DB_USER_NAME}" \
--password "${EX04_WM_ARCHIVE_DB_USER_PASS}"

unset __l_db_url __l_components __l_arc_components
