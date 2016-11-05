FROM php:7.0-fpm

RUN apt-get update && \
    apt-get install -y \
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

# Install New Relic
RUN apt-get update 
RUN apt-get -yqq install wget
RUN apt-get -yqq install python-setuptools
RUN easy_install pip
RUN mkdir -p /opt/newrelic
WORKDIR /opt/newrelic
RUN wget -r -nd --no-parent -Alinux.tar.gz http://download.newrelic.com/php_agent/release/ >/dev/null 2>&1 && \
    tar -xzf newrelic-php*.tar.gz --strip=1
ENV NR_INSTALL_SILENT true
ENV NR_INSTALL_KEY c82bc3ea32a4b049dccdea0391dee91c64caa9c2
RUN bash newrelic-install install
WORKDIR /
RUN pip install newrelic-plugin-agent
ENV NR_APP_NAME Magento_eShop
RUN sed -i "s/newrelic.appname = \"PHP Application\"/newrelic.appname = \"${NR_APP_NAME}\"/" /usr/local/etc/php/conf.d/newrelic.ini
RUN mkdir -p /var/log/newrelic
RUN mkdir -p /var/run/newrelic

WORKDIR /var/www/html
