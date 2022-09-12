FROM php:7.3-cli

RUN apt-get update && apt-get install -y libpq-dev unzip git libxml2-dev \
    && docker-php-ext-install pdo pdo_mysql soap

#RUN pecl install xdebug-2.9.2 && docker-php-ext-enable xdebug
#COPY php/xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini
#ENV PHP_IDE_CONFIG "serverName=Docker"

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/bin --filename=composer --quiet
ENV COMPOSER_ALLOW_SUPERUSER 1

WORKDIR /app
