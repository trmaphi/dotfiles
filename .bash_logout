#!/usr/bin/env bash

# --- 1. Wipe Shell History (Critical for Security) ---
# This clears the current session history and truncates the history file
history -c
rm -f ~/.bash_history ~/.zsh_history ~/.python_history

# --- 2. Define the "Burn List" ---
# Added: .ssh/known_hosts (privacy), .cache (massive leak), and .wget-hsts
DEATH_ROW=(
    "$HOME/.pm2"
    "$HOME/.node_repl_history"
    "$HOME/.yarnrc"
    "$HOME/.lesshst"
    "$HOME/.viminfo"
    "$HOME/.wget-hsts"
    "$HOME/.local/share/recently-used.xbel" # GNOME "Recent Files" leak
    "$HOME/.cache/thumbnails"               # Image previews
    "$HOME/.DS_Store"                       # macOS leftovers
)

# --- 3. Securely Delete ---
for item in "${DEATH_ROW[@]}"; do
    if [ -e "$item" ]; then
        # -u: truncate and remove, -z: add a final overwrite with zeros
        find "$item" -type f -exec shred -u -z {} + 2>/dev/null
        rm -rf "$item"
    fi
done

# --- 4. Clear System Temp & Clipboard ---
# Only works if you have 'xclip' or 'wl-copy' installed on Desktop
if command -v xclip &>/dev/null; then
    echo -n "" | xclip -selection clipboard
    echo -n "" | xclip -selection primary
fi

echo "Session cleaned securely."