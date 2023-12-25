# PHP 5.6.40 removal: https://github.com/docker-library/php/commit/e9320fdb752edb2fb5d1be8412172f5c78255a45
FROM php:5.6.40-apache-stretch

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

# Download and install memcached from the archive. Ignore: curl: (60) SSL certificate problem: certificate has expired
# https://pecl.php.net/package/memcached (2.2.0 for PHP 5.6, 3.2.0 for PHP 7.0.0 or newer)
RUN apt install -y memcached libmemcached-dev \
    && curl --insecure 'https://pecl.php.net/get/memcached-2.2.0.tgz' -o memcached-2.2.0.tgz \
    && pecl install --offline memcached-2.2.0.tgz \
    && docker-php-ext-enable memcached \
    && rm memcached-2.2.0.tgz

# Install imagick 3.7.0: https://pecl.php.net/package/imagick (PHP 5.4.0 or newer)
RUN curl --insecure https://pecl.php.net/get/imagick-3.7.0.tgz -o imagick-3.7.0.tgz \
    && pecl install --offline imagick-3.7.0.tgz \
    && docker-php-ext-enable imagick \
    && rm imagick-3.7.0.tgz

# Install Redis: https://pecl.php.net/package/redis \
# 2.2.8 for PHP 5.6, 5.3.7 for PHP 7.0.0 or newer
RUN curl --insecure https://pecl.php.net/get/redis-2.2.8.tgz -o redis-2.2.8.tgz \
    && pecl install --offline redis-2.2.8.tgz \
    && docker-php-ext-enable redis \
    && rm redis-2.2.8.tgz

# https://pear.php.net/package/MIME_Type/download
RUN curl http://download.pear.php.net/package/MIME_Type-1.4.1.tgz -o MIME_Type.tgz \
    && pear install MIME_Type.tgz \
    && rm MIME_Type.tgz

# Configure GD2 installation options
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/

# Install PHP Extensions
RUN docker-php-ext-install gd intl mysqli opcache pcntl pdo_mysql recode soap xml xmlrpc xsl zip bcmath mcrypt

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
# Magento requires up to 6GB RAM for `composer create-project` and `composer install` to run (2.1.18)\n\
composerCommand="php -d memory_limit=6144M /usr/local/bin/composer${composerVersion}"\n\
$composerCommand "$@"' > /usr/local/bin/composer \
    && chmod +x /usr/local/bin/composer

RUN cat /usr/local/etc/php/php.ini-production > /usr/local/etc/php/php.ini

RUN rm -r /var/lib/apt/lists/* \
    && rm -rf /tmp/pear/
