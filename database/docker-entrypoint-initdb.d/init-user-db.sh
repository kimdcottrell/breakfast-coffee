#!/bin/bash

# it's difficult/impossible to add env vars to sql, so use a bash script
psql << EOF
create user $DATABASE_DEFAULT_USER with encrypted password '$DATABASE_DEFAULT_PASSWORD';
create database $DATABASE_DEFAULT_NAME;
grant all privileges on database $DATABASE_DEFAULT_NAME TO $DATABASE_DEFAULT_USER;
EOF

