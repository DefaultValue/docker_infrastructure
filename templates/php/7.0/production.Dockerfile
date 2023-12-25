FROM php:7.0.33-apache-stretch@sha256:1d34b2e491a02ba7a8d26478132015e197a5ffea37f0a93b42621d11cfe042cc

# Based on https://unix.stackexchange.com/questions/743839/apt-get-update-failed-to-fetch-debian-amd64-packages-while-building-dockerfile-f
# and https://serverfault.com/questions/1074688/security-debian-org-does-not-have-a-release-file-on-with-debian-docker-images
RUN echo 'deb http://archive.debian.org/debian stretch main' > /etc/apt/sources.list \
    && sed -i 's/stable\/updates/stable-security\/updates/' /etc/apt/sources.list

# Install packages
RUN apt update \
    && apt upgrade -y \
    && apt install -y \
        cron \
        curl \
        git \
        zip \
        unzip \
        libicu-dev \
        libpng-dev \
        libxml2-dev \
        zlib1g-dev \
        libxslt1-dev \
        libmagickwand-dev \
        librecode0 \
        librecode-dev \
        libzip-dev \
        libmcrypt-dev \
        --no-install-recommends

RUN apt install -y memcached libmemcached-dev \
    && pecl install memcached \
    && docker-php-ext-enable memcached

RUN pecl install imagick \
    && docker-php-ext-enable imagick

RUN pecl install redis-5.3.7 \
    && docker-php-ext-enable redis

RUN pear install MIME_Type

# Configure GD2 installation options
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/

# Install PHP Extensions
RUN docker-php-ext-install gd intl mysqli opcache pcntl pdo_mysql soap xml xmlrpc xsl zip bcmath mcrypt recode

RUN echo 'always_populate_raw_post_data=-1\n\
memory_limit=2048M\n\
realpath_cache_size=10M\n\
realpath_cache_ttl=7200\n\
opcache.enable=1\n\
opcache.validate_timestamps=1\n\
opcache.revalidate_freq=1\n\
opcache.max_wasted_percentage=10\n\
opcache.memory_consumption=256\n\
opcache.max_accelerated_files=20000' > /usr/local/etc/php/conf.d/docker-php-xxx-custom.ini

RUN a2enmod rewrite proxy proxy_http ssl headers expires

# Must use the same UID/GUI as on the local system for the shared files to be editable on both systems
RUN groupadd -g 1000 docker \
    && useradd -u 1000 -g docker -m docker

RUN curl -k -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer1 --1 \
    && curl -k -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer2 \
    && su docker -c "composer1 global require hirak/prestissimo"

RUN echo '#!/bin/sh\n\
composerVersion="${COMPOSER_VERSION:-2}"\n\
# Magento requires up to 4GB RAM for `composer create-project` and `composer install` to run\n\
composerCommand="php -d memory_limit=4096M /usr/local/bin/composer${composerVersion}"\n\
$composerCommand "$@"' > /usr/local/bin/composer \
    && chmod +x /usr/local/bin/composer

RUN cat /usr/local/etc/php/php.ini-production > /usr/local/etc/php/php.ini

RUN rm -r /var/lib/apt/lists/* \
    && rm -rf /tmp/pear/