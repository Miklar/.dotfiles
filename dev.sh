#!/usr/bin/env bash
set -euo pipefail

echo "Installing development environment..."

###############################################################################
# Core developer tools
###############################################################################

brew install \
  mise \
  direnv \
  # just \
  jq \
  yq \
  fx \
  ripgrep \
  fd \
  fzf \
  bat \
  tree \
  wget \
  curl \
  watch \
  openssl


###############################################################################
# git & GitHub
###############################################################################

brew install git
brew install git-delta
brew install git-lfs # large file support

brew install gh
brew install lazygit
brew install worktrunk

###############################################################################
# Editors / terminal
###############################################################################

brew install neovim
brew install tmux

###############################################################################
# Fonts
###############################################################################

brew install --cask "font-fantasque-sans-mono"
brew install --cask "font-fira-code"
brew install --cask "font-fira-code-nerd-font"
brew install --cask "font-symbols-only-nerd-font"

###############################################################################
# Languages via mise
###############################################################################

mise use --global dotnet@latest
mise use --global go@latest
mise use --global node@lts
mise use --global elixir@latest
mise use --global erlang@latest
mise use --global python@latest

###############################################################################
# Docker
###############################################################################

brew install docker docker-compose
brew install lazydocker

###############################################################################
# Database tools
###############################################################################

brew install postgresql@17

# Useful DB clients
brew install \
  pgcli \
  sqlite


###############################################################################
# Cloud
###############################################################################

brew install azure-cli
brew install --cask google-cloud-sdk

###############################################################################
# Setup directories
###############################################################################

mkdir -p \
  ~/dev/personal \
  ~/dev/playground \
  ~/dev/work

echo ""
echo "Done!"
echo ""
echo "Remember:"
echo "  Run gh auth login"
