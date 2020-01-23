# If not running interactively, don't do anything
case $- in
  *i*) ;;
    *) return;;
esac

setopt INTERACTIVECOMMENTS          # Support comments in interactive session

. "$HOME/.aliases"                   # Load aliases
. "$HOME/.functions.sh"              # Load functions
. "$HOME/.private.config.sh";        # Load private config

# Load Homebrew ZSH site-functions
if command -v brew &>/dev/null; then
  export FPATH="$(brew --prefix)/share/zsh-completions:$FPATH"
  chmod go-w "$(brew --prefix)/share"
  . "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
  . "$ZDOTDIR/.fzf.zsh"
fi

# Load ZSH completions
export FPATH="$HOME/.zsh/completions:$FPATH"
autoload -Uz compinit
rm -f $ZDOTDIR/.zcompdump; compinit

# Load ZSH prompts
autoload -U promptinit; promptinit

# SPACESHIP prompt config
if (prompt -l) | grep "spaceship" >/dev/null; then
  export SPACESHIP_PROMPT_FIRST_PREFIX_SHOW=true
  export SPACESHIP_PROMPT_DEFAULT_PREFIX='['
  export SPACESHIP_PROMPT_DEFAULT_SUFFIX=']'
  export SPACESHIP_GIT_SYMBOL='[ '
  export SPACESHIP_PROMPT_ADD_NEWLINE=false
  export SPACESHIP_TIME_SHOW=true
  export SPACESHIP_TIME_PREFIX='['
  # export SPACESHIP_TIME_SUFFIX=']'
  export SPACESHIP_DIR_PREFIX='['
  # export SPACESHIP_DIR_SUFFIX=']'
  export SPACESHIP_CHAR_SYMBOL=''
  # export SPACESHIP_NODE_PREFIX='['
  # export SPACESHIP_NODE_SUFFIX=']'
  export SPACESHIP_GIT_SUFFIX=''
  export SPACESHIP_GIT_PREFIX='\n'
  export SPACESHIP_GIT_BRANCH_SUFFIX=']'
  export SPACESHIP_GIT_BRANCH_COLOR='255'
  export SPACESHIP_GIT_STATUS_PREFIX='['
  export SPACESHIP_GIT_STATUS_MODIFIED='✎'
  export SPACESHIP_NODE_SYMBOL=' '
  export SPACESHIP_AWS_PREFIX='['
  export SPACESHIP_AWS_SYMBOL=" "
  export SPACESHIP_DOCKER_PREFIX='['
  export SPACESHIP_DOCKER_SYMBOL=" "
  export SPACESHIP_EXIT_CODE_SHOW=true

  prompt spaceship

  # Just comment a section if you want to disable it
  SPACESHIP_PROMPT_ORDER=(
    time        # Time stamps section (Disabled)
    # user          # Username section
    dir           # Current directory section
    # host          # Hostname section
    aws           # Amazon Web Services section
    node          # Node.js section
    docker      # Docker section (Disabled)
    git           # Git section (git_branch + git_status)
    # hg            # Mercurial section (hg_branch  + hg_status)
    # package     # Package version (Disabled)
    # ruby          # Ruby section
    # elixir        # Elixir section
    # xcode       # Xcode section (Disabled)
    # swift         # Swift section
    # golang        # Go section
    # php           # PHP section
    # rust          # Rust section
    # haskell       # Haskell Stack section
    # julia       # Julia section (Disabled)
    # venv          # virtualenv section
    # conda         # conda virtualenv section
    # pyenv         # Pyenv section
    # dotnet        # .NET section
    # ember       # Ember.js section (Disabled)
    # kubecontext   # Kubectl context section
    # terraform     # Terraform workspace section
    # exec_time     # Execution time
    line_sep      # Line break
    # battery       # Battery level and status
    # vi_mode     # Vi-mode indicator (Disabled)
    jobs          # Background jobs indicator
    exit_code     # Exit code section
    char          # Prompt character
  )
fi

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