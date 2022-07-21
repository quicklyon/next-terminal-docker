FROM hub.qucheng.com/library/debian:11.3-slim

COPY debian/prebuildfs /

ENV TZ=Asia/Shanghai \
    DEBIAN_FRONTEND=noninteractive

RUN sed -i -r 's/(deb|security).debian.org/mirrors.cloud.tencent.com/g' /etc/apt/sources.list \
    && install_packages curl wget tzdata zip unzip s6 pwgen cron ca-certificates
    && ln -fs /usr/share/zoneinfo/${TZ} /etc/localtime \
    && echo ${TZ} > /etc/timezone \
    && dpkg-reconfigure --frontend noninteractive tzdata

RUN mkdir tmp \
    && curl -sL https://github.com/dushixiang/next-terminal/releases/download/v1.2.7/next-terminal.tar.gz | tar xvz -C tmp \
    && mv tmp/next-terminal /usr/local/bin/next-terminal \
    && chmod +x /usr/local/bin/next-terminal \
    && rm -rf tmp

# Install render-template
RUN . /opt/easysoft/scripts/libcomponent.sh && component_unpack "render-template" "1.0.1-10" --checksum 5e410e55497aa79a6a0c5408b69ad4247d31098bdb0853449f96197180ed65a4

# Install mysql-client
RUN . /opt/easysoft/scripts/libcomponent.sh && component_unpack "mysql-client" "10.5.15" -c 31182985daa1a2a959b5197b570961cdaacf3d4e58e59a192c610f8c8f1968a8

# Install wait-for-port
RUN . /opt/easysoft/scripts/libcomponent.sh && component_unpack "wait-for-port" "1.01" -c 2ad97310f0ecfbfac13480cabf3691238fdb3759289380262eb95f8660ebb8d1

COPY debian/rootfs /

EXPOSE 8088

# Persistence directory
VOLUME [ "/usr/local/next-terminal/data"]

ENTRYPOINT ["/usr/bin/entrypoint.sh"]
