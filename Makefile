dotfiles: ## Install dotfiles
	cd ./dotfiles && ./symlink.sh -fv

plist: ## Sync plist
	cd ./plist/ && ./symlink.sh -fv

brew-init: ## Initialize homebrew
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	brew tap Homebrew/bundle

brew-bundle: ## Execute brew bundle
	cd ./brew && brew bundle

tmuxinator: ## Install tmuxinator
	gem install tmuxinator

tmuxinator-setup: ## Setup tmuxinator
	wget 'https://raw.githubusercontent.com/tmuxinator/tmuxinator/master/completion/tmuxinator.zsh'
	mkdir -p ~/.bin
	mv tmuxinator.zsh ~/.bin

.PHONY: help dotfiles plist brew-init brew-bundle tmuxinator tmuxinator-setup

.DEFAULT_GOAL := help

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
