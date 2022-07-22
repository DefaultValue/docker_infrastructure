FROM defaultvalue/php:7.4-production

RUN cat /usr/local/etc/php/php.ini-development > /usr/local/etc/php/php.ini

RUN pecl install xdebug-2.9.5 ; \
    docker-php-ext-enable xdebug ; \
    echo "xdebug.remote_enable=1" >> /usr/local/etc/php/conf.d/docker-php-xxx-custom.ini ; \
    echo "xdebug.idekey=\"PHPSTORM\"" >> /usr/local/etc/php/conf.d/docker-php-xxx-custom.ini ; \
    echo "xdebug.remote_port=9000" >> /usr/local/etc/php/conf.d/docker-php-xxx-custom.ini ; \
    echo "xdebug.remote_connect_back=0" >> /usr/local/etc/php/conf.d/docker-php-xxx-custom.ini ; \
    echo "xdebug.remote_autostart=1" >> /usr/local/etc/php/conf.d/docker-php-xxx-custom.ini ; \
    echo "xdebug.remote_host=host.docker.internal" >> /usr/local/etc/php/conf.d/docker-php-xxx-custom.ini

# Grunt uses Magento 2 CLI commands. Need to install it for development
RUN curl -sL https://deb.nodesource.com/setup_16.x | bash - \
    && apt-get install nodejs -y \
    && npm install -g grunt-cli

# Grunt uses Magento 2 CLI commands. Need to install it for development
RUN curl -sL https://deb.nodesource.com/setup_15.x | bash - \
    && apt-get install nodejs -y \
    && npm install -g grunt-cli

# Install mhsendmail - Sendmail replacement for Mailhog
RUN curl -sL https://github.com/mailhog/mhsendmail/releases/download/v0.2.0/mhsendmail_linux_amd64 --output /usr/bin/mhsendmail ; \
    chmod +x /usr/bin/mhsendmail ; \
    echo 'sendmail_path="/usr/bin/mhsendmail --smtp-addr=mailhog:1025"' >> /usr/local/etc/php/conf.d/docker-php-xxx-custom.ini