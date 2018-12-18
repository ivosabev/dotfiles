## Install

On a sparkling fresh installation of macOS:

    sudo softwareupdate -i -a
    xcode-select --install

Install the dotfiles with either Git or curl:

### Clone with Git

    git clone https://github.com/ivosabev/dotfiles.git ~/.dotfiles
    cd ~/.dotfiles
    make

### Remotely install using curl

Alternatively, you can install this into `~/.dotfiles` remotely without Git using curl:

    bash -c "`curl -fsSL https://raw.githubusercontent.com/ivosabev/dotfiles/master/remote-install.sh`"
    cd ~/.dotfiles
    make

Or, using wget:

    bash -c "`wget -O - --no-check-certificate https://raw.githubusercontent.com/ivosabev/dotfiles/master/remote-install.sh`"
    cd ~/.dotfiles
    make

## The `dotfiles` command

    $ dotfiles help
    Usage: dotfiles <command>

    Commands:
       clean            Clean up caches (brew, npm, gem, rvm)
       dock             Apply macOS Dock settings
       edit             Open dotfiles in IDE (code) and Git GUI (stree)
       help             This help message
       macos            Apply macOS system defaults
       test             Run tests
       update           Update packages and pkg managers (OS, brew, npm, gem)

## Useful links

Another useful dotfiles - https://github.com/mathiasbynens/dotfiles

---

Synced with https://github.com/webpro/dotfiles up to 2018-11-21

