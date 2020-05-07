#!/usr/bin/env bash

# bail out of here if we're already done this stuff before
# TODO: find a way to test this
echo 'Doing bail check for dev-post-build-up...'
grep -Pzoq "parse_git_branch" "$HOME"/.bashrc && return
echo 'Continuing dev-post-build-up...'

edit_bashrc(){
  echo 'Running edit_bashrc()'
  # edit the bashrc here since guessing the correct place on the filesystem is a pita
  cat << EOF >> "$HOME"/.bashrc

# injecting the intended hostname into docker is hard. fake it instead
HOST=\${COMPOSE_LOCAL_PWD##*/}

# colorize terminal prefix and add git branch if possible; from: https://medium.com/@thucnc/how-to-show-current-git-branch-with-colors-in-bash-prompt-380d05a24745
parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

# color codes from: https://en.wikipedia.org/wiki/ANSI_escape_code#Colors
export PS1="\[\033[1;35m\]\u\[\033[1;94m\]@\[\033[1;35m\]\${HOST}\[\033[0;36m\]:\w\[\033[33m\] \$(parse_git_branch)\[\033[00m\] $ "
EOF
}

create_bash_profile(){
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
  find /usr/local/machine/.ssh -type f -name "*" ! -name "known_hosts" ! -name "authorized_keys" -exec cp "{}" ~/.ssh \;
  touch ~/.ssh/known_hosts ~/.ssh/authorized_keys

  # give the ssh keys the right permissions
  chmod 600 ~/.ssh/*
  chmod 644 ~/.ssh/*.pub
  chmod 700 ~/.ssh
  chmod 644 ~/.ssh/authorized_keys
  chmod 644 ~/.ssh/known_hosts
  chmod 644 ~/.ssh/config # TODO: this file can cause headaches if something specific to the local machine exists. add in a check.
}

create_bash_profile
edit_bashrc
empty_db_and_create_tables
create_admin_password_superuser
setup_ssh_keys