if ! is-macos -o ! is-executable brew; then
  echo "Skipped: Homebrew-Cask"
  return
fi

brew tap caskroom/versions
brew tap caskroom/cask
brew tap caskroom/fonts 

# Install packages

apps=(
  android-studio
  dropbox
  firefox
  font-hack
  font-iosevka
  java
  google-chrome
  google-backup-and-sync
  osxfuse
  postico
  sequel-pro
  skype
  slack
  sourcetree
  spotify
  sublime-text
  transmission
  veracrypt
  visual-studio-code
  vlc
)

brew cask install --force "${apps[@]}"

# Quick Look Plugins (https://github.com/sindresorhus/quick-look-plugins)
# brew cask install qlcolorcode qlstephen qlmarkdown quicklook-json qlimagesize webpquicklook suspicious-package qlvideo

# Link Hammerspoon config
# if [ ! -d ~/.hammerspoon ]; then ln -sfv "$DOTFILES_DIR/etc/hammerspoon/" ~/.hammerspoon; fi