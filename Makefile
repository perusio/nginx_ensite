SHELL=/usr/bin/env bash
NAME=nginx_ensite
VERSION=1.0.0
AUTHOR=perusio
URL=https://github.com/$(AUTHOR)/$(NAME)
UPDATE_URL=https://raw.githubusercontent.com/$(AUTHOR)/$(NAME)/master
UPDATE_FILES={{versions,stable}.txt,checksums.{md5,sha1,sha256,sha512}}

DIRS=bin share
INSTALL_DIRS=`find $(DIRS) -type d`
INSTALL_FILES=`find $(DIRS) -type f`
DOC_FILES=*.ronn

PKG_DIR=pkg
PKG_NAME=$(NAME)-$(VERSION)
PKG=$(PKG_DIR)/$(PKG_NAME).tar.gz
SIG=$(PKG_DIR)/$(PKG_NAME).asc

PREFIX?=/usr/local
DOC_DIR=$(PREFIX)/share/doc/$(PKG_NAME)
COMPLETION_DIR=/etc/bash_completion.d
CURR_DIR=`pwd`

pkg:
	mkdir $(PKG_DIR)

share/man/man8/nginx_ensite.8: doc/man/nginx_ensite.8.ronn
	ronn --pipe doc/man/nginx_ensite.8.ronn > share/man/man8/nginx_ensite.8

man: doc/man/nginx_ensite.8.ronn share/man/man8/nginx_ensite.8
	git add doc/man/nginx_ensite.8.ronn share/man/man8/nginx_ensite.8 share/man/man8/nginx_dissite.8
	git commit

download: pkg
	wget -O $(PKG) $(URL)/archive/v$(VERSION).tar.gz

build: pkg
	git archive --output=$(PKG) --prefix=$(PKG_NAME)/ HEAD

sign: $(PKG)
	gpg --sign --detach-sign --armor $(PKG)
	git add $(PKG).sig
	git commit $(PKG).sig -m "Added PGP signature for v$(VERSION)"
	git push origin master

clean:
	rm -f $(PKG) $(SIG)

all: $(PKG) $(SIG)

tag:
	git push
	git tag -s -m "Releasing $(VERSION)" v$(VERSION)
	git push --tags

release: tag download sign

install:
	for dir in $(INSTALL_DIRS); do mkdir -p $(DESTDIR)$(PREFIX)/$$dir; done
	for file in $(INSTALL_FILES); do cp $$file $(DESTDIR)$(PREFIX)/$$file; done
	(cd $(DESTDIR)$(PREFIX)/bin && test -L nginx_dissite || ln -s nginx_ensite nginx_dissite)
	mkdir -p $(DESTDIR)$(DOC_DIR)
	cp -r doc/man/$(DOC_FILES) $(DESTDIR)$(DOC_DIR)/
	mkdir -p $(COMPLETION_DIR)
	cp bash_completion.d/* $(COMPLETION_DIR)/

uninstall:
	for file in $(INSTALL_FILES); do rm -f $(DESTDIR)$(PREFIX)/$$file; done
	rm -rf $(DESTDIR)$(DOC_DIR)
	rm $(COMPLETION_DIR)/$(NAME)

.PHONY: build man update download sign verify clean check test tag release rpm install uninstall all
