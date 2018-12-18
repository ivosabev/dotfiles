## Install

On a sparkling fresh installation of macOS:

    sudo softwareupdate -i -a
    xcode-select --install

The Xcode Command Line Tools includes `git` and `make` (not available on stock macOS).
Then, install this repo with `curl` available:

    bash -c "`curl -fsSL https://raw.githubusercontent.com/webpro/dotfiles/master/remote-install.sh`"

This will clone (using `git`), or download (using `curl` or `wget`), this repo to `~/.dotfiles`. Alternatively, clone manually into the desired location:

    git clone https://github.com/webpro/dotfiles.git ~/.dotfiles

Use the [Makefile](./Makefile) to install everything [listed above](#package-overview), and symlink [runcom](./runcom) and [config](./config) (using [stow](https://www.gnu.org/software/stow/)):

    cd ~/.dotfiles
    make

## Post-install

* `dotfiles dock` (set [Dock items](./macos/dock.sh))
* `dotfiles macos` (set [macOS defaults](./macos/defaults.sh))
* Mackup
  * Log in to Dropbox
  * `mackup restore`
  * `ln -s ~/.config/mackup/.mackup.cfg ~` (until [#632](https://github.com/lra/mackup/pull/632) is fixed)

## The `dotfiles` command

    $ dotfiles help
    Usage: dotfiles <command>

    Commands:
       clean            Clean up caches (brew, npm)
       dock             Apply macOS Dock settings
       edit             Open dotfiles in IDE (code) and Git GUI (stree)
       help             This help message
       macos            Apply macOS system defaults
       test             Run tests
       update           Update packages and pkg managers (OS, brew, npm)

## Useful links

Another useful dotfiles - https://github.com/mathiasbynens/dotfiles

---

Synced with https://github.com/webpro/dotfiles up to 2018-11-21

