#!/usr/bin/env bash

# allow for devs to easily swap the node/npm version by changing the .nvmrc and restarting
source "$NVM_DIR"/nvm.sh

# double check the db is go to accept connections before you do operations
until pg_isready -h database | grep -q 'accepting connections';
do
  echo "Waiting for Postgres to accept connections..."
  sleep 2
done

if [[ ${APP_TARGET} == 'dev' ]]; then
  bash dev-post-build-up.sh
  source "$HOME"/.bashrc
fi

exec "$@"

