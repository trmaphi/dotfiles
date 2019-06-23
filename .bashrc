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

# Set PATH cargo
export PATH="$HOME/.cargo/bin:$PATH"

# Set NVM home and load nvm
export NVM_DIR="${HOME}/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion" ] && . "/usr/local/opt/nvm/etc/bash_completion"  # This loads nvm bash_completion

# Load completions
# Loads the system's Bash completion modules.
# If Homebrew is installed (OS X), its Bash completion modules are loaded.
if [ -f /etc/bash_completion ]; then
  . /etc/bash_completion
fi

# Some distribution makes use of a profile.d script to import completion.
if [ -f /etc/profile.d/bash_completion.sh ]; then
  . /etc/profile.d/bash_completion.sh
fi

if [ $(uname) = "Darwin" ] && command -v brew &>/dev/null ; then
  HOMEBREW_PREFIX=$(brew --prefix)

  for COMPLETION in "$HOMEBREW_PREFIX"/etc/bash_completion.d/*; do
    [[ -f $COMPLETION ]] && source "$COMPLETION"
  done
  
  if [[ -f ${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh ]]; then
    source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
  fi
fi

for CUSTOM_COMPLETION in "$HOME"/.completions.d/*; do
  [[ -f $CUSTOM_COMPLETION ]] && source "$CUSTOM_COMPLETION"
done
    
# Load custom aliases
source "${HOME}/.aliases"

# Depot_tools path
export PATH=$PATH:${HOME}/Projects/depot_tools

# Load work config
if [ "${HOSTNAME}" = "Lecle-VN-phi.local" ]; then
  source "${HOME}/.config.work";
fi

# Load prompt
source "${HOME}/.bash_prompt"

# Save 5,000 lines of history in memory
HISTSIZE=10000
# Save 2,000,000 lines of history to disk (will have to grep ~/.bash_history for full listing)
HISTFILESIZE=2000000
# Append to history instead of overwrite
shopt -s histappend
# Ignore redundant or space commands
HISTCONTROL=ignoreboth
# Ignore more
HISTIGNORE='ls:ll:ls -alh:pwd:clear:history'
# Set time format
HISTTIMEFORMAT='%F %T '
# Multiple commands on one line show up as a single line
shopt -s cmdhist
# Append new history lines, clear the history list, re-read the history list, print prompt.
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"