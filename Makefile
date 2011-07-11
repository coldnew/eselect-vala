# Makefile for eselect-vala
# Copyright 1999-2011 Gavrilov Maksim
# Distributed under the terms of the GNU General Public License v2

PROJECT = eselect-vala
VERSION = 0.1.1

DIST_FILES = AUTHORS ChangeLog COPYING README.markdown \
	Makefile vala.eselect.m4
 
DIST_TAR_GZ = $(PROJECT)-$(VERSION).tar.gz

MODULES_PATH = "/usr/share/eselect/modules/"

all: vala.eselect

vala.eselect: vala.eselect.m4 Makefile
	m4 -DPV='$(VERSION)' vala.eselect.m4 > vala.eselect

install: vala.eselect
	cp vala.eselect "$(DESTDIR)/$(MODULES_PATH)"

uninstall:
	test -f "$(DESTDIR)/$(MODULES_PATH)/vala.eselect" && \
		rm "$(DESTDIR)/$(MODULES_PATH)/vala.eselect" || true

dist: $(DIST_FILES)
	mkdir -p $(PROJECT)-$(VERSION)
	cp --parents $(DIST_FILES) $(PROJECT)-$(VERSION)
	tar -cvzf $(DIST_TAR_GZ) $(PROJECT)-$(VERSION)
	rm -rf $(PROJECT)-$(VERSION)

clean:
	test -f $(DIST_TAR_GZ) && rm $(DIST_TAR_GZ) || true
	test -f vala.eselect && rm vala.eselect || true
