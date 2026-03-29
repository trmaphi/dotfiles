# 1. Identity & Paths
export GPG_TTY=$(tty)
export PATH="$HOME/.local/bin:$PATH"

# 2. Interactive Shell Logic
if [[ $- == *i* ]]; then
    
    # fzf (Ubuntu native location)
    if [ -f /usr/share/doc/fzf/examples/key-bindings.bash ]; then
      source /usr/share/doc/fzf/examples/key-bindings.bash
    fi

    # mise (Installed via install.sh)
    if [ -f "$HOME/.local/bin/mise" ]; then
        eval "$($HOME/.local/bin/mise activate bash)"
    fi

    # starship
    if command -v starship &>/dev/null; then
        eval "$(starship init bash)"
    fi
    
    # Load custom functions
    if [ -f "$HOME/.functions.sh" ]; then
        source "$HOME/.functions.sh"
    fi
fi

# 3. Native Bash Completions (Ubuntu standard)
if [ -f /usr/share/bash-completion/bash_completion ]; then
    source /usr/share/bash-completion/bash_completion
fi

# 4. Custom App Paths
[ -d "$HOME/.rd/bin" ] && export PATH="$HOME/.rd/bin:$PATH"
[ -d "$HOME/.opencode/bin" ] && export PATH="$HOME/.opencode/bin:$PATH"
[ -d "$HOME/.bin" ] && export PATH="$HOME/.bin:$PATH"