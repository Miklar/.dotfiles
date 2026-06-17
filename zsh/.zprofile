
eval "$(/opt/homebrew/bin/brew shellenv)"
# Add .NET Core SDK tools
export PATH="$PATH:/Users/miklar/.dotnet/tools"

if [[ "$(uname)" == "Darwin" ]]; then
  export OBSIDIAN_VAULT="$HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents/zettelkasten"
fi

[[ -f "$HOME/.zprofile.local" ]] && source "$HOME/.zprofile.local"
