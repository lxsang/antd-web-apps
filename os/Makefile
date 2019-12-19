copyfiles =    controllers  libs router.lua

main:
	- mkdir $(BUILDDIR)
	cp -rfv $(copyfiles) $(BUILDDIR)
	- cd $(BUILDDIR) && ln -s ../grs ./rst