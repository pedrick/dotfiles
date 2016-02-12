.PHONY: help
help:
	@echo "Available Commands\n------------------"
	@make -qp | awk -F':' '/^[a-zA-Z0-9][^$$#\/\t=]*:([^=]|$$)/ {split($$1,A,/ /);for(i in A)print A[i]}' | grep -v Makefile

.PHONY: editors
editors:
	sudo apt-get install -y vim emacs24

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
	sudo apt-get install -y nodejs npm
	sudo npm install -g jshint
	sudo npm install -g eslint
	eslint --init

postgres_source_file=/etc/apt/sources.list.d/pgdg.list
postgres_key_url=https://www.postgresql.org/media/keys/ACCC4CF8.asc
postgres_repo_url=http://apt.postgresql.org/pub/repos/apt/
.PHONY: postgresql-9.3
postgresql-9.3:
	sudo touch $(postgres_source_file)
	sudo su -c 'echo "deb $(postgres_repo_url) utopic-pgdg main" >> $(postgres_source_file)'
	wget --quiet -O - $(postgres_key_url) | sudo apt-key add -
	sudo apt-get update
	sudo apt-get install -y postgresql-9.3 postgresql-server-dev-9.3

PULSE_CLIENT_CONF_FILE=~/.pulse/client.conf
PULSE_AUTOSPAWN_DISABLE_CMD=autospawn = no
@PULSE_AUTOSPAWN_DISABLED=$(shell grep $(PULSE_AUTOSPAWN_DISABLE_CMD) \
	$(PULSE_CLIENT_CONF_FILE))

PULSE_DAEMON_CONF_DIR=~/.pulse
PULSE_DAEMON_CONF_FILE=$(PULSE_DAEMON_CONF_DIR)/daemon.conf

.PHONY: pulse-disable
pulse-disable:
# See http://www.hecticgeek.com/2012/01/how-to-remove-pulseaudio-use-alsa-ubuntu-linux/
ifeq ($(PULSE_AUTOSPAWN_DISABLED),)
	echo $(PULSE_AUTOSPAWN_DISABLE_CMD) | tee -a $(PULSE_CLIENT_CONF_FILE)
endif
	-killall pulseaudio

.PHONY: pulse-enable
pulse-enable:
	rm $(PULSE_CLIENT_CONF_FILE)
	pulseaudio -D

.PHONY: pulse-settings
pulse-settings:
	mkdir -p $(PULSE_DAEMON_CONF_DIR)
	-rm $(PULSE_DAEMON_CONF_FILE)
	@echo "resample-method = src-sinc-fastest" | tee -a $(PULSE_DAEMON_CONF_FILE)
	@echo "default-sample-rate = 96000" | tee -a $(PULSE_DAEMON_CONF_FILE)
	@echo "default-sample-format = s24le" | tee -a $(PULSE_DAEMON_CONF_FILE)

.PHONY: python-packages
python-packages: tools
	sudo apt-get install -y python-dev
	sudo pip install flake8 ipython ipdb

.PHONY: suckless-tools
suckless-tools:
	sudo apt-get install -y suckless-tools

.PHONY: swap-caps
swap-caps:
	sudo sed -i 's/XKBOPTIONS=""/XKBOPTIONS="ctrl:nocaps"/' /etc/default/keyboard

.PHONY: tools
tools:
	sudo apt-get install -y curl dstat htop iftop iotop tmux tree xclip
	sudo python ~/util/get-pip.py
	-sudo ln -s /usr/share/doc/tmux/examples/bash_completion_tmux.sh /etc/bash_completion.d/


.PHONY: xmobar
xmobar:
	sudo apt-get install -y xmobar

.PHONY: xmonad-base
xmonad-base: suckless-tools
	sudo apt-get install -y xmonad libghc-xmonad-dev \
	    libghc-xmonad-contrib-dev xautolock

.PHONY: xmonad
xmonad: xmonad-base xmobar suckless-tools

.PHONY: zsh
zsh:
	sudo apt-get install -y zsh
	chsh -s `which zsh`

.PHONY: all
all: gpg-settings install editors tools lint-js python-packages xmonad zsh

#
# One-off commands
#

.PHONY: browser-default
browser-default:
	sudo update-alternatives --config x-www-browser

# Installs Intel's ConnMan to replace network manager
#
# Once installed, create a file at /var/lib/connman/wifi.config
#
# > [service_wifi_8c705a8012f8_4d696e7443686970_managed_psk]
# > Type = wifi
# > Sercurity = wpa2
# > Name = MintChip
# > Passphrase = passphrase
# > EOF
#
# When installing connman from source, follow instructions in the README to
# configure and install. If you leave off flags connman may not know where to
# get configuration.
.PHONY: connman
connman:
	sudo apt-get install -y connman
