if ! is-executable brew -o ! is-executable git; then
  echo "Skipped: npm (missing: brew and/or git)"
  return
fi

brew install nvm

export DOTFILES_BREW_PREFIX_NVM=$(brew --prefix nvm)
set-config "DOTFILES_BREW_PREFIX_NVM" "$DOTFILES_BREW_PREFIX_NVM" "$DOTFILES_CACHE"

. "${DOTFILES_DIR}/system/.nvm"
nvm install 9
nvm alias default 9

# Globally install with npm

packages=(
  appcenter-cli
  npm
  npm-upgrade
  react-native-cli
  react-native-git-upgrade
  yarn
)

npm install -g "${packages[@]}"
