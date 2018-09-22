BUILDDIR = ../build/apps

copyfiles =  router.lua controllers logs views models 
coffees = 	assets/coffee/bootstrap.coffee \
			assets/coffee/BaseObject.coffee \
			assets/coffee/APIManager.coffee \
			assets/coffee/MarkOn.coffee \
			assets/coffee/WVNC.coffee \
			assets/coffee/WebVNC.coffee

SED=sed
UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Darwin)
	SED=gsed
endif

main: js
	- mkdir -p $(BUILDDIR)/assets
	cp -rf $(copyfiles) $(BUILDDIR)
	cp -r assets/css assets/scripts assets/shs $(BUILDDIR)/assets
	- cd $(BUILDDIR) && ln -s ../grs ./rst

js:
	- rm assets/scripts/main.*
	for f in $(coffees); do (cat "$${f}"; echo) >> assets/scripts/main.coffee; done
	coffee --compile assets/scripts/main.coffee
	-rm assets/scripts/main.coffee

clean:
	rm -rf $(BUILDDIR)/*  