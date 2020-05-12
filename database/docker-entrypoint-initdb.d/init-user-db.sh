#!/bin/bash

# parse the DATABASE_URL in the most overly simplistic way ever...
read USER PASS NAME <<< $(echo "$DATABASE_URL" | awk -F'[/:@]' '{ print $4" "$5" "$8}')

# it's difficult/impossible to add env vars to sql, so use a bash script
psql << EOF
-- setup the django project's user, db, and correct pass
create user $USER with encrypted password '$PASS';
create database $NAME;

-- swap the database from being owned by postgres to the django project user
grant all privileges on database $NAME TO $USER;

-- give the django project user the ability to create (and therefore, own) the test_${NAME} db
alter user $USER createdb;
EOF

