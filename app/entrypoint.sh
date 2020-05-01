#!/bin/sh

pip install -r requirements/development-override.txt 2> /dev/null || pip install -r requirements/development.txt

# TODO: add in postgres status check that sleeps this script until ready

python manage.py flush --no-input
python manage.py migrate

exec "$@"