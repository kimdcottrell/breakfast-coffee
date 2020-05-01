#!/bin/sh

pip install -r /var/www/requirements/development-override.txt 2> /dev/null || pip install -r /var/www/requirements/development.txt

#if [ "$DATABASE" = "postgres" ]
#then
#    echo "Waiting for postgres..."
#
#    while ! nc -z "$SQL_HOST" "$SQL_PORT"; do
#      sleep 0.1
#    done
#
#    echo "PostgreSQL started"
#fi

python manage.py flush --no-input
python manage.py migrate

exec "$@"