FROM nextcloud
COPY scripts/setssl.sh /usr/local/bin/
COPY keys/cert.pem /etc/ssl/nextcloud/cert.pem
COPY keys/key.pem /etc/ssl/nextcloud/key.pem
RUN /usr/local/bin/setssl.sh admin@cyber.ee nextcloud.cyber.ee
RUN mv /usr/local/etc/php/php.ini-development /usr/local/etc/php/php.ini
RUN echo "alias occ='runuser --user www-data -- php /var/www/html/occ'" >> /root/.bashrc

# DEBUG
RUN pecl install xdebug
RUN docker-php-ext-enable xdebug
RUN echo "\n\
xdebug.mode=develop,coverage,debug,profile\n\
xdebug.idekey=docker\n\
xdebug.log=/dev/stdout\n\
xdebug.log_level=0\n\
xdebug.client_port=9003\n\
xdebug.start_with_request = yes\n" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

# ANTIVIRUS
# RUN apt update && apt install -y clamav clamav-daemon
# RUN freshclam