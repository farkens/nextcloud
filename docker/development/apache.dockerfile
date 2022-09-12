FROM php:8.0-apache

RUN mkdir /app

#RUN apt-get update && apt-get upgrade -y

#RUN apt-get install -y libpq-dev libpng-dev libjpeg-dev libfreetype6-dev libxml2-dev \
#    && docker-php-ext-install mysqli && docker-php-ext-enable mysqli docker-php-ext-install pdo #pdo_mysql && docker-php-ext-install soap


RUN docker-php-ext-install mysqli && docker-php-ext-enable mysqli

RUN apt-get update && apt-get upgrade -y

RUN apt-get update && \
     apt-get install -y \
         libzip-dev \
         && docker-php-ext-install zip
         
RUN apt-get update && apt-get install -y libmcrypt-dev \
    && pecl install mcrypt-1.0.4 \
    && docker-php-ext-enable mcrypt
         
RUN apt-get install -y --no-install-recommends \
        libcurl4-openssl-dev \
        libevent-dev \
        libfreetype6-dev \
        libicu-dev \
        libjpeg-dev \
        libldap2-dev \
        libmcrypt-dev \
        libmemcached-dev \
        libpng-dev \
        libpq-dev \
        libxml2-dev \
        libmagickwand-dev \
        libzip-dev \
        libwebp-dev \
        libgmp-dev
        
        
RUN docker-php-ext-install -j "$(nproc)" \
        bcmath \
        exif \
        gd \
        intl \
        ldap \
        opcache \
        pcntl \
        pdo_mysql \
        pdo_pgsql \
        zip \
        gmp
        
        
RUN apt-get update && apt-get upgrade -y

COPY apache/my-httpd.conf /etc/apache2/sites-available/httpd.conf
#COPY ./php/php.ini /usr/local/etc/php/

#COPY ./ssl/server.crt /etc/apache2/ssl/server.crt
#COPY ./ssl/server.key /etc/apache2/ssl/server.key
#RUN mkdir -p /var/run/apache2/

# Setting ServerName to avoid "Could not reliably determine the server's fully qualified domain name, using 127.0.1.1 for ServerName" warning
RUN echo "ServerName localhost" | tee /etc/apache2/conf-available/servername.conf
RUN a2enconf servername

# Configure Apache vhosts, enable mod rewrite
RUN chown -R www-data:www-data /app \
    && a2dissite 000-default.conf \
    && a2ensite httpd.conf \
    && a2enmod rewrite \
    && a2enmod ssl \
    && service apache2 restart

# Installing PHP, PHP extensions and necessary packages
RUN apt-get update && apt-get install -y --no-install-recommends libpng-dev libjpeg-dev libjpeg62-turbo libmcrypt4 libmcrypt-dev libcurl3-dev libxml2-dev libxslt-dev libicu-dev  && rm -rf /var/lib/apt/lists/*


# Exposing web ports
EXPOSE 80 443

CMD apachectl -D FOREGROUND

WORKDIR /app





