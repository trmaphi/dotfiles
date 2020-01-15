# Set path rust cargo
# export PATH="$HOME/.cargo/bin:$PATH"

# Set golang GO_PATH environment variable
# export GOPATH=$(go env GOPATH)

# Set NVM home and load nvm
export NVM_DIR="${HOME}/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm

# Set python --user install bin
export PATH="$(python -m site --user-base)/.bin:$PATH"