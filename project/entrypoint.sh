#!/usr/bin/env bash

# double check the db is go to accept connections before you do operations
until pg_isready -h database | grep -q 'accepting connections';
do
  echo "Waiting for Postgres to accept connections..."
  sleep 2
done

# run migrations here since the database container needs to be running
python manage.py flush --no-input
python manage.py migrate

#
echo "from django.contrib.auth import get_user_model;" \
  "User = get_user_model();" \
  "User.objects.create_superuser('admin', 'admin@breakfast.coffee', 'password')" \
  | python manage.py shell

exec "$@"

