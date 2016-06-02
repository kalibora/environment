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

PHPENV_DEFAULT_CONFIGURE_OPTIONS=${HOME}/.phpenv/plugins/php-build/share/php-build/default_configure_options
ICU_DIR=$(shell brew --prefix icu4c)
.PHONY: phpenv-customize-configure
phpenv-customize-configure: ## Customize default_configure_options
	grep 'with-gmp' ${PHPENV_DEFAULT_CONFIGURE_OPTIONS} || echo '--with-gmp' >> ${PHPENV_DEFAULT_CONFIGURE_OPTIONS}
	grep 'enable-intl' ${PHPENV_DEFAULT_CONFIGURE_OPTIONS} || echo "--enable-intl --with-icu-dir=${ICU_DIR}" >> ${PHPENV_DEFAULT_CONFIGURE_OPTIONS}
	grep 'enable-opcache' ${PHPENV_DEFAULT_CONFIGURE_OPTIONS} || echo '--enable-opcache' >> ${PHPENV_DEFAULT_CONFIGURE_OPTIONS}

.PHONY: phpenv-ini-link
phpenv-ini-link: ## Symlink php ini file
	cd ./php && ./symlink.sh -fv

.PHONY: td-install
td-install:  ## Install td CLI. See: https://docs.treasuredata.com/articles/command-line
	open 'https://docs.treasuredata.com/articles/command-line'
	open 'http://ybi-docs.idcfcloud.com/articles/command-line'

.PHONY: zlib
zlib: ## Install zlib for mac. See: http://stackoverflow.com/questions/23749530/brew-install-zlib-devel-on-mac-os-x-mavericks
	xcode-select --install

.DEFAULT_GOAL := help
.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'