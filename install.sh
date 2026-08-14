#!/usr/bin/env bash
set -euo pipefail

./macos.sh

#/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew bundle 

./stow_install.sh
./dev.sh
