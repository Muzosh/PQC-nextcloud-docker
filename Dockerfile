FROM nextcloud:27
WORKDIR /root

# SETUP SSL
COPY scripts/setssl.sh /usr/local/bin/
COPY keys/cert.pem /etc/ssl/nextcloud/cert.pem
COPY keys/key.pem /etc/ssl/nextcloud/key.pem
RUN /usr/local/bin/setssl.sh admin@cyber.ee nextcloud.cyber.ee

# GENERAL
RUN echo "alias occ='runuser --user www-data -- php /var/www/html/occ'" >> /root/.bashrc
RUN apt update
RUN apt install -y git wget 

# PHP CONFIG
RUN mv /usr/local/etc/php/php.ini-development /usr/local/etc/php/php.ini

# INSTALL LIBOQS AND BUILD OQS-PHP EXTENSION
# liboqs
RUN apt install -y astyle cmake gcc ninja-build libssl-dev python3-pytest python3-pytest-xdist unzip xsltproc doxygen graphviz python3-yaml valgrind \
    && git clone --branch 0.8.0 https://github.com/open-quantum-safe/liboqs.git \
    && cd liboqs \
    && mkdir build \
    && cd build \
    && cmake -GNinja .. \
    && ninja
# swig
RUN mkdir swig \
    && cd swig \
    && wget -q http://prdownloads.sourceforge.net/swig/swig-4.1.1.tar.gz \
    && tar -xf swig-4.1.1.tar.gz \
    && cd swig-4.1.1 \
    && apt-get -y install libpcre2-dev \
    && ./configure \
    && make \
    && make install
# LIBoqs-php
RUN git clone https://github.com/Muzosh/liboqs-php.git \
    && cd liboqs-php \
    && export LIBOQS_ROOT_DIR=/root/liboqs \
    && ./compile.sh \
    && cp build/oqsphp.so /usr/share/oqsphp.so \
    && echo "extension=/usr/share/oqsphp.so" >> /usr/local/etc/php/php.ini

# ENABLE DEBUGGING
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
# apt install -y clamav clamav-daemon
# RUN freshclam