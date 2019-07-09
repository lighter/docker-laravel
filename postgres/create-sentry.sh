#!/bin/bash
set -e

POSTGRES="psql --username postgres"

echo "Creating database: ${SENTRY_DB}"

$POSTGRES <<EOSQL
CREATE DATABASE "${SENTRY_DB}" OWNER "${POSTGRES_USER}";
EOSQL