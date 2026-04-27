ARG __from_img=ibmwebmethods.azurecr.io/webmethods-activetransfer:11.1.0.4
FROM ibmwebmethods.azurecr.io/webmethods-activetransfer:11.1.0.0 as at-zero
FROM ${__from_img}

# For local laboratories we :
# - use a different user id
# - mount the logs folder as a volume
# - already declare a default volume for virtual file system based on local folder

ARG __new_user_id=1001
ARG __new_user_id=1001
ARG __img_user_name=sagadmin
# It seems MFT comes with group root
# ARG __img_grp_name=sagadmin

ARG __at_logs_folder=/opt/softwareag/IntegrationServer/logs
ARG __at_vfs_folder=/mnt/our/vfs

USER root

## Work around bug MAT-25094 - to remove when fixed
COPY --from=at-zero \
  /opt/softwareag/IntegrationServer/instances/default/packages/WmCDS/pub/assets/i18n/cds/en.json \
  /opt/softwareag/IntegrationServer/instances/default/packages/WmCDS/pub/assets/i18n/cds/en.json

RUN mkdir -p \
      "${__at_vfs_folder}" \
      "${__at_logs_folder}" \
    && usermod -u ${__new_user_id} ${__img_user_name} \
    && chown -R ${__new_user_id}:0 \
      "${__at_vfs_folder}" \
      "${__at_logs_folder}" \
      /opt/softwareag

USER sagadmin

VOLUME \
    "${__at_vfs_folder}" \
    "${__at_logs_folder}"
