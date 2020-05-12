# breakfast.coffee: a nerd blog. 

Coming soon.

## Sample .env

```
######################
# environment config #
######################
APP_VERSION=38-buster
APP_TARGET=dev
NODE_VERSION=12.16.3
# major version only
POSTGRES_VERSION=12


######################
# application config #
######################
DEBUG=True
SECRET_KEY=super-secret-007
DJANGO_ALLOWED_HOSTS=localhost 127.0.0.1 [::1]
DATABASE_POSTGRES_SUPERUSER=postgres
DATABASE_POSTGRES_SUPERPASS=postgres
DATABASE_POSTGRES_DB_NAME=postgres
DATABASE_URL=postgresql://cool_db_user:cool_db_pass@database:5432/cool_db_name
```

## Editing the container terminal prompt

The project container runs via a bash shell. The [bash-git-prompt](https://github.com/magicmonty/bash-git-prompt) package has been installed, incase you'd like to modify the `$PS1` to be significantly more informational.

### Setup of bash-git-prompt

By default, `docker-compose up`/`make up` will start both the `docker-compose.yml` and `docker-compose.override.yml` files. 

#### Create a `docker-compose.override.yml`

```yaml
version: '3.7'

services:
  project:
    volumes:
      - .:/usr/src
      - ~/.ssh:/usr/local/machine/.ssh
      - ./project/.bashrc:/root/.bashrc
      - ./project/.git-prompt-colors.sh:/root/.git-prompt-colors.sh
```

#### Create a `project/.bashrc`

```bash
force_color_prompt=yes

# injecting the intended hostname into docker is hard. fake it instead
HOST=${COMPOSE_LOCAL_PWD##*/}

if [ -f "/usr/prompt/gitprompt.sh" ]; then
    GIT_PROMPT_ONLY_IN_REPO=1
    GIT_PROMPT_THEME=Custom
    source /usr/prompt/gitprompt.sh
fi
```

#### Create a `.git-prompt-colors.sh` 

This file is based off the [Custom template](https://github.com/magicmonty/bash-git-prompt/blob/master/themes/Custom.bgptemplate)

```bash
  GIT_PROMPT_PREFIX="("   # start of the git info string
  GIT_PROMPT_SUFFIX=")"   # the end of the git info string
  GIT_PROMPT_BRANCH="${Yellow}"        # the git branch that is active in the current directory
  GIT_PROMPT_MASTER_BRANCH="${GIT_PROMPT_BRANCH}" # used if the git branch that is active in the current directory is $GIT_PROMPT_MASTER_BRANCHES
  GIT_PROMPT_STAGED="${Magenta}●"          # the number of staged files/directories
  GIT_PROMPT_CONFLICTS="${BoldRed}✖"    # the number of files in conflict
  GIT_PROMPT_CHANGED="${BrightRed}✚"         # the number of changed files
  GIT_PROMPT_UNTRACKED="${BrightRed}…"       # the number of untracked files/dirs
  GIT_PROMPT_STASHED="${Magenta}⚑"      # the number of stashed files/dir
  GIT_PROMPT_CLEAN="${BoldGreen}✔"      # a colored flag indicating a "clean" repo
  GIT_PROMPT_SYMBOLS_NO_REMOTE_TRACKING="⭑"   # This symbol is written after the branch, if the branch is not tracked
  GIT_PROMPT_START_USER="_LAST_COMMAND_INDICATOR_ ${BoldMagenta}${BoldMagenta}${HOST}:${Cyan}\w${ResetColor}"
  GIT_PROMPT_START_ROOT="_LAST_COMMAND_INDICATOR_ ${BoldMagenta}${BoldMagenta}${HOST}:${Cyan}\w${ResetColor}"
  GIT_PROMPT_END_USER="${ResetColor} $ "
  GIT_PROMPT_END_ROOT="${ResetColor} # "
}

reload_git_prompt_colors "Custom"
```

#### Final steps

Run `make restart` and `make shell`. You should see a prettier, more informational, shell, like this:

```bash
✔ breakfast-coffee:/usr/src/project (master|✚1…2) # 
```

## Common issues

### PyCharm

#### Error: Couldn't refresh skeletons for remote interpreter

**Context**

The Python Console throws an error regarding the pycharm helpers.

**Solution**

Delete the pycharm helpers containers `docker rm -f $(docker ps -a | grep pycharm_helper | awk '{print $1};')`

Then restart pycharm using `File` -> `Invalidate Caches & Restart`.
