#!/usr/bin/env bash

set -e

# double check the db is go to accept connections before you do operations
until pg_isready -h database | grep -q 'accepting connections';
do
  echo "Waiting for Postgres to accept connections..."
  sleep 2
done

if [[ ${APP_TARGET} == 'dev' ]]; then
  # edit the bashrc here since guessing the correct place on the filesystem is a pita
  cat <<- EOF >> "$HOME"/.bashrc
  # injecting the intended hostname into docker is hard. fake it instead
  HOST=\${COMPOSE_LOCAL_PWD##*/}

  # colorize terminal prefix and add git branch if possible; from: https://medium.com/@thucnc/how-to-show-current-git-branch-with-colors-in-bash-prompt-380d05a24745
  parse_git_branch() {
       git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
  }

  # color codes from: https://en.wikipedia.org/wiki/ANSI_escape_code#Colors
  export PS1="\[\033[1;35m\]\u\[\033[1;94m\]@\[\033[1;35m\]\${HOST}\[\033[0;36m\]:\w\[\033[33m\] \$(parse_git_branch)\[\033[00m\] $ "
EOF

  # empty the db then populate with migration data
  python manage.py flush --no-input
  python manage.py migrate

  # create a simple superuser
  echo "from django.contrib.auth import get_user_model; User = get_user_model(); User.objects.create_superuser('admin', 'admin@breakfast.coffee', 'password')" | python manage.py shell

  # copy the ssh keys into the right place
  mkdir ~/.ssh
  find /usr/local/machine/.ssh -type f -name "*" ! -name "known_hosts" ! -name "authorized_keys" -exec mv -t ~/.ssh {} +
  touch ~/.ssh/known_hosts ~/.ssh/authorized_keys

  # give the ssh keys the right permissions
  chmod 600 ~/.ssh/*
  chmod 644 ~/.ssh/*.pub
  chmod 700 ~/.ssh
  chmod 644 ~/.ssh/authorized_keys
  chmod 644 ~/.ssh/known_hosts
  chmod 644 ~/.ssh/config # TODO: this file can cause headaches if something specific to the local machine exists. add in a check.
fi

exec "$@"

