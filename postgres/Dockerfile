FROM postgres:9.6.3

COPY ./create-sentry.sh /docker-entrypoint-initdb.d/10-create-sentry.sh

RUN chmod +x /docker-entrypoint-initdb.d/10-create-sentry.sh