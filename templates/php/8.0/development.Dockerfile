FROM php:8.0-apache-bullseye

## Install packages
RUN apt update ; \
    apt upgrade ; \
    apt install -y \
        cron \
        git \
        lsof \
        zip \
        unzip \
        libmagickwand-dev \
        libicu-dev \
        libjpeg-dev \
        libpng-dev \
        libfreetype-dev \
        libxml2-dev \
        libxslt1-dev \
        libzip-dev \
        zlib1g-dev \
        --no-install-recommends

RUN rm -r /var/lib/apt/lists/*

RUN pecl install imagick ; docker-php-ext-enable imagick

# Configure PHP extentions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg

# Install PHP Extensions
RUN docker-php-ext-install bcmath gd intl  mysqli pcntl pdo_mysql sockets soap xsl xmlwriter zip

RUN echo "always_populate_raw_post_data=-1" >> /usr/local/etc/php/conf.d/docker-php-xxx-custom.ini ; \
    echo 'memory_limit=3072M' >> /usr/local/etc/php/conf.d/docker-php-xxx-custom.ini ; \
    echo 'realpath_cache_size=10M' >> /usr/local/etc/php/conf.d/docker-php-xxx-custom.ini ; \
    echo 'realpath_cache_ttl=7200' >> /usr/local/etc/php/conf.d/docker-php-xxx-custom.ini ; \
    echo 'pcre.jit=0' >> /usr/local/etc/php/conf.d/docker-php-xxx-custom.ini

# Will use this in production as well for now - till we do not have full CD process
RUN docker-php-ext-install opcache ; \
    docker-php-ext-enable opcache ; \
    echo "opcache.enable=1" >> /usr/local/etc/php/conf.d/docker-php-xxx-custom.ini ; \
    echo "opcache.validate_timestamps=1" >> /usr/local/etc/php/conf.d/docker-php-xxx-custom.ini ; \
    echo "opcache.revalidate_freq=1" >> /usr/local/etc/php/conf.d/docker-php-xxx-custom.ini ; \
    echo "opcache.max_wasted_percentage=10" >> /usr/local/etc/php/conf.d/docker-php-xxx-custom.ini ; \
    echo "opcache.memory_consumption=256" >> /usr/local/etc/php/conf.d/docker-php-xxx-custom.ini ; \
    echo "opcache.max_accelerated_files=20000" >> /usr/local/etc/php/conf.d/docker-php-xxx-custom.ini

RUN a2enmod rewrite proxy proxy_http ssl headers expires

# Must use the same UID/GUI as on the local system for the shared files to be editable on both systems
RUN groupadd -g 1000 docker && useradd -u 1000 -g docker -m docker

COPY ./docker/composer-proxy /usr/local/bin/composer

RUN chmod +x /usr/local/bin/composer ; \
    curl -k -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer1 --1 ; \
    curl -k -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer2 ; \
    su docker -c "composer1 global require hirak/prestissimo"

RUN cp /usr/local/etc/php/php.ini-development /usr/local/etc/php/php.ini

RUN pecl install xdebug-3.1.4 ; \
    docker-php-ext-enable xdebug ; \
    echo "xdebug.mode=debug" >> /usr/local/etc/php/conf.d/docker-php-xxx-custom.ini ; \
    echo "xdebug.remote_handler=dbgp" >> /usr/local/etc/php/conf.d/docker-php-xxx-custom.ini ; \
    echo "xdebug.discover_client_host=0" >> /usr/local/etc/php/conf.d/docker-php-xxx-custom.ini ; \
    echo "xdebug.show_error_trace=1" >> /usr/local/etc/php/conf.d/docker-php-xxx-custom.ini ; \
    echo "xdebug.start_with_request=yes" >> /usr/local/etc/php/conf.d/docker-php-xxx-custom.ini ; \
    echo "xdebug.max_nesting_level=256" >> /usr/local/etc/php/conf.d/docker-php-xxx-custom.ini ; \
    echo "xdebug.log_level=0" >> /usr/local/etc/php/conf.d/docker-php-xxx-custom.ini ; \
    echo "xdebug.client_host=host.docker.internal" >> /usr/local/etc/php/conf.d/docker-php-xxx-custom.ini

# Grunt uses Magento 2 CLI commands. Need to install it for development
RUN curl -sL https://deb.nodesource.com/setup_16.x | bash - \
    && apt-get install nodejs -y \
    && npm install -g grunt-cli

# Install mhsendmail - Sendmail replacement for Mailhog
RUN curl https://github.com/mailhog/mhsendmail/releases/download/v0.2.0/mhsendmail_linux_amd64 --output /usr/bin/mhsendmail ; \
    echo 'sendmail_path = /usr/bin/mhsendmail --smtp-addr mailhog:1025' >> /usr/local/etc/php/conf.d/docker-php-xxx-custom.ini