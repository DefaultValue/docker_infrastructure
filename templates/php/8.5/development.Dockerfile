FROM defaultvalue/php:8.5.4-production

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN cat /usr/local/etc/php/php.ini-development > /usr/local/etc/php/php.ini

RUN pecl install xdebug-3.5.1 \
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
# https://github.com/nodesource/distributions?tab=readme-ov-file#nodejs
RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates curl gnupg \
    && mkdir -p /etc/apt/keyrings \
    && curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg \
    && NODE_MAJOR=24 \
    && echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends nodejs \
    && npm install -g grunt-cli@1.4.3 \
    && npm config set legacy-peer-deps=true \
    && rm -rf /var/lib/apt/lists/*

# Install mhsendmail - Sendmail replacement for Mailhog
RUN ARCH=$(dpkg --print-architecture) \
    && curl -sL "https://github.com/devilbox/mhsendmail/releases/download/v0.3.0/mhsendmail_linux_${ARCH}" --output /usr/bin/mhsendmail \
    && chmod +x /usr/bin/mhsendmail \
    && echo 'sendmail_path="/usr/bin/mhsendmail -t --smtp-addr=mailhog:1025"' >> /usr/local/etc/php/conf.d/docker-php-xxx-custom.ini

RUN rm -rf /tmp/pear/
