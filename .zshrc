### Bash-it configuration
# If not running interactively, don't do anything
case $- in
  *i*) ;;
    *) return;;
esac

export SHELL=$(which zsh);

# Missing paths
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:${PATH}

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

# Load Homebrew zsh site-functions
if command -v brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi

FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

source "${HOME}/.completions.d/npm.completion.bash"

chmod go-w "$(brew --prefix)/share"

autoload -Uz compinit
rm -f $HOME/.zcompdump; compinit

# Load custom aliases
source "${HOME}/.aliases"

# Depot_tools path
export PATH=$PATH:${HOME}/Projects/depot_tools

# # Set work config
HOSTNAME=$(hostname)
if [ "${HOSTNAME}" = "Lecle-VN-phi.local" ]; then
  source "${HOME}/.config.work";
fi

export SPACESHIP_PROMPT_FIRST_PREFIX_SHOW=true

autoload -U promptinit; promptinit
prompt spaceship

# Just comment a section if you want to disable it
SPACESHIP_PROMPT_ORDER=(
  time        # Time stamps section (Disabled)
  # user          # Username section
  dir           # Current directory section
  # host          # Hostname section
  git           # Git section (git_branch + git_status)
  # hg            # Mercurial section (hg_branch  + hg_status)
  # package     # Package version (Disabled)
  node          # Node.js section
  # ruby          # Ruby section
  # elixir        # Elixir section
  # xcode       # Xcode section (Disabled)
  # swift         # Swift section
  # golang        # Go section
  # php           # PHP section
  # rust          # Rust section
  # haskell       # Haskell Stack section
  # julia       # Julia section (Disabled)
  docker      # Docker section (Disabled)
  aws           # Amazon Web Services section
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
  vi_mode     # Vi-mode indicator (Disabled)
  jobs          # Background jobs indicator
  exit_code     # Exit code section
  char          # Prompt character
)

export SPACESHIP_PROMPT_ADD_NEWLINE=false
export SPACESHIP_CHAR_SYMBOL=''
export SPACESHIP_TIME_SHOW=true
export SPACESHIP_TIME_PREFIX='['
export SPACESHIP_TIME_SUFFIX=']'
export SPACESHIP_DIR_PREFIX='['
export SPACESHIP_DIR_SUFFIX=']'
export SPACESHIP_GIT_SYMBOL='ᚶ'
export SPACESHIP_GIT_PREFIX='\n'
export SPACESHIP_GIT_BRANCH_COLOR='white'
export SPACESHIP_AWS_SYMBOL="☁ "
export AWS_PROFILE="${AWS_DEFAULT_PROFILE}"
export SPACESHIP_EXIT_CODE_SHOW=true

source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh