# breakfast.coffee: a nerd blog. 

Coming soon.

## Sample .env

```
######################
# environment config #
######################
APP_TARGET=dev
NODE_VERSION=12.16.3
# major version only
POSTGRES_VERSION=12


######################
# application config #
######################
DEBUG=True
SECRET_KEY=super-secret-007
DJANGO_ALLOWED_HOSTS=localhost 127.0.0.1 [::1]
DATABASE_POSTGRES_SUPERUSER=postgres
DATABASE_POSTGRES_SUPERPASS=postgres
DATABASE_POSTGRES_DB_NAME=postgres
DATABASE_URL=postgresql://cool_db_user:cool_db_pass@database:5432/cool_db_name
```

## Creating an optional `./docker-compose.override.yml`

```yaml
version: '3.7'

services:
  project:
    volumes:
      - .:/usr/src
      # add more volumes here if needed
```

## Common issues

### PyCharm

#### Error: Couldn't refresh skeletons for remote interpreter

**Context**

The Python Console throws an error regarding the pycharm helpers.

**Solution**

Delete the pycharm helpers containers `docker rm -f $(docker ps -a | grep pycharm_helper | awk '{print $1};')`

Then restart pycharm using `File` -> `Invalidate Caches & Restart`.
