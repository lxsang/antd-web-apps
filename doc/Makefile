copyfiles =  views controllers router.lua assets

main:
	- mkdir -p $(BUILDDIR)
	cp -rvf $(copyfiles) $(BUILDDIR)
	- cd $(BUILDDIR) && ln -s ../grs ./rst