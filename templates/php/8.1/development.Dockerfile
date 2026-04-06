FROM defaultvalue/php:8.1.34-production

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN cat /usr/local/etc/php/php.ini-development > /usr/local/etc/php/php.ini

RUN pecl install xdebug-3.2.2 \
    && docker-php-ext-enable xdebug \
    && printf 'xdebug.mode=debug\n\
xdebug.remote_handler=dbgp\n\
xdebug.discover_client_host=0\n\
xdebug.show_error_trace=1\n\
xdebug.start_with_request=yes\n\
xdebug.max_nesting_level=256\n\
xdebug.log_level=0\n\
xdebug.client_host=host.docker.internal\n' >> /usr/local/etc/php/conf.d/docker-php-xxx-custom.ini

# Grunt uses Magento 2 CLI commands. Need to install it for development
# Node 16 is EOL and unavailable via nodesource repos, installing from official binary
RUN ARCH=$(dpkg --print-architecture) \
    && if [ "$ARCH" = "amd64" ]; then NODEARCH="x64"; else NODEARCH="arm64"; fi \
    && curl -fsSL "https://nodejs.org/dist/v16.20.2/node-v16.20.2-linux-${NODEARCH}.tar.xz" | tar -xJ -C /usr/local --strip-components=1 \
    && npm install -g grunt-cli@1.4.3 \
    && npm config set legacy-peer-deps=true

# Install mhsendmail - Sendmail replacement for Mailhog
RUN ARCH=$(dpkg --print-architecture) \
    && curl -sL "https://github.com/devilbox/mhsendmail/releases/download/v0.3.0/mhsendmail_linux_${ARCH}" --output /usr/bin/mhsendmail \
    && chmod +x /usr/bin/mhsendmail \
    && echo 'sendmail_path="/usr/bin/mhsendmail -t --smtp-addr=mailhog:1025"' >> /usr/local/etc/php/conf.d/docker-php-xxx-custom.ini

RUN rm -rf /tmp/pear/
