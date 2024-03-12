ARG CADDY_VERSION=2
ARG PHP_VERSION=8
ARG PHP_EXTENSIONS=
ARG PHP_DEV_EXTENSIONS=
ARG COMPOSER_VERSION=lts
ARG NODE_VERSION=18

###############################################################################
### [STAGE] composer
###############################################################################
FROM composer:$COMPOSER_VERSION as composer

###############################################################################
# [STAGE] php-dev
###############################################################################
FROM symfonysail/php-dev:$PHP_VERSION AS php-dev
SHELL ["/bin/bash", "-euxo", "pipefail", "-c"]

ARG PHP_EXTENSIONS
ARG PHP_DEV_EXTENSIONS
ARG NODE_VERSION

# Copy composer binary
COPY --link --from=composer /usr/bin/composer /usr/local/bin/

RUN \
    # Install PHP extensions
    EXTENSIONS=$(echo "$PHP_EXTENSIONS $PHP_DEV_EXTENSIONS" | sed 's/,/ /g; s/[[:space:]]\{2,\}/ /g; s/^[[:space:]]*//g; s/[[:space:]]*$//g;'); \
    if [ -n "$EXTENSIONS" ]; then \
        install-php-extensions $EXTENSIONS; \
    fi; \
    # Install Node.js, update npm and install Yarm
    if [ "$NODE_VERSION" -le 16 ]; then \
        mkdir -p /etc/apt/keyrings; \
        echo "Package: nodejs" >> /etc/apt/preferences.d/nodejs; \
        echo "Pin: origin deb.nodesource.com" >> /etc/apt/preferences.d/nodejs; \
        echo "Pin-Priority: 1001" >> /etc/apt/preferences.d/nodejs; \
        curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg; \
        echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_VERSION.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list; \
        apt-get update; \
    else \
        curl -fsSL "https://deb.nodesource.com/setup_$NODE_VERSION.x" | bash -; \
    fi; \
    apt-get install -y --no-install-recommends nodejs; \
    npm install -g yarn; \
    # Cleanup
    rm -rf /root/.npm; \
    rm -rf /var/lib/apt/lists/*

###############################################################################
# [STAGE] caddy-dev
###############################################################################
FROM symfonysail/caddy-base:$CADDY_VERSION as caddy-dev
SHELL ["/bin/ash", "-euxo", "pipefail", "-c"]
