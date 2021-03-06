.PHONY: dotfiles
dotfiles: ## Install dotfiles
	cd ./dotfiles && ./symlink.sh -fv

.PHONY: plist
plist: ## Sync plist
	cd ./plist/ && ./symlink.sh -fv

.PHONY: bin
bin: ## Sync bin
	cd ./bin/ && ./symlink.sh -fv

.PHONY: brew-init
brew-init: ## Initialize homebrew
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
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

.PHONY: man-php-build
man-php-build: ## Manually install php-build
	open 'https://qiita.com/Hiraku/items/33372d2c60b3ceb26e52'

.PHONY: php-build-ini-link
php-build-ini-link: ## Symlink php ini file
	cd ./php && ./symlink.sh -fv

.PHONY: man-td
man-td:  ## Manually install td CLI. See: https://docs.treasuredata.com/articles/command-line
	open 'https://docs.treasuredata.com/articles/command-line'
	open 'http://ybi-docs.idcfcloud.com/articles/command-line'

.PHONY: man-vagrant
man-vagrant:  ## Manually install Docker for Mac
	open 'https://www.virtualbox.org/'
	open 'https://www.vagrantup.com/'

.PHONY: man-docker
man-docker:  ## Manually install VirtualBox and Vagrant
	open 'https://www.docker.com/docker-mac'

.PHONY: man-composer
man-composer:  ## Manually install Composer
	open 'https://getcomposer.org/download/'

.PHONY: zlib
zlib: ## Install zlib for mac. See: http://stackoverflow.com/questions/23749530/brew-install-zlib-devel-on-mac-os-x-mavericks
	xcode-select --install

.DEFAULT_GOAL := help
.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
