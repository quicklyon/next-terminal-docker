FROM hub.qucheng.com/library/debian:11.3-slim

COPY debian/prebuildfs /

ENV TZ=Asia/Shanghai \
    DEBIAN_FRONTEND=noninteractive

COPY debian/rootfs /

ENTRYPOINT ["/usr/bin/entrypoint.sh"]
