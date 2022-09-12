FROM php:8.0.23-fpm

RUN apt-get update && apt-get install -y libpq-dev libpng-dev libjpeg-dev libfreetype6-dev libxml2-dev \
    && docker-php-ext-install pdo pdo_mysql && docker-php-ext-install soap


#RUN pecl install xdebug-2.9.2 && docker-php-ext-enable xdebug
#COPY php/xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini
#ENV PHP_IDE_CONFIG "serverName=Docker"

WORKDIR /app
