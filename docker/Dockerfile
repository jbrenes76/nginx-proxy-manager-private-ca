FROM jc21/nginx-proxy-manager:2.15.0

COPY 80-private-ca.sh /etc/s6-overlay/s6-rc.d/prepare/80-private-ca.sh

RUN chmod +x /etc/s6-overlay/s6-rc.d/prepare/80-private-ca.sh \
    && sed -i '/90-banner.sh/i . /etc/s6-overlay/s6-rc.d/prepare/80-private-ca.sh' /etc/s6-overlay/s6-rc.d/prepare/00-all.sh