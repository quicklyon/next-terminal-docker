# guacamole builder
FROM easysoft/debian:11 as guacbuilder

ARG GUACD_VERSION=1.4.0

COPY debian/prebuildfs /

RUN \
 echo "**** install build deps ****" && \
  apt update && \
  apt install -y \
  libcairo2-dev \
  libjpeg62-turbo-dev \
  libavcodec-dev \
  libavformat-dev \
  libavutil-dev \
  libswscale-dev \
  freerdp2-dev \
  libssl-dev \
  uuid-dev \
  libtool-bin \
  libossp-uuid-dev \
  libpango1.0-dev \
  libpulse-dev \
  libssh2-1-dev \
  libvncserver-dev \
  libvorbis-dev \
  libwebp-dev \
  libtelnet-dev \
  libwebsockets-dev \
  perl \
  autoconf \
  automake \
  build-essential

RUN \
 echo "**** compile guacamole ****" && \
 mkdir /buildout && \
 mkdir /tmp/guac && \
 cd /tmp/guac && \
 wget \
	https://pkg-1308438674.cos.ap-shanghai.myqcloud.com/qucheng/library/guacamole/guacamole-server-${GUACD_VERSION}.tar.gz \
	-O guac.tar.gz && \
 tar -xf guac.tar.gz && \
 wget \ 
	https://ghproxy.com/https://raw.githubusercontent.com/apache/guacamole-server/master/src/guacenc/ffmpeg-compat.c \
	-O /tmp/guac/guacamole-server-${GUACD_VERSION}/src/guacenc/ffmpeg-compat.c && \
 cd guacamole-server-${GUACD_VERSION} && \
 ./configure \
	--prefix=/usr \
	--sysconfdir=/etc \
	--mandir=/usr/share/man \
	--localstatedir=/var \
	--disable-static \
	--with-libavcodec \
	--with-libavutil \
	--with-libswscale \
	--with-ssl \
	--without-winsock \
	--with-vorbis \
	--with-pulse \
	--with-pango \
	--with-terminal \
	--with-vnc \
	--with-rdp \
	--with-ssh \
	--with-telnet \
	--with-webp \
	--with-websockets && \
 make && \
 make DESTDIR=/buildout install

FROM easysoft/debian:11

COPY debian/prebuildfs /

ENV TZ=Asia/Shanghai \
    DEBIAN_FRONTEND=noninteractive \
    OS_ARCH="amd64" \
    OS_NAME="debian-11"

COPY --from=guacbuilder /buildout /

RUN install_packages libcairo2 libjpeg62-turbo libwebp-dev libssh2-1 freerdp2-dev \  
        libavcodec-dev \
        libavformat-dev \
        libavutil-dev \
        libswscale-dev \
        libtelnet-dev \
        libvncserver-dev \
        libwebsockets-dev \
        cabextract \
        xfonts-utils \
        fontconfig \
        ttf-mscorefonts-installer

RUN curl -sL https://ghproxy.com/https://github.com/dushixiang/next-terminal/releases/download/v1.2.7/next-terminal.tar.gz | tar xvz -C /tmp \
    && mkdir -p /usr/local/next-terminal \
    && mv /tmp/next-terminal/next-terminal /usr/local/next-terminal/next-terminal \
    && chmod +x /usr/local/next-terminal/next-terminal \
    && touch /usr/local/next-terminal/config.yml \
    && rm -rf /tmp/* \
    && mkfontscale \
    && mkfontdir \
    && fc-cache

# Install render-template
RUN . /opt/easysoft/scripts/libcomponent.sh && component_unpack "render-template" "1.0.1-10" --checksum 5e410e55497aa79a6a0c5408b69ad4247d31098bdb0853449f96197180ed65a4

# Install mysql-client
RUN . /opt/easysoft/scripts/libcomponent.sh && component_unpack "mysql-client" "10.5.15" -c 31182985daa1a2a959b5197b570961cdaacf3d4e58e59a192c610f8c8f1968a8

# Install wait-for-port
RUN . /opt/easysoft/scripts/libcomponent.sh && component_unpack "wait-for-port" "1.01" -c 2ad97310f0ecfbfac13480cabf3691238fdb3759289380262eb95f8660ebb8d1

COPY debian/rootfs /

EXPOSE 8088

ENV EASYSOFT_APP_NAME="Next Terminal 1.2.7" \
    HOME_PAGE="https://github.com/quicklyon/next-terminal-docker" \
    TIME_ZONE=Asia/Shanghai

# Persistence directory
VOLUME [ "/usr/local/next-terminal/data"]

ENTRYPOINT ["/usr/bin/entrypoint.sh"]
