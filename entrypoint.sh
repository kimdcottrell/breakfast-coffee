#!/bin/sh

pip install -r /usr/src/requirements/development-override.txt 2> /dev/null || pip install -r /usr/src/requirements/development.txt

#if [ "$DATABASE_ENGINE" = "django.db.backends.postgresql" ]
#then
#    echo "Waiting for postgres..."
#
#    while ! nc -z "$DATABASE_HOST" "$DATABASE_HOST"; do
#      sleep 0.1
#    done
#
#    echo "PostgreSQL started"
#fi

python manage.py flush --no-input
python manage.py migrate

exec "$@"