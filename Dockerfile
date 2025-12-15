FROM mautic/mautic:latest

ARG MAUTIC_DB_HOST
ARG MAUTIC_DB_PORT
ARG MAUTIC_DB_USER
ARG MAUTIC_DB_PASSWORD
ARG MAUTIC_DB_NAME
ARG MAUTIC_TRUSTED_PROXIES
ARG MAUTIC_URL
ARG MAUTIC_ADMIN_EMAIL
ARG MAUTIC_ADMIN_PASSWORD

ENV MAUTIC_DB_HOST=$MAUTIC_DB_HOST
ENV MAUTIC_DB_PORT=$MAUTIC_DB_PORT
ENV MAUTIC_DB_USER=$MAUTIC_DB_USER
ENV MAUTIC_DB_PASSWORD=$MAUTIC_DB_PASSWORD
ENV MAUTIC_DB_NAME=$MAUTIC_DB_NAME
ENV MAUTIC_TRUSTED_PROXIES=$MAUTIC_TRUSTED_PROXIES
ENV MAUTIC_URL=$MAUTIC_URL
ENV MAUTIC_ADMIN_EMAIL=$MAUTIC_ADMIN_EMAIL
ENV MAUTIC_ADMIN_PASSWORD=$MAUTIC_ADMIN_PASSWORD
ENV PHP_INI_DATE_TIMEZONE=Asia/Jerusalem
ENV PHP_INI_MEMORY_LIMIT=5000M

ENV PHP_INI_DATE_TIMEZONE=Asia/Jerusalem
ENV PHP_INI_MEMORY_LIMIT=5000M

RUN apt-get update \
    && apt-get install -y --no-install-recommends cron \
    && rm -rf /var/lib/apt/lists/*

RUN echo "memory_limit=${PHP_INI_MEMORY_LIMIT}" > /usr/local/etc/php/conf.d/mautic-memory-limit.ini

# Pick ONE of these MPM blocks (see section A)
RUN a2dismod mpm_event mpm_worker || true \
    && a2enmod mpm_prefork || true \
    && apache2ctl -M | grep mpm

COPY mautic-cron /etc/cron.d/mautic-cron
RUN chmod 0644 /etc/cron.d/mautic-cron

COPY with-cron-entrypoint.sh /with-cron-entrypoint.sh
RUN chmod +x /with-cron-entrypoint.sh

ENTRYPOINT ["/with-cron-entrypoint.sh"]
CMD ["apache2-foreground"]
