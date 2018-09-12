BUILDDIR = ../build/os

copyfiles =   views models controllers logs libs router.lua

main:
	- mkdir $(BUILDDIR)
	- cp -rf $(copyfiles) $(BUILDDIR)
	- cd $(BUILDDIR) && ln -s ../grs ./rst
clean:
	cd $(BUILDDIR) && rm -rf $(copyfiles)  