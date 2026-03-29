#!/usr/bin/env bash

# Colors for better readability
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}=== Home Folder Privacy & Security Scan ===${NC}"
echo -e "Scanning: $HOME\n"

# 1. Check Directory Permissions
# Your home folder should ideally be 700 or 750.
PERMS=$(stat -c "%a" "$HOME")
if [ "$PERMS" -gt 750 ]; then
    echo -e "[${RED}!${NC}] DANGER: Home directory is world-readable ($PERMS)."
else
    echo -e "[${GREEN}✓${NC}] Home directory permissions are secure ($PERMS)."
fi

# 2. Scan for exposed Private Keys
echo -e "\n${YELLOW}Checking for exposed SSH/Private Keys...${NC}"
find "$HOME" -maxdepth 2 -name "*_rsa" -o -name "*.pem" -o -name "id_ed25519" 2>/dev/null | while read -r key; do
    echo -e "[${RED}WARN${NC}] Found Private Key: $key"
done

# 3. Check Shell History Permissions
# History files often contain sensitive commands/passwords. They should be 600.
echo -e "\n${YELLOW}Checking Shell History Permissions...${NC}"
for hist in .bash_history .zsh_history .python_history; do
    if [ -f "$HOME/$hist" ]; then
        HPERMS=$(stat -c "%a" "$HOME/$hist")
        if [ "$HPERMS" -ne 600 ]; then
            echo -e "[${RED}!${NC}] $hist is leaky ($HPERMS). Recommended: 600"
        else
            echo -e "[${GREEN}✓${NC}] $hist is secure."
        fi
    fi
done

# 4. Scan for potential Secrets in text files
# Looking for keywords like API_KEY or PASSWORD in common config extensions
echo -e "\n${YELLOW}Scanning for plain-text secrets (Top-level only)...${NC}"
grep -rEil "password|api_key|secret_key|token" "$HOME" --include="*.{txt,sh,env,json,yml}" --max-depth=1 2>/dev/null | while read -r secret; do
    echo -e "[${RED}WARN${NC}] Potential secret in: $secret"
done

# 5. Identify "Privacy Leaks" (Metadata & Logs)
# These are the files your cleanup script targets.
echo -e "\n${YELLOW}Identifying Privacy-leaking metadata folders...${NC}"
LEAKY_DIRS=(".pm2" ".node_repl_history" ".viminfo" ".lesshst" ".cache/thumbnails" ".wine" ".local/share/recently-used.xbel")
for dir in "${LEAKY_DIRS[@]}"; do
    if [ -e "$HOME/$dir" ]; then
        SIZE=$(du -sh "$HOME/$dir" 2>/dev/null | cut -f1)
        echo -e "[${YELLOW}INFO${NC}] Found $dir ($SIZE) - Tracks your activity."
    fi
done

echo -e "\n${GREEN}Scan Complete.${NC}"