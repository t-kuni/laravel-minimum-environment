FROM php:7.3.0-fpm-alpine3.8 AS app-base

#
# Install packages
#
RUN apk update \
    && apk add openssl libpng openssl-dev \
        freetype libpng libjpeg-turbo freetype-dev libpng-dev libjpeg-turbo-dev libzip-dev \
    && apk add --no-cache --virtual build-tools autoconf automake libtool gcc libc-dev lcms2-dev nasm make
RUN docker-php-ext-configure gd \
        --with-gd \
        --with-freetype-dir=/usr/include/ \
        --with-png-dir=/usr/include/ \
        --with-jpeg-dir=/usr/include/
RUN docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install -j$(nproc) pdo_mysql \
    && docker-php-ext-install -j$(nproc) mysqli \
    && docker-php-ext-install -j$(nproc) mbstring \
    && docker-php-ext-install -j$(nproc) sockets \
    && docker-php-ext-install -j$(nproc) zip

# Install xdebug
RUN pecl install xdebug-2.7.2
RUN docker-php-ext-enable xdebug

# Purge build tools
RUN apk del --purge build-tools

# Install composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php --install-dir=/bin --filename=composer \
    && php -r "unlink('composer-setup.php');"

#
# Copy configs
#
COPY php-fpm.conf  /usr/local/etc/php-fpm.conf
COPY www.conf      /usr/local/etc/php-fpm.d/www.conf
COPY php.local.ini /usr/local/etc/php/php.ini
COPY crontab       /etc/crontabs/app

# Add user
ARG APP_UID
ARG APP_GID
ENV APP_UID ${APP_UID}
ENV APP_GID ${APP_GID}
RUN adduser -u $APP_UID -g $APP_GID --disabled-password --gecos "" -s /sbin/nologin app

USER app
WORKDIR /var/www/app
CMD ["php-fpm"]
