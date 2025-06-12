export GPG_TTY=$(tty)

# Created by `pipx` on 2024-02-04 15:02:49
if [[ "$(uname -m)" == "arm64" ]]
then
  # On ARM macOS, this script installs to /opt/homebrew only
  export HOMEBREW_PREFIX="/opt/homebrew";
  export HOMEBREW_CELLAR="/opt/homebrew/Cellar";
  export HOMEBREW_REPOSITORY="/opt/homebrew";
  export PATH="/opt/homebrew/bin:/opt/homebrew/sbin${PATH+:$PATH}";
  [ -z "${MANPATH-}" ] || export MANPATH=":${MANPATH#:}";
  export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}";
else
  # On Intel macOS, this script installs to /usr/local only
  export HOMEBREW_PREFIX="/usr/local";
  export HOMEBREW_CELLAR="/usr/local/Cellar";
  export HOMEBREW_REPOSITORY="/usr/local/Homebrew";
  export PATH="/usr/local/bin:/usr/local/sbin${PATH+:$PATH}";
  [ -z "${MANPATH-}" ] || export MANPATH=":${MANPATH#:}";
  export INFOPATH="/usr/local/share/info:${INFOPATH:-}";
fi

export PATH="$PATH:$HOME/.local/bin"

if [[ -o interactive ]]; then
  # Check for fzf and source its config if available
  command -v fzf &>/dev/null && [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

  # Activate mise if it's installed
  command -v mise &>/dev/null && eval "$($HOME/.local/bin/mise activate zsh)"

  # Initialize starship if it's installed
  command -v starship &>/dev/null && eval "$(starship init zsh)"
fi

eval "$($HOME/.functions.sh)"

# Check if brew is available
if type brew &>/dev/null; then
  ### Use for macos
  ### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
  export PATH="/Users/trmaphi/.rd/bin:$PATH"
  ### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)
  export PATH="~/.bin:$PATH"

  if command -v fzf &>/dev/null; then
    # Check if zsh-completions directory exists (not file)
    if [ -d "$(brew --prefix)/share/zsh-completions" ]; then
      FPATH="$(brew --prefix)/share/zsh-completions:$FPATH"
    fi
  
    # Check if custom completion directory exists (not file)
    if [ -d "$HOME/.dotfiles/zsh.completion.d" ]; then
      FPATH="$HOME/.dotfiles/zsh.completion.d:$FPATH"
    fi
  
    # Make sure completion directory is created
    mkdir -p "$HOME/.zcompcache"  
    
    # Load completions
    autoload -Uz compinit
    compinit -d "$HOME/.zcompcache/zcompdump"
  fi
fi
