#!/bin/bash

# parse the DATABASE_URL in the most overly simplistic way ever...
read USER PASS NAME <<< $(echo "$DATABASE_URL" | awk -F'[/:@]' '{ print $4" "$5" "$8}')

# it's difficult/impossible to add env vars to sql, so use a bash script
psql << EOF
create user $USER with encrypted password '$PASS';
create database $NAME;
grant all privileges on database $NAME TO $USER;
EOF

