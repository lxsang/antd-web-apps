BUILDDIR = ../build/apps

copyfiles =  index.ls style.css 

main:
	- mkdir $(BUILDDIR)
	cp -rf $(copyfiles) $(BUILDDIR)
	- cd $(BUILDDIR) && ln -s ../grs ./rst
clean:
	rm -rf $(BUILDDIR)/*  