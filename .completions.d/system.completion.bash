#!/usr/bin/env bash

# Loads the system's Bash completion modules.
# If Homebrew is installed (OS X), its Bash completion modules are loaded.

if [ -f /etc/bash_completion ]; then
  . /etc/bash_completion
fi

# Some distribution makes use of a profile.d script to import completion.
if [ -f /etc/profile.d/bash_completion.sh ]; then
  . /etc/profile.d/bash_completion.sh
fi


if [ $(uname) = "Darwin" ] && command -v brew &>/dev/null ; then
  HOMEBREW_PREFIX=$(brew --prefix)

  for COMPLETION in "$HOMEBREW_PREFIX"/etc/bash_completion.d/*; do
    [[ -f $COMPLETION ]] && source "$COMPLETION"
  done
  
  if [[ -f ${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh ]]; then
    source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
  fi
fi