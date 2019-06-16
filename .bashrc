### Bash-it configuration
# If not running interactively, don't do anything
case $- in
  *i*) ;;
    *) return;;
esac

export SHELL=$(which bash);

# Dotfiles path
export DOTFILES="${HOME}/dotfiles";

# Load functions
source "${HOME}/.functions"

# Set GO_PATH environment variable
export GOPATH=$(go env GOPATH)

# Set NVM home and load nvm
export NVM_DIR="${HOME}/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion" ] && . "/usr/local/opt/nvm/etc/bash_completion"  # This loads nvm bash_completion

# Load completions
for FILE in ${HOME}/.completions.d/*.completion.bash; do 
  source $FILE
done

# Load custom aliases
source "${HOME}/.aliases"

# Depot_tools path
export PATH=$PATH:${HOME}/Projects/depot_tools

if [ "${HOSTNAME}" = "Lecle-VN-phi.local" ]; then
  source "${HOME}/.config.work";
fi

source "${HOME}/.prompt.sh"
