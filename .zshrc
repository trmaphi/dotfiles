# If not running interactively, don't do anything
case $- in
  *i*) ;;
    *) return;;
esac

setopt INTERACTIVECOMMENTS          # Support comments in interactive session
export SHELL=$(which zsh);          # Configure exe path of zsh
export LESS="-R"                    # Configure less pager
export DOTFILES="$HOME/dotfiles";   # Dotfiles path
export LC_ALL=en_US.UTF-8

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

# ZSH configs
source "$HOME/.zsh/.functions.zsh"
export BREW_PREFIX=$(brew --prefix)       # Homebrew prefix PATH

# Load Homebrew ZSH site-functions
if command -v brew &>/dev/null; then
  export FPATH="$BREW_PREFIX/share/zsh/site-functions:$FPATH"
  export FPATH="$BREW_PREFIX/share/zsh-completions:$FPATH"
  chmod go-w "$BREW_PREFIX/share"
  [ -e "/usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ] &&
  source "/usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh";
fi

export FPATH="$HOME/.zsh/completions:$FPATH"

# Load ZSH completions
autoload -Uz compinit
rm -f $HOME/.zcompdump; compinit

# Load ZSH prompts
autoload -U promptinit; promptinit

## History file configuration
[ -z "$HISTFILE" ] && HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=10000

## History command configuration
setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY               # Don't execute immediately upon history expansion.
setopt HIST_BEEP                 # Beep when accessing nonexistent history.

# ZSH prompt config
source "$HOME/.zsh/prompt.sh"