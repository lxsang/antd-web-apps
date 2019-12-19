copyfiles =  assets views models controllers router.lua

main:
	- mkdir $(BUILDDIR)
	cp -rvf $(copyfiles) $(BUILDDIR)
	- cd $(BUILDDIR) && ln -s ../grs ./rst
