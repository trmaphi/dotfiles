# If not running interactively, don't do anything
case $- in
  *i*) ;;
    *) return;;
esac

export SHELL=$(which bash);             # Configure exe path of zsh
export DOTFILES="${HOME}/dotfiles";     # Dotfiles path

# Missing paths
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$PATH"
export PATH="/usr/local/opt/python/libexec/bin:$PATH"
export PATH="/usr/local/opt/findutils/libexec/gnubin:$PATH"
export PATH="/usr/local/opt/grep/libexec/gnubin:$PATH"
export PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"
export PATH="$HOME/.bin:$PATH"

source "$HOME/.aliases"                   # Load aliases
source "$HOME/.functions.sh"              # Load functions
source "$HOME/.langsrc.sh"                # Load language specific config
source "$HOME/.private.config.sh";        # Load private config

# BASH configs
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

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

# History config
HISTSIZE=10000                                      # Save 5,000 lines of history in memory
HISTFILESIZE=2000000                                # Save 2,000,000 lines of history to disk (will have to grep ~/.bash_history for full listing)
HISTCONTROL=ignoreboth                              # Ignore redundant or space commands
HISTIGNORE='ls:ll:ls -alh:pwd:clear:history'        # Ignore more
HISTTIMEFORMAT='%F %T '                             # Set time format
shopt -s cmdhist                                    # Multiple commands on one line show up as a single line
shopt -s histappend                                 # Append to history instead of overwrite