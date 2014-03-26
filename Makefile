.PHONY: default
default:
	rsync --exclude ".git/" --exclude "Makefile" -av . ~
