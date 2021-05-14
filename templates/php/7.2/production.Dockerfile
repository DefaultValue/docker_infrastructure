FROM php:7.2-apache-buster

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
            --no-install-recommends \
    && pecl install imagick \
    && docker-php-ext-enable imagick \
    && pear install MIME_Type

RUN apt-get install -y memcached libmemcached-dev \
    && pecl install memcached \
    && docker-php-ext-enable memcached

RUN rm -r /var/lib/apt/lists/*

# Configure PHP extentions
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/

# Install PHP Extensions
RUN docker-php-ext-install gd intl mysqli pcntl pdo_mysql soap xml xmlrpc xsl zip bcmath sodium recode sockets

RUN cp /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini ; \
    echo "always_populate_raw_post_data=-1" >> /usr/local/etc/php/conf.d/docker-php-xxx-custom.ini ; \
    echo 'memory_limit=3072M' >> /usr/local/etc/php/conf.d/docker-php-xxx-custom.ini

# Will use this in production as well for now - till we do not have full CD process
RUN docker-php-ext-install opcache ; \
    echo "opcache.enable=1" >> /usr/local/etc/php/conf.d/docker-php-xxx-custom.ini \
    && echo "opcache.validate_timestamps=1" >> /usr/local/etc/php/conf.d/docker-php-xxx-custom.ini \
    && echo "opcache.revalidate_freq=1" >> /usr/local/etc/php/conf.d/docker-php-xxx-custom.ini \
    && echo "opcache.max_wasted_percentage=10" >> /usr/local/etc/php/conf.d/docker-php-xxx-custom.ini \
    && echo "opcache.memory_consumption=256" >> /usr/local/etc/php/conf.d/docker-php-xxx-custom.ini \
    && echo "opcache.max_accelerated_files=20000" >> /usr/local/etc/php/conf.d/docker-php-xxx-custom.ini

RUN a2enmod rewrite proxy proxy_http ssl headers expires

# Must use the same UID/GUI as on the local system for the shared files to be editable on both systems
RUN groupadd -g 1000 docker && useradd -u 1000 -g docker -m docker

COPY ./docker/composer-proxy /usr/local/bin/composer

RUN chmod +x /usr/local/bin/composer ; \
    curl -k -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer1 --1 ; \
    curl -k -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer2 ; \
    su docker -c "composer1 global require hirak/prestissimo"