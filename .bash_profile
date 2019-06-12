### Bash-it configuration
# If not running interactively, don't do anything
case $- in
  *i*) ;;
    *) return;;
esac

# bash-it path
export BASH_IT="${HOME}/.bash_it"

# Lock and Load a custom theme file.
# Leave empty to disable theming.
# location /.bash_it/themes/
export BASH_IT_THEME='minimal'

# Don't check mail when opening terminal.
unset MAILCHECK

# Set this to false to turn off version control status checking within the prompt for all themes
export SCM_CHECK=true

# Load Bash-it
source "${BASH_IT}"/bash_it.sh

# dotfiles path
export DOT_FILES_PATH="${HOME}/dotfiles"
# Load functions
source "${DOT_FILES_PATH}"/functions/set-local-git-config.sh
source "${DOT_FILES_PATH}"/functions/load-docker-toolbox.bash

# Set GO_PATH environment variable
export GOPATH=$(go env GOPATH)

# Set NVM home and load nvm
export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion" ] && . "/usr/local/opt/nvm/etc/bash_completion"  # This loads nvm bash_completion

##### ALIASES
alias bat:json='bat --theme=TwoDark'
alias jid='jest --runInBand --detectOpenHandles'
alias jidl='jest --runInBand --detectOpenHandles --lastCommit '
alias dsls='SLS_DEBUG=*'
alias heap='NODE_OPTIONS=--max-old-space-size=8192'

# Depot_tools path
export PATH=$PATH:${HOME}/Projects/depot_tools
