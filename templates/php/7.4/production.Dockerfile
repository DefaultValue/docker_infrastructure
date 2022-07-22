FROM php:7.4-apache-buster

# Install packages
RUN apt-get update ; \
    apt-get upgrade ; \
    apt-get install -y \
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
        libsodium-dev \
        libmemcached-dev \
        memcached \
        --no-install-recommends

RUN rm -r /var/lib/apt/lists/*

RUN pear install MIME_Type

RUN pecl install imagick memcached redis ; \
    docker-php-ext-enable imagick memcached redis ; \
    rm -rf /tmp/pear/

# Configure PHP extention installation options
RUN docker-php-ext-configure gd --with-freetype --with-jpeg

# Install PHP Extensions
RUN docker-php-ext-install bcmath gd intl mysqli opcache pcntl pdo_mysql soap sodium sockets xml xmlrpc xsl zip

RUN echo "always_populate_raw_post_data=-1" >> /usr/local/etc/php/conf.d/docker-php-xxx-custom.ini ; \
    echo 'memory_limit=3072M' >> /usr/local/etc/php/conf.d/docker-php-xxx-custom.ini ; \
    echo 'realpath_cache_size=10M' >> /usr/local/etc/php/conf.d/docker-php-xxx-custom.ini ; \
    echo 'realpath_cache_ttl=7200' >> /usr/local/etc/php/conf.d/docker-php-xxx-custom.ini ; \
    echo 'pcre.jit=0' >> /usr/local/etc/php/conf.d/docker-php-xxx-custom.ini

# Set default settigs to be sure they are correct and for demo purposes
RUN echo "opcache.enable=1" >> /usr/local/etc/php/conf.d/docker-php-xxx-custom.ini ; \
    echo "opcache.validate_timestamps=1" >> /usr/local/etc/php/conf.d/docker-php-xxx-custom.ini ; \
    echo "opcache.revalidate_freq=1" >> /usr/local/etc/php/conf.d/docker-php-xxx-custom.ini ; \
    echo "opcache.max_wasted_percentage=10" >> /usr/local/etc/php/conf.d/docker-php-xxx-custom.ini ; \
    echo "opcache.memory_consumption=256" >> /usr/local/etc/php/conf.d/docker-php-xxx-custom.ini ; \
    echo "opcache.max_accelerated_files=20000" >> /usr/local/etc/php/conf.d/docker-php-xxx-custom.ini ; \
    echo "opcache.save_comments=1" >> /usr/local/etc/php/conf.d/docker-php-xxx-custom.ini

RUN a2enmod rewrite proxy proxy_http ssl headers expires

# Must use the same UID/GUI as on the local system for the shared files to be editable on both systems
RUN groupadd -g 1000 docker && useradd -u 1000 -g docker -m docker

COPY ./docker/composer-proxy /usr/local/bin/composer

RUN chmod +x /usr/local/bin/composer ; \
    curl -k -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer1 --1 ; \
    curl -k -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer2 ; \
    su docker -c "composer1 global require hirak/prestissimo"

RUN cat /usr/local/etc/php/php.ini-production > /usr/local/etc/php/php.ini