FROM mcr.microsoft.com/devcontainers/base:bullseye

ADD https://github.com/alire-project/alire/releases/download/v1.2.1/alr-1.2.1-bin-x86_64-linux.zip /tmp
RUN mkdir -p /opt/ada && unzip /tmp/alr-1.2.1-bin-x86_64-linux.zip -d /opt/ada/
RUN echo "export PATH=$PATH:/opt/ada/bin" >> /home/vscode/.bashrc
