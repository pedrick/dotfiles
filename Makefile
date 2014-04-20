.PHONY: help
help:
	@echo "Available Commands\n------------------"
	@make -qp | awk -F':' '/^[a-zA-Z0-9][^$$#\/\t=]*:([^=]|$$)/ {split($$1,A,/ /);for(i in A)print A[i]}' | grep -v Makefile

.PHONY: install
install:
	rsync --exclude ".git/" --exclude "Makefile" -av . ~

.PHONY: lint-js
lint-js:
	sudo apt-get install npm
	sudo npm install -g jshint

.PHONY: lint-py
lint-py:
	sudo pip install flake8
