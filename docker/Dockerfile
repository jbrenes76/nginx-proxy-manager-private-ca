FROM jc21/nginx-proxy-manager:latest

COPY 80-private-ca.sh /etc/s6-overlay/s6-rc.d/prepare/80-private-ca.sh
RUN chmod +x /etc/s6-overlay/s6-rc.d/prepare/80-private-ca.sh