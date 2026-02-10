#!/bin/sh

# shellcheck disable=SC2153

## Enforce as needed, this is the happy path

### First database

### Issue to check: seems that DBC does not recognize multi-tenant
### oracle Databases in terms of user and tablespaces creation.
### Resolve this point by other means, in our example see the
### database initialization scripts in scripts/ora/scripts

# __tblsp_dir="${EX02_ORACLE_DATA_MOUNT_POINT}"

# echo "=======ENTRYPOINT============= Initializing the main database storage on service ${ORACLE_CDB} for user ${EX02_WM_DB_USER_NAME}..."

#   __l_db_url="jdbc:wm:oracle://db:1521;serviceName=${ORACLE_CDB};sysLoginRole=sysdba"

#   "${EX02_DBC_WM_HOME}"/common/db/bin/dbConfigurator.sh \
#   --action create \
#   --dbms oracle \
#   --component storage \
#   --tablespacefordata WEBMDATA \
#   --tablespaceforindex WEBMINDX \
#   --tablespaceforblob WEBMBLOB \
#   --tablespacedir "${__tblsp_dir}" \
#   --version latest \
#   --url "${__l_db_url}" \
#   --printActions \
#   --admin_user system \
#   --admin_password "${ORACLE_PWD}" \
#   --user "${EX02_WM_DB_USER_NAME}" \
#   --password "${EX02_WM_DB_USER_PASS}"


echo "=======ENTRYPOINT============= Initializing the main schema ${EX02_WM_DB_NAME}..."
  __l_db_url="jdbc:wm:oracle://db:1521;serviceName=${ORACLE_CDB}"
  __l_components=${EX02_WM_DB_COMPONENTS:-all}

  "${EX02_DBC_WM_HOME}"/common/db/bin/dbConfigurator.sh \
  --action create \
  --dbms oracle \
  --component "${__l_components}" \
  --version latest \
  --url "${__l_db_url}" \
  --printActions \
  --tablespacefordata WEBMDATA \
  --tablespaceforindex WEBMINDX \
  --tablespaceforblob WEBMBLOB \
  --user "${EX02_WM_DB_USER_NAME}" \
  --password "${EX02_WM_DB_USER_PASS}"

# echo "=======ENTRYPOINT============= Initializing the archiving database storage on service ${ORACLE_CDB} having user ${EX02_WM_ARCHIVE_DB_USER_NAME}..."
  # __l_db_url="jdbc:wm:oracle://db:1521;serviceName=${ORACLE_CDB};sysLoginRole=sysdba"

  # "${EX02_DBC_WM_HOME}"/common/db/bin/dbConfigurator.sh \
  # --action create \
  # --dbms oracle \
  # --component storage,DataPurge \
  # --tablespacefordata WEBMARCDATA \
  # --tablespaceforindex WEBMARCINDX \
  # --tablespaceforblob WEBMARCBLOB \
  # --tablespacedir "${__tblsp_dir}" \
  # --version latest \
  # --url "${__l_db_url}" \
  # --printActions \
  # --admin_user sys \
  # --admin_password "${ORACLE_PWD}" \
  # --user "${EX02_WM_ARCHIVE_DB_USER_NAME}" \
  # --password "${EX02_WM_ARCHIVE_DB_USER_PASS}"

echo "=======ENTRYPOINT============= Initializing the archive schema ${EX02_WM_ARCHIVE_DB_NAME}..."
  __l_db_url="jdbc:wm:oracle://db:1521;serviceName=${ORACLE_CDB}"
  __l_arc_components="${EX02_WM_ARCHIVE_DB_COMPONENTS:-ActiveTransferArchive,Archive,ComponentTracker,TaskArchive,TradingNetworksArchive}"

  "${EX02_DBC_WM_HOME}"/common/db/bin/dbConfigurator.sh \
  --action create \
  --dbms oracle \
  --component ${__l_arc_components} \
  --version latest \
  --url "${__l_db_url}" \
  --tablespacefordata WEBMARCDATA \
  --tablespaceforindex WEBMARCINDX \
  --tablespaceforblob WEBMARCBLOB \
  --printActions \
  --user "${EX02_WM_ARCHIVE_DB_USER_NAME}" \
  --password "${EX02_WM_ARCHIVE_DB_USER_PASS}"

unset __l_db_url __l_components __l_arc_components
