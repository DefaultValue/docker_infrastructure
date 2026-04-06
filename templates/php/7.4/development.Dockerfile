FROM defaultvalue/php:7.4.33.1-production

RUN cat /usr/local/etc/php/php.ini-development > /usr/local/etc/php/php.ini

RUN pecl install xdebug-2.9.8 \
    && docker-php-ext-enable xdebug \
    && echo 'xdebug.remote_enable=1\n\
xdebug.idekey="PHPSTORM"\n\
xdebug.remote_port=9000\n\
xdebug.remote_connect_back=0\n\
xdebug.remote_autostart=1\n\
xdebug.remote_host=host.docker.internal' >> /usr/local/etc/php/conf.d/docker-php-xxx-custom.ini

# Grunt uses Magento 2 CLI commands. Need to install it for development
# Node 16 is EOL and unavailable via nodesource repos, installing from official binary
# Skip Puppeteer's Chromium download - it fails on ARM and is not needed for Grunt tasks
ENV PUPPETEER_SKIP_DOWNLOAD=true
RUN ARCH=$(dpkg --print-architecture) \
    && if [ "$ARCH" = "amd64" ]; then NODEARCH="x64"; else NODEARCH="arm64"; fi \
    && curl -fsSL "https://nodejs.org/dist/v16.20.2/node-v16.20.2-linux-${NODEARCH}.tar.xz" | tar -xJ -C /usr/local --strip-components=1 \
    && npm install -g grunt-cli

# Install mhsendmail - Sendmail replacement for Mailhog
RUN curl -sL https://github.com/devilbox/mhsendmail/releases/download/v0.3.0/mhsendmail_linux_amd64 --output /usr/bin/mhsendmail \
    && chmod +x /usr/bin/mhsendmail \
    && echo 'sendmail_path="/usr/bin/mhsendmail -t --smtp-addr=mailhog:1025"' >> /usr/local/etc/php/conf.d/docker-php-xxx-custom.ini

RUN rm -rf /tmp/pear/