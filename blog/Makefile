BUILDDIR = ../build/blog

copyfiles =  *.html assets *.lua  view

main:
	- mkdir $(BUILDDIR)
	cp -rf $(copyfiles) $(BUILDDIR)
	- cd $(BUILDDIR) && ln -s ../grs ./rst
clean:
	rm -rf $(BUILDDIR)/*  