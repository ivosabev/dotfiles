if ! is-macos -o ! is-executable brew; then
  echo "Skipped: Homebrew-Cask"
  return
fi

brew tap caskroom/cask

# Install packages

apps=(
  android-studio
  dropbox
  firefox
  java
  google-chrome
  google-backup-and-sync
  kaleidoscope
  postico
  sequel-pro
  skype
  slack
  sourcetree
  spotify
  sublime-text
  transmission
  visual-studio-code
  vlc
)

brew cask install --force "${apps[@]}"

# Quick Look Plugins (https://github.com/sindresorhus/quick-look-plugins)
# brew cask install qlcolorcode qlstephen qlmarkdown quicklook-json qlprettypatch quicklook-csv betterzipql qlimagesize webpquicklook suspicious-package
