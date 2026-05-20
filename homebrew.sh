#!/usr/bin/env bash

# Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >>/Users/miklar/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

brew install stow
brew install git

#brew install --cask google-chrome
brew install neovim
brew install docker
#brew install diff-so-fancy #pretty git diffs
brew install git-delta #pretty git diffs

brew install --cask visual-studio-code
brew install --cask insomnia
brew install --cask spotify

brew install bat
brew install btop
brew install eza
brew install fd
brew install gh
brew install jq
brew install lazydocker
brew install lazygit
brew install starship
brew install tmux
brew install yazi
brew install zoxide

brew install nvm
mkdir ~/.nvm

# fonts for Gruvbox vim theme
brew tap homebrew/cask-fonts #You only need to do this once for cask-fonts
brew install --cask font-fantasque-sans-mono
brew install --cask font-fira-code
brew install --cask font-fira-code-nerd-font
brew install --cask jetbrainsmono-nerd-font


