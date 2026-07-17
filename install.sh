#!/usr/bin/env bash
set -euo pipefail

./macos.sh
brew bundle
./stow_install.sh
./dev.sh
