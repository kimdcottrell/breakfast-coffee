# breakfast.coffee: a nerd blog. 

Coming soon.

## .env

### APP_COMMAND

dev

`python manage.py runserver 0.0.0.0:8000`

prod

`gunicorn project.wsgi:application --bind 0.0.0.0:8000`

## PyCharm

### Common Issues

#### Error: Couldn't refresh skeletons for remote interpreter

**Context**

The Python Console throws an error regarding the pycharm helpers.

**Solution**

Delete the pycharm helpers containers `docker rm -f $(docker ps -a | grep pycharm_helper | awk '{print $1};')`

Then restart pycharm using `File` -> `Invalidate Caches & Restart`.
