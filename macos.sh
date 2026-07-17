#!/usr/bin/env bash
set -euo pipefail

echo "Applying macOS preferences..."

###############################################################################
# Finder
###############################################################################

# Show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Show hidden folders
# defaults write com.apple.finder AppleShowAllFiles -bool true

# Show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Default to list view
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Search current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Keep folders first
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# Avoid .DS_Store on network drives
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

###############################################################################
# Dock
###############################################################################

# Hide Dock automatically
defaults write com.apple.dock autohide -bool true

# Remove hide delay
defaults write com.apple.dock autohide-delay -float 0

# Faster animation
defaults write com.apple.dock autohide-time-modifier -float 0.15

# Don't rearrange Spaces automatically
defaults write com.apple.dock mru-spaces -bool false

###############################################################################
# Keyboard
###############################################################################

# Fast key repeat
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

###############################################################################
# Trackpad
###############################################################################

# Tap to click
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

###############################################################################
# Screenshots
###############################################################################

mkdir -p ~/Dessktop/Screenshots

defaults write com.apple.screencapture location -string "$HOME/Dessktop/Screenshots"
defaults write com.apple.screencapture type -string "png"

###############################################################################
# Dock
###############################################################################

# Put Dock on left side
defaults write com.apple.dock orientation -string "left"

# Smallest reasonable size
defaults write com.apple.dock tilesize -int 16

# Auto hide Dock
defaults write com.apple.dock autohide -bool true

# Remove delay before showing
defaults write com.apple.dock autohide-delay -float 0

# Make show/hide animation instant
defaults write com.apple.dock autohide-time-modifier -float 0.1

# Don't show recent apps
defaults write com.apple.dock show-recents -bool false

# Don't rearrange Spaces automatically
defaults write com.apple.dock mru-spaces -bool false

defaults write com.apple.dock persistent-apps -array 

killall Dock

###############################################################################
# Misc
###############################################################################

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Expand print panel
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

###############################################################################
# Restart affected apps
###############################################################################

killall Finder || true
killall Dock || true
killall SystemUIServer || true

echo "Done!"
