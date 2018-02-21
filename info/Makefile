BUILDDIR = ../build/info

copyfiles =  index.ls style.css

main:
	- mkdir $(BUILDDIR)
	cp -rf $(copyfiles) $(BUILDDIR)
	cd $(BUILDDIR) && ln -s ../gresources .rst
clean:
	rm -rf $(BUILDDIR)/*  