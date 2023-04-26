BUILDDIR?=./build
PROJS?=grs blog talk get info
# info blog doc talk get
copyfiles =  layout.ls index.lua mimes.json
main:  copy
	for f in $(PROJS); do  BUILDDIR=$(BUILDDIR)/"$${f}" make -C  "$${f}" ; done

copy:
	cp -rfv $(copyfiles) $(BUILDDIR)
#	cp -rv silk $(BUILDDIR)

ar:
	-[ -d /tmp/antd_web_apps ] && rm -r /tmp/antd_web_apps
	-[ -f /tmp/antd_web_apps.tar.gz ] && rm /tmp/antd_web_apps.tar.gz
	mkdir /tmp/antd_web_apps
	BUILDDIR=/tmp/antd_web_apps make
	cd /tmp/antd_web_apps && tar cvzf ../antd_web_apps.tar.gz .
	mv /tmp/antd_web_apps.tar.gz dist/

clean:
	-for f in $(PROJS); do rm -r $(BUILDDIR)/"$${f}"; done
	-for f in $(copyfiles); do rm -r $(BUILDDIR)/"$${f}"; done
