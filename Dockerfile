FROM php:7.0-fpm

COPY etc/php.ini /usr/local/etc/php/php.ini
COPY etc/php-fpm.conf /usr/local/etc/php/php-fpm.conf
COPY etc/php-fpm.d/www.conf /usr/local/etc/php-fpm.d/www.conf
