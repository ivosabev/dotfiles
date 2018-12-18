SHELL=/bin/bash
DOTFILES_DIR := $(dir $(realpath $(firstword $(MAKEFILE_LIST))))
OS := $(shell bin/is-supported bin/is-macos macos linux)
PATH := $(DOTFILES_DIR)/bin:$(PATH)
export XDG_CONFIG_HOME := $(HOME)/.config
export STOW_DIR := $(DOTFILES_DIR)
export NVM_HOME := $(HOME)/.nvm

all: $(OS)

macos: core-macos packages link

linux: core-linux link

core-macos: sudo brew bash git npm

core-linux:
	apt-get update
	apt-get upgrade -y
	apt-get dist-upgrade -f
	apt-get -y install stow

sudo:
	sudo -v
	while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

packages: brew-packages cask-apps node-packages gems

link: core-$(OS)
	for FILE in $$(\ls -A runcom); do if [ -f $(HOME)/$$FILE -a ! -h $(HOME)/$$FILE ]; then mv -v $(HOME)/$$FILE{,.bak}; fi; done
	mkdir -p $(XDG_CONFIG_HOME)
	stow -t $(HOME) runcom
	stow -t $(XDG_CONFIG_HOME) config

unlink:
	stow --delete -t $(HOME) runcom
	stow --delete -t $(XDG_CONFIG_HOME) config
	for FILE in $$(\ls -A runcom); do if [ -f $(HOME)/$$FILE.bak ]; then mv -v $(HOME)/$$FILE.bak $(HOME)/$${FILE%%.bak}; fi; done

brew: sudo
	curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install | ruby

bash: sudo brew
	brew install bash bash-completion@2
	sudo append "/usr/local/bin/bash" /private/etc/shells
	chsh -s /usr/local/bin/bash

git: brew
	brew install git git-extras

npm: brew
	mkdir -p $(NVM_HOME)
	curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
	. $(NVM_HOME)/nvm.sh; nvm install --lts

brew-packages: brew
	brew bundle --file=$(DOTFILES_DIR)/install/Brewfile

cask-apps: brew
	brew bundle --file=$(DOTFILES_DIR)/install/Caskfile

node-packages: npm
    . $(NVM_HOME)/nvm.sh; npm install -g $(shell cat install/npmfile)
