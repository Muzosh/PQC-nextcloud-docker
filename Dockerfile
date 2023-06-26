FROM nextcloud
COPY setssl.sh /usr/local/bin/
COPY cert.pem /etc/ssl/nextcloud/cert.pem
COPY key.pem /etc/ssl/nextcloud/key.pem
RUN /usr/local/bin/setssl.sh admin@cyber.ee nextcloud.cyber.ee