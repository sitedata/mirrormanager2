RELEASE_DATE := "20-Jun-2008"
RELEASE_MAJOR := 1
RELEASE_MINOR := 2
RELEASE_EXTRALEVEL := .1
RELEASE_NAME := mirrormanager
RELEASE_VERSION := $(RELEASE_MAJOR).$(RELEASE_MINOR)$(RELEASE_EXTRALEVEL)
RELEASE_STRING := $(RELEASE_NAME)-$(RELEASE_VERSION)

.PHONY = all tarball

all:

clean:
	-rm -f *.tar.gz *.rpm * *~ dist/

TARBALL=dist/$(RELEASE_STRING).tar.gz

tarball: $(TARBALL)

$(TARBALL):
	mkdir -p dist
	tmp_dir=`mktemp -d /tmp/mirrormanager.XXXXXXXX` ; \
	cp -a ../$(RELEASE_NAME) $${tmp_dir}/$(RELEASE_STRING) ; \
	find $${tmp_dir}/$(RELEASE_STRING) -depth -name .git -type d -exec rm -rf \{\} \; ; \
	find $${tmp_dir}/$(RELEASE_STRING) -depth -name dist -type d -exec rm -rf \{\} \; ; \
	find $${tmp_dir}/$(RELEASE_STRING) -depth -name fedora-test-data -type d -exec rm -rf \{\} \; ; \
	find $${tmp_dir}/$(RELEASE_STRING) -depth -name \*~ -type f -exec rm -f \{\} \; ; \
	find $${tmp_dir}/$(RELEASE_STRING) -depth -name \*.rpm -type f -exec rm -f \{\} \; ; \
	find $${tmp_dir}/$(RELEASE_STRING) -depth -name \*.tar.gz -type f -exec rm -f \{\} \; ; \
	sync ; sync ; sync ; \
	tar cvzf $(TARBALL) -C $${tmp_dir} $(RELEASE_STRING) ; \
	rm -rf $${tmp_dir} ;

install-server:
	mkdir -p -m 0755 $(DESTDIR)/var/lib/mirrormanager
	mkdir -p -m 0755 $(DESTDIR)/var/run/mirrormanager
	mkdir -p -m 0755 $(DESTDIR)/var/log/mirrormanager
	mkdir -p -m 0755 $(DESTDIR)/var/lock/mirrormanager
	mkdir -p -m 0755 $(DESTDIR)/usr/share/mirrormanager
	cp -ra mirrors/	 $(DESTDIR)/usr/share/mirrormanager

install-client:
	mkdir -p -m 0755 $(DESTDIR)/etc/mirrormanager
	install -m 0644 client/report_mirror.conf $(DESTDIR)/etc/mirrormanager/
	install -m 0755 client/report_mirror $(DESTDIR)/usr/bin/
