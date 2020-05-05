#!/usr/bin/env bash

set -e

# double check the db is go to accept connections before you do operations
until pg_isready -h database | grep -q 'accepting connections';
do
  echo "Waiting for Postgres to accept connections..."
  sleep 2
done

python manage.py flush --no-input
python manage.py migrate

exec "$@"

