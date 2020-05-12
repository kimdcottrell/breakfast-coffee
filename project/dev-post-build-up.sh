#!/usr/bin/env bash

# bail out of here if we're already done this stuff before
# TODO: find a way to test this
echo 'Doing bail check for dev-post-build-up...'
grep -Pzoq "parse_git_branch" "$HOME"/.bashrc && return
echo 'Continuing dev-post-build-up...'

create_bash_profile(){
  echo 'Running create_bash_profile()'
  touch "$HOME"/.bash_profile
  echo "[ -f $HOME/.bashrc ] && . $HOME/.bashrc" > "$HOME"/.bash_profile
  source "$HOME"/.bash_profile
}

empty_db_and_create_tables(){
  echo 'Running empty_db_and_create_tables()'
  python manage.py flush --no-input
  python manage.py migrate
}


create_admin_password_superuser(){
  echo 'Running create_admin_password_superuser()'
  echo "from django.contrib.auth import get_user_model; User = get_user_model(); User.objects.create_superuser('admin', 'admin@breakfast.coffee', 'password')" | python manage.py shell
}

setup_ssh_keys(){
  echo 'Running setup_ssh_keys()'
  # copy the ssh keys into the right place
  mkdir ~/.ssh
  find /usr/local/machine/.ssh -type f -name "*" ! -name "known_hosts" ! -name "authorized_keys" -exec cp {} ~/.ssh \;
  touch ~/.ssh/known_hosts ~/.ssh/authorized_keys

  # give the ssh keys the right permissions
  chmod 600 ~/.ssh/*
  chmod 644 ~/.ssh/*.pub
  chmod 700 ~/.ssh
  chmod 644 ~/.ssh/authorized_keys
  chmod 644 ~/.ssh/known_hosts
  chmod 644 ~/.ssh/config # TODO: this file can cause headaches if something specific to the local machine exists. add in a check.

  # now tell github that we cool. assumes id_rsa does not have a password
  ssh -o StrictHostKeyChecking=no -T git@github.com
}

setup_ssh_keys
create_bash_profile
empty_db_and_create_tables
create_admin_password_superuser
