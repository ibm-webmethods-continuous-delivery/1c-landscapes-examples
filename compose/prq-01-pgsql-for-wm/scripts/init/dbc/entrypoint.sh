#!/bin/sh

## Enforce as needed, this is the happy path

### First database

echo "Initializing the main database ${EX01_WM_DB_NAME}"

__l_db_url="jdbc:wm:postgresql://db:5432;databaseName=${EX01_WM_DB_NAME}"
__l_components=${EX01_WM_DB_COMPONENTS:-all}

"${EX01_DBC_WM_HOME}"/common/db/bin/dbConfigurator.sh \
--action create \
--dbms pgsql \
--component "${__l_components}" \
--version latest \
--url "${__l_db_url}" \
--printActions \
--user "${EX01_WM_DB_USER_NAME}" \
--password "${EX01_WM_DB_USER_PASS}"

echo "Initializing the archive database ${EX01_WM_ARCHIVE_DB_NAME}"

__l_db_url="jdbc:wm:postgresql://db:5432;databaseName=${EX01_WM_ARCHIVE_DB_NAME}"
__l_arc_components="${EX01_WM_ARCHIVE_DB_COMPONENTS:-ActiveTransferArchive,Archive,ComponentTracker,DataPurge,TaskArchive,TradingNetworksArchive}"

"${EX01_DBC_WM_HOME}"/common/db/bin/dbConfigurator.sh \
--action create \
--dbms pgsql \
--component "${__l_arc_components}" \
--version latest \
--url "${__l_db_url}" \
--printActions \
--user "${EX01_WM_ARCHIVE_DB_USER_NAME}" \
--password "${EX01_WM_ARCHIVE_DB_USER_PASS}"

unset __l_db_url __l_components __l_arc_components
