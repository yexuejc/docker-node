ARG BASE_TAG="develop"
ARG BASE_IMAGE="core-ubuntu-focal"
FROM kasmweb/$BASE_IMAGE:$BASE_TAG

USER root
#中文
ARG LANG='zh_CN.UTF-8'
ARG LANGUAGE='zh_CN:zh'
ARG LC_ALL='zh_CN.UTF-8'

ENV LANG=$LANG \
    LANGUAGE=$LANGUAGE \
    LC_ALL=$LC_ALL \
    HOME=/home/kasm-default-profile \
    STARTUPDIR=/dockerstartup \
    USER_PWD="password"

WORKDIR $HOME

### Envrionment config
ENV DEBIAN_FRONTEND noninteractive
ENV KASM_RX_HOME $STARTUPDIR/kasmrx
ENV INST_SCRIPTS $STARTUPDIR/install


### Install Tools
COPY ./src/ubuntu/install/tools $INST_SCRIPTS/tools/
RUN bash $INST_SCRIPTS/tools/install_tools_deluxe.sh  && rm -rf $INST_SCRIPTS/tools/

# Install Utilities
COPY ./src/ubuntu/install/misc $INST_SCRIPTS/misc/
RUN bash $INST_SCRIPTS/misc/install_tools.sh && rm -rf $INST_SCRIPTS/misc/

#================================================================================================================
# 本地已下载（可选）
#================================================================================================================
# COPY ./build/vs_code* /opt/
# COPY ./build/chrome* /opt/
# ## 不太好用
# # COPY ./build/wine/ /opt/wine-pkgs/
# COPY ./build/wine/after/ /opt/wine-pkgs/after/
# #================================================================================================================

# # # 切换国内源
# # COPY ./src/ubuntu/source/ $INST_SCRIPTS/source/
# RUN bash $INST_SCRIPTS/source/update_source.sh && rm -rf $INST_SCRIPTS/source/

# # Install Google Chrome
# COPY ./src/ubuntu/install/chrome $INST_SCRIPTS/chrome/
# RUN bash $INST_SCRIPTS/chrome/install_chrome.sh  && rm -rf $INST_SCRIPTS/chrome/

# #================================================================================================================
# # 系统不自带文本编辑器（可选）
# #================================================================================================================
# ## Install Visual Studio Code
# COPY ./src/ubuntu/install/vs_code $INST_SCRIPTS/vs_code/
# RUN bash $INST_SCRIPTS/vs_code/install_vs_code.sh  && rm -rf $INST_SCRIPTS/vs_code/

# # ## Install Sublime Text
# # COPY ./src/ubuntu/install/sublime_text $INST_SCRIPTS/sublime_text/
# # RUN bash $INST_SCRIPTS/sublime_text/install_sublime_text.sh  && rm -rf $INST_SCRIPTS/sublime_text/
# #================================================================================================================

# ### Install WINE
# COPY ./src/ubuntu/install/wine $INST_SCRIPTS/wine/
# RUN bash $INST_SCRIPTS/wine/install_wine.sh  && rm -rf $INST_SCRIPTS/wine/

#ADD ./src/common/scripts $STARTUPDIR
RUN $STARTUPDIR/set_user_permission.sh $HOME

RUN chown 1000:0 $HOME

ENV HOME /home/kasm-user
WORKDIR $HOME
RUN mkdir -p $HOME && chown -R 1000:0 $HOME

RUN adduser kasm-user sudo
RUN echo "kasm-user:$USER_PWD" | chpasswd

# # Install WineUI
# ## 本地安装包路径 /opt/wine-pkgs/after
# COPY ./src/ubuntu/install/wine $INST_SCRIPTS/wine/
# RUN bash $INST_SCRIPTS/wine/custom_startup.sh  && rm -rf $INST_SCRIPTS/wine/

USER 1000

CMD ["--tail-log"]
