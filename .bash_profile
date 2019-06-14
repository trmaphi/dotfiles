### Bash-it configuration

# bash-it path
export BASH_IT="${HOME}/.bash_it"

# location /.bash_it/themes/
export BASH_IT_THEME='minimal'

# Don't check mail when opening terminal.
unset MAILCHECK

# Set this to false to turn off version control status checking within the prompt for all themes
export SCM_CHECK=true

# Load Bash-it
source "${BASH_IT}"/bash_it.sh

# Load functions
source "${HOME}/.functions"

# Set GO_PATH environment variable
export GOPATH=$(go env GOPATH)

# Set NVM home and load nvm
export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion" ] && . "/usr/local/opt/nvm/etc/bash_completion"  # This loads nvm bash_completion

##### ALIASES
source "${HOME}/.aliases"

# Depot_tools path
export PATH=$PATH:${HOME}/Projects/depot_tools
