FROM nginx:1.14.2-alpine

# Add packages
RUN apk update \
    && apk add --no-cache --virtual build-tools gettext

# Copy configs
COPY default.conf.template /etc/nginx/conf.d/default.conf.template
COPY site.conf.template /etc/nginx/conf.d/site.conf.template
COPY nginx.conf /etc/nginx/nginx.conf

# Build configs
ARG HOST
ARG DOLLAR
ARG SSL_CERT_PATH
ARG SSL_CERT_KEY_PATH
ENV HOST ${HOST}
ENV DOLLAR ${DOLLAR}
ENV SSL_CERT_PATH ${SSL_CERT_PATH}
ENV SSL_CERT_KEY_PATH ${SSL_CERT_KEY_PATH}
RUN /usr/bin/envsubst < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf \
      && /usr/bin/envsubst < /etc/nginx/conf.d/site.conf.template > /etc/nginx/conf.d/site.conf

# Purge packages.
RUN apk del --purge build-tools

# Add user
ARG APP_UID
ARG APP_GID
ENV APP_UID ${APP_UID}
ENV APP_GID ${APP_GID}
RUN adduser -u $APP_UID -g $APP_GID --disabled-password --gecos "" -s /sbin/nologin app

RUN mkdir -p /var/www/app/storage/app/public \
    && mkdir -p /var/www/app/public/storage
RUN ln -s /var/www/app/storage/app/public /var/www/app/public/storage

CMD exec nginx -g 'daemon off;'