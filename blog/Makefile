copyfiles =  assets views models ai controllers router.lua

main:
	- mkdir -p $(BUILDDIR)
	cp -rvf $(copyfiles) $(BUILDDIR)
	- cd $(BUILDDIR) && ln -s ../grs ./rst
