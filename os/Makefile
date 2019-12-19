copyfiles =   views models controllers logs libs router.lua

main:
	- mkdir $(BUILDDIR)
	- cp -rfv $(copyfiles) $(BUILDDIR)
	- cd $(BUILDDIR) && ln -s ../grs ./rst