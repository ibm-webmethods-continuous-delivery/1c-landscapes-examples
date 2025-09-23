ARG __base_py_image=python:3.13-slim-bookworm
FROM ${__base_py_image}

RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get -qy update \
    && apt-get -qy install --no-install-recommends \
        curl \
        git \
    && curl https://get.trunk.io -fsSL | bash -s -- -y

ARG __gid=1000
ARG __gname=vscode
ARG __uid=1000
ARG __uname=vscode
ARG __uhome=/home/${__uname}
ARG __workspace_folder=/workspace

RUN groupadd -g ${__gid} ${__gname} \
    && useradd -rm -d ${__uhome} -s /bin/bash -g ${__gid} -u ${__uid} ${__uname} \
    && mkdir -p ${__workspace_folder} \
    && chown ${__uname}:${__gname} ${__workspace_folder} \
    && chown -R ${__uname}:${__gname} /usr/local/bin
