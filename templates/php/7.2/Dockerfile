FROM php:7.2-apache-stretch

ARG DEVELOPER_MODE

ARG MEMCACHED

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
         \
            --no-install-recommends \
    && pecl install imagick \
    && docker-php-ext-enable imagick \
    && pear install MIME_Type

RUN if [ "$MEMCACHED" = 1 ] ; then \
        apt-get install -y memcached libmemcached-dev \
        && pecl install memcached \
        && docker-php-ext-enable memcached ; \
    fi ;

RUN echo "deb http://deb.debian.org/debian stretch-backports main" >> /etc/apt/sources.list ; \
    apt-get update && apt-get -t stretch-backports install -y libsodium-dev ; \
    docker-php-ext-install sodium

RUN rm -r /var/lib/apt/lists/*

# Configure PHP extentions
RUN docker-php-ext-configure \
  gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/

# Install PHP Extensions
RUN docker-php-ext-install gd intl pdo_mysql recode soap xml xmlrpc xsl zip bcmath

RUN if [ "$DEVELOPER_MODE" = 1 ] ; then \
        pecl install xdebug ; \
        docker-php-ext-enable xdebug ; \
        echo "xdebug.remote_enable=1" >> /usr/local/etc/php/conf.d/docker-php-xxx-custom.ini \
        && echo "xdebug.idekey=\"PHPSTORM\"" >> /usr/local/etc/php/conf.d/docker-php-xxx-custom.ini \
        && echo "xdebug.remote_port=9000" >> /usr/local/etc/php/conf.d/docker-php-xxx-custom.ini \
        && echo "xdebug.remote_connect_back=0" >> /usr/local/etc/php/conf.d/docker-php-xxx-custom.ini \
        && echo "xdebug.remote_autostart=1" >> /usr/local/etc/php/conf.d/docker-php-xxx-custom.ini \
        && echo "xdebug.remote_host=host.docker.internal" >> /usr/local/etc/php/conf.d/docker-php-xxx-custom.ini ; \
        cp /usr/local/etc/php/php.ini-development /usr/local/etc/php/php.ini ; \
    else \
        docker-php-ext-install opcache ; \
        cp /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini ; \
    fi ; \
    echo "always_populate_raw_post_data=-1" >> /usr/local/etc/php/conf.d/docker-php-xxx-custom.ini ; \
    echo 'memory_limit=2G' >> /usr/local/etc/php/conf.d/docker-php-xxx-custom.ini

# Will use this in production as well for now - till we do not have full CD process
RUN docker-php-ext-install opcache ; \
    echo "opcache.enable=1" >> /usr/local/etc/php/conf.d/docker-php-xxx-custom.ini \
    && echo "opcache.validate_timestamps=1" >> /usr/local/etc/php/conf.d/docker-php-xxx-custom.ini \
    && echo "opcache.revalidate_freq=1" >> /usr/local/etc/php/conf.d/docker-php-xxx-custom.ini \
    && echo "opcache.max_wasted_percentage=10" >> /usr/local/etc/php/conf.d/docker-php-xxx-custom.ini \
    && echo "opcache.memory_consumption=256" >> /usr/local/etc/php/conf.d/docker-php-xxx-custom.ini \
    && echo "opcache.max_accelerated_files=20000" >> /usr/local/etc/php/conf.d/docker-php-xxx-custom.ini

# Grunt uses PHP :( So need to install it for dev env. Let's for now orient on DEVELOPER_MODE variable for now
RUN if [ "$DEVELOPER_MODE" = 1 ] ; then \
        curl -sL https://deb.nodesource.com/setup_11.x | bash - \
        && apt-get install nodejs -y \
        && npm install -g grunt-cli ; \
    fi ;

RUN a2enmod rewrite proxy proxy_http ssl headers expires
#RUN a2enmod rewrite

RUN curl -k -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Must use the same UID/GUI as on the local system for the shared files to be editable on both systems
RUN if [ "$DEVELOPER_MODE" = 1 ] ; then \
        groupadd -g 1000 docker && useradd -u 1000 -g docker -m docker ; \
        su docker -c "composer global require hirak/prestissimo" ; \
    else \
        composer global require hirak/prestissimo ; \
    fi ;