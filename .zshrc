[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export GPG_TTY=$(tty)
### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/trmaphi/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)
export PATH="~/.bin:$PATH"
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
eval "$($HOME/.local/bin/mise activate zsh)"
eval "$(starship init zsh)"
eval "$($HOME/.functions.sh)"