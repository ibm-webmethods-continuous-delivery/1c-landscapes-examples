ARG __from_img=ibmwebmethods.azurecr.io/webmethods-activetransfer-dcc:11.1.0.4
FROM ${__from_img}

# For local laboratories we :
# - use a different user id
# - mount a custom scripts folder
# - mount the logs folder as a volume

ARG __new_user_id=1001
ARG __new_grp_id=1001
ARG __img_user_name=sagadmin
ARG __img_grp_name=sagadmin

ARG __custom_scripts_volume=/mnt/our/scripts
ARG __dcc_logs_folder=/opt/softwareag/common/db/logs

USER root

RUN mkdir -p \
      "${__custom_scripts_volume}" \
      "${__dcc_logs_folder}" \
    && usermod -u ${__new_user_id} "${__img_user_name}" \
    && groupmod -g ${__new_grp_id} ${__img_grp_name} \
    && chown -R ${__new_user_id}:${__new_grp_id} \
      "${__custom_scripts_volume}" \
      "${__dcc_logs_folder}" \
      /opt/softwareag

USER sagadmin

VOLUME \
  "${__custom_scripts_volume}" \
  "${__dcc_logs_folder}"
