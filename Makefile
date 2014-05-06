.PHONY: help
help:
	@echo "Available Commands\n------------------"
	@make -qp | awk -F':' '/^[a-zA-Z0-9][^$$#\/\t=]*:([^=]|$$)/ {split($$1,A,/ /);for(i in A)print A[i]}' | grep -v Makefile

.PHONY: gpg-settings
gpg-settings:
	gsettings set org.gnome.crypto.cache gpg-cache-method 'idle'
	gsettings set org.gnome.crypto.cache gpg-cache-ttl 300

home_dir=$(echo ~)
current_dir=$(pwd)
.PHONY: install
install:
ifneq ($(current_dir),$(home_dir))
	rsync --exclude ".git/" --exclude "Makefile" -av . ~
endif

.PHONY: lint-js
lint-js:
	sudo apt-get install npm
	sudo npm install -g jshint

.PHONY: lint-py
lint-py:
	sudo pip install flake8

.PHONY: suckless-tools
suckless-tools:
	sudo apt-get install suckless-tools

.PHONY: tools
tools:
	sudo apt-get install dstat iftop

.PHONY: xmobar
xmobar:
	sudo apt-get install xmobar

.PHONY: xmonad-base
xmonad-base: suckless-tools
	sudo apt-get install xmonad libghc-xmonad-dev libghc-xmonad-contrib-dev

.PHONY: xmonad
xmonad: xmonad-base xmobar suckless-tools

.PHONY: all
all: gpg-settings install lint-js lint-py xmonad tools
