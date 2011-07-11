# Makefile for eselect-vala
# Copyright 1999-2011 Gavrilov Maksim
# Distributed under the terms of the GNU General Public License v2

PROJECT = eselect-vala
VERSION = 0.1.1

DIST_FILES = AUTHORS COPYING README.markdown \
	Makefile vala.eselect.m4 ChangeLog
 
DIST_TAR_GZ = $(PROJECT)-$(VERSION).tar.gz

MODULES_PATH = "/usr/share/eselect/modules/"
INSTALL_DIR = "$(DESTDIR)/$(MODULES_PATH)"

all: vala.eselect

ChangeLog:
	git log > ChangeLog

vala.eselect: vala.eselect.m4 Makefile
	m4 -DPV='$(VERSION)' vala.eselect.m4 > vala.eselect

install: vala.eselect
	test -d "$(INSTALL_DIR)" || mkdir -p "$(INSTALL_DIR)"
	cp vala.eselect "$(INSTALL_DIR)"

uninstall:
	test -f "$(INSTALL_DIR)/vala.eselect" && \
		rm "$(INSTALL_DIR)/vala.eselect" || true

dist: $(DIST_FILES)
	mkdir -p $(PROJECT)-$(VERSION)
	cp --parents $(DIST_FILES) $(PROJECT)-$(VERSION)
	tar -cvzf $(DIST_TAR_GZ) $(PROJECT)-$(VERSION)
	rm -rf $(PROJECT)-$(VERSION)

clean:
	test -f $(DIST_TAR_GZ) && rm $(DIST_TAR_GZ) || true
	test -f vala.eselect && rm vala.eselect || true
	test -f ChangeLog && rm ChangeLog || true
