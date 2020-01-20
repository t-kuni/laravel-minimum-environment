FROM nginx:1.14.2-alpine

# Add packages
RUN apk update \
    && apk add --no-cache --virtual build-tools gettext

# Copy configs
COPY default.conf.template /etc/nginx/conf.d/default.conf.template
COPY site.conf.template    /etc/nginx/conf.d/site.conf.template
COPY nginx.conf            /etc/nginx/nginx.conf

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

WORKDIR /var/www/app
CMD exec nginx -g 'daemon off;'