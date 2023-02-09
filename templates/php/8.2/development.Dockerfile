FROM defaultvalue/php:8.2-production

RUN cat /usr/local/etc/php/php.ini-development > /usr/local/etc/php/php.ini

RUN pecl install xdebug-3.2.0 ; \
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
RUN curl -sL https://deb.nodesource.com/setup_18.x | bash - ; \
    apt-get install nodejs -y ; \
    npm install -g grunt-cli ; \
    npm config set legacy-peer-deps=true

# Install mhsendmail - Sendmail replacement for Mailhog
RUN curl -sL https://github.com/devilbox/mhsendmail/releases/download/v0.3.0/mhsendmail_linux_amd64 --output /usr/bin/mhsendmail ; \
    chmod +x /usr/bin/mhsendmail ; \
    echo 'sendmail_path="/usr/bin/mhsendmail -t --smtp-addr=mailhog:1025"' >> /usr/local/etc/php/conf.d/docker-php-xxx-custom.ini