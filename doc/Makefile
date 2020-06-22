copyfiles =  views controllers router.lua assets

main:
	- mkdir $(BUILDDIR)
	cp -rvf $(copyfiles) $(BUILDDIR)
	- cd $(BUILDDIR) && ln -s ../grs ./rst