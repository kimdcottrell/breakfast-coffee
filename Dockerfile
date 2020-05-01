# pull image from the Debian official base
FROM python:3.8-buster

# it is not recommended to put django files in /var/www - https://docs.djangoproject.com/en/3.0/intro/tutorial01/#console-block-1
WORKDIR /usr/src/app

# prevents Python from writing pyc files to disc
ENV PYTHONDONTWRITEBYTECODE 1
# prevents Python from buffering stdout and stderr
ENV PYTHONUNBUFFERED 1

# install psycopg2 dependencies
RUN apt-get update \
    && apt-get install -y \
        libpq-dev \
        gcc \
    && apt-get autoremove -y \
    && apt-get clean

######
# TODO: fix how everything runs as root
# https://medium.com/@DahlitzF/run-python-applications-as-non-root-user-in-docker-containers-by-example-cba46a0ff384
# https://github.com/lando/lando/blob/master/plugins/lando-core/scripts/user-perms.sh
######
RUN pip install --upgrade pip

# run entrypoint.sh
ENTRYPOINT ["/usr/src/entrypoint.sh"]