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

PULSE_CLIENT_CONF_FILE=~/.pulse/client.conf
PULSE_AUTOSPAWN_DISABLE_CMD=autospawn = no
@PULSE_AUTOSPAWN_DISABLED=$(shell grep $(PULSE_AUTOSPAWN_DISABLE_CMD) \
	$(PULSE_CLIENT_CONF_FILE))

PULSE_DAEMON_CONF_FILE=~/.pulse/daemon.conf
PULSE_SET_SAMPLE_RATE_LINE=default-sample-rate = 48000
@PULSE_SAMPLE_RATE_SET=$(shell grep $(PULSE_SET_SAMPLE_RATE_LINE) \
	$(PULSE_DAEMON_CONF_FILE))

.PHONY: pulse-disable
pulse-disable:
# See http://www.hecticgeek.com/2012/01/how-to-remove-pulseaudio-use-alsa-ubuntu-linux/
	sudo apt-get install gnome-alsamixer python-notify python-gtk2 \
		python-alsaaudio
ifeq ($(PULSE_AUTOSPAWN_DISABLED),)
	echo $(PULSE_AUTOSPAWN_DISABLE_CMD) | tee -a $(PULSE_CLIENT_CONF_FILE)
endif
	-killall pulseaudio

.PHONY: pulse-enable
pulse-enable:
	rm $(PULSE_CLIENT_CONF_FILE)
	-pulseaudio

.PHONY: pulse-settings
pulse-settings:
ifeq ($(PULSE_SET_SAMPLE_RATE_LINE),)
	echo $(PULSE_SET_SAMPLE_RATE_LINE) | tee -a $(PULSE_DAEMON_CONF_FILE)
endif

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
