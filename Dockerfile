FROM php:7.0-fpm

RUN apt-get update && apt-get install -y \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    libpng12-dev \
    libicu-dev \
    libxml2-dev

RUN docker-php-ext-install -j$(nproc) soap mcrypt pdo pdo_mysql mysqli
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/
RUN docker-php-ext-install -j$(nproc) gd

COPY etc/php.ini /usr/local/etc/php/php.ini
COPY etc/php-fpm.conf /usr/local/etc/php/php-fpm.conf
COPY etc/php-fpm.d/www.conf /usr/local/etc/php-fpm.d/www.conf

WORKDIR /var/www/html
