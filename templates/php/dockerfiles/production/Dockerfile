FROM php:{{php_version}}-apache-{{debian_release}}

# Install packages
RUN apt-get update \
    && apt-get install -y \
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
        {{additional_libs}} \
            --no-install-recommends \
    && pecl install imagick \
    && docker-php-ext-enable imagick \
    && pear install MIME_Type

RUN apt-get install -y memcached libmemcached-dev \
    && pecl install memcached \
    && docker-php-ext-enable memcached

RUN rm -r /var/lib/apt/lists/*

# Configure PHP extentions
RUN docker-php-ext-configure gd {{gd_options}}

# Install PHP Extensions
RUN docker-php-ext-install gd intl mysqli pcntl pdo_mysql soap xml xmlrpc xsl zip {{additional_modules}}

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

RUN curl -k -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --1

# Must use the same UID/GUI as on the local system for the shared files to be editable on both systems
RUN groupadd -g 1000 docker && useradd -u 1000 -g docker -m docker ; \
    su docker -c "composer global require hirak/prestissimo"