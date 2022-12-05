FROM mcr.microsoft.com/devcontainers/base:bullseye

RUN curl https://www2.cs.arizona.edu/icon/ftp/historic/v951.tgz --output /tmp/icon.tgz
RUN mkdir /opt/icon
RUN gunzip </tmp/icon.tgz | tar xf - -C /opt/icon && rm /tmp/icon.tgz
RUN cd /opt/icon/icon-v951src && make Configure name=linux && bash -c $(make All)
RUN echo "export PATH=$PATH:/opt/icon/icon-v951src/bin" >> /home/vscode/.bashrc
