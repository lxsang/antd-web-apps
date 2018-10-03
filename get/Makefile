BUILDDIR = ../build/get

copyfiles =  router.lua shs  
main:
	- mkdir -p $(BUILDDIR)
	cp -rf $(copyfiles) $(BUILDDIR)
	- cd $(BUILDDIR) && ln -s ../grs ./rst

clean:
	rm -rf $(BUILDDIR)/*  