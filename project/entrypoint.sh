#!/usr/bin/env bash

# install the version of node defined in the project
source "$NVM_DIR"/nvm.sh
nvm install

# double check the db is go to accept connections before you do operations
until pg_isready -h database | grep -q 'accepting connections';
do
  echo "Waiting for Postgres to accept connections..."
  sleep 2
done

if [[ ${APP_TARGET} == 'dev' ]]; then
  bash dev-post-build-up.sh
fi



exec "$@"

