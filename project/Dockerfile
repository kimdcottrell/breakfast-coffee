############
#   BASE   #
############
# pull image from the Debian official base
FROM python:3.8-buster as base
LABEL maintainer="kimdcottrell"

# prevents Python from writing pyc files to disc
ENV PYTHONDONTWRITEBYTECODE 1
# prevents Python from buffering stdout and stderr
ENV PYTHONUNBUFFERED 1

# replace shell with bash so we can source files and use arrays since POSIX doesn't allow for either
SHELL ["/bin/bash", "-c"]

RUN DEPENDENT_PACKAGES=( \
    # dependencies for building Python packages \
        build-essential \
    # psycopg2 dependencies \
        libpq-dev \
        gcc \
    # Translations dependencies \
        gettext \
    ) \
    && apt-get update \
    # dependencies for building Python packages and doing basic terminal operations
    && apt-get install -y ${DEPENDENT_PACKAGES[@]} --no-install-recommends

# setup locales to run properly with en_US.UTF-8
ENV LC_ALL=C.UTF-8

# configure non-privledged user for django
RUN mkdir /var/www/ \
    && chown -R www-data /usr/src/ /var/www/
USER www-data

# copy the project dir in so we can run the ./manage.py scripts
COPY --chown=www-data:www-data ./project /usr/src/project

# it is not recommended to put django files in /var/www - https://docs.djangoproject.com/en/3.0/intro/tutorial01/#console-block-1
WORKDIR /usr/src/project

# update pip to the latest version
RUN pip install --upgrade pip

# `pip install --user` will install things in the user's .local/bin dir, so you need to add the dir to the $PATH
ENV PATH="/home/www-data/.local/bin:${PATH}"

#############
#   LOCAL   #
#############
FROM base as dev

# doing this since Dockerfiles don't like to accept vars from docker-compose's env_file
ARG postgres_version

USER root

# make it possible to get the correct version of the postgres-client
ENV POSTGRES_VERSION $postgres_version
RUN mkdir -p /etc/apt/sources.list.d \
    && touch /etc/apt/sources.list.d/pgdg.list \
    && echo "deb http://apt.postgresql.org/pub/repos/apt/ buster-pgdg main" > /etc/apt/sources.list.d/pgdg.list \
    && wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -

RUN DEPENDENT_PACKAGES=( \
    # Django dbshell dependencies \
        postgresql-client-${POSTGRES_VERSION} \
    ) \
    && apt-get update \
    # dependencies for building Python packages and doing basic terminal operations
    && apt-get install -y ${DEPENDENT_PACKAGES[@]} \
    # cleaning up unused files \
    && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
    && rm -rf /var/lib/apt/lists/*

USER www-data

# install python packages, with a developer-override if someone wants to override the existing developer.txt requirements
RUN pip install --no-cache -r requirements/development-override.txt 2> /dev/null || pip install --no-cache -r requirements/development.txt

ENTRYPOINT ["/usr/src/project/entrypoint.sh"]

CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]

#############
#   TEST   #
#############
FROM base as tests
RUN pip install -r requirements/tests.txt
RUN python manage.py test

#############
#   BUILD   #
#############
FROM tests as build
RUN pip install -r requirements/build.txt

# there is no good way to copy env_file vars into a Dockerfile, so here's a workaround
COPY .env .env
RUN set -exa \
    && source .env \
    && python manage.py collectstatic --noinput

ENTRYPOINT ["/usr/src/project/entrypoint.sh"]
CMD ["gunicorn", "project.wsgi:application", "--bind", "0.0.0.0:8000"]