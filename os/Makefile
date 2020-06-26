copyfiles =    controllers  libs router.lua

main:
	- mkdir -p $(BUILDDIR)
	cp -rfv $(copyfiles) $(BUILDDIR)
	- cd $(BUILDDIR) && ln -s ../grs ./rst