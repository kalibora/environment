.PHONY: dotfiles
dotfiles: ## Install dotfiles
	cd ./dotfiles && ./symlink.sh -fv

.PHONY: plist
plist: ## Sync plist
	cd ./plist/ && ./symlink.sh -fv

.PHONY: brew-init
brew-init: ## Initialize homebrew
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	brew tap Homebrew/bundle

.PHONY: brew-bundle
brew-bundle: ## Execute brew bundle
	cd ./brew && brew bundle

.PHONY: tmuxinator-install
tmuxinator-install: ## Install tmuxinator (use sudo)
	sudo gem install tmuxinator

.PHONY: tmuxinator-setup
tmuxinator-setup: ## Setup tmuxinator
	wget 'https://raw.githubusercontent.com/tmuxinator/tmuxinator/master/completion/tmuxinator.zsh'
	mkdir -p ~/.bin
	mv tmuxinator.zsh ~/.bin

.PHONY: phpenv
phpenv: ## Install phpenv
	curl -L http://git.io/phpenv-installer | bash

.PHONY: zlib
zlib: ## Install zlib for mac. See: http://stackoverflow.com/questions/23749530/brew-install-zlib-devel-on-mac-os-x-mavericks
	xcode-select --install

.DEFAULT_GOAL := help
.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
