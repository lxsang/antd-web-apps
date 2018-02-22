BUILDDIR = ../build/info

copyfiles =  index.ls style.css sendmail.lua

main:
	- mkdir $(BUILDDIR)
	cp -rf $(copyfiles) $(BUILDDIR)
	- cd $(BUILDDIR) && ln -s ../grs ./rst
clean:
	rm -rf $(BUILDDIR)/*  