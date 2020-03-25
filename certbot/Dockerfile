FROM certbot/certbot:v0.38.0

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT  ["/entrypoint.sh"]