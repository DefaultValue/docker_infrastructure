FROM php:8.3.30-apache-trixie

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install packages
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends \
        cron \
        git \
        jq \
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
        librabbitmq-dev \
        libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# Install PECL extensions
RUN pecl install imagick redis amqp \
    && docker-php-ext-enable imagick redis amqp

# Configure and install PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install bcmath gd intl mysqli opcache pcntl pdo_mysql soap sockets xsl zip

# PHP configuration and Apache modules
RUN printf 'date.timezone=UTC\n\
always_populate_raw_post_data=-1\n\
memory_limit=2048M\n\
realpath_cache_size=10M\n\
realpath_cache_ttl=7200\n\
opcache.enable=1\n\
opcache.validate_timestamps=1\n\
opcache.revalidate_freq=1\n\
opcache.max_wasted_percentage=10\n\
opcache.memory_consumption=256\n\
opcache.max_accelerated_files=20000\n\
amqp.connection_timeout=3\n\
amqp.read_timeout=3\n\
amqp.write_timeout=3\n\
amqp.heartbeat=2\n' > "$PHP_INI_DIR/conf.d/docker-php-zzz-custom.ini" \
    && a2enmod rewrite proxy proxy_http ssl headers expires

# Must use the same UID/GUI as on the local system for the shared files to be editable on both systems
RUN groupadd -g 1000 docker \
    && useradd -u 1000 -g docker -m docker

RUN curl -k -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && chmod +x /usr/local/bin/composer

RUN cat /usr/local/etc/php/php.ini-production > /usr/local/etc/php/php.ini \
    && rm -rf /tmp/pear/
