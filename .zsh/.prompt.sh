
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