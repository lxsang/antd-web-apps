BUILDDIR = ../build/grs

copyfiles =  font-awesome.css fonts images showdown.min.js ubuntu-regular.css mainsite.css hermit-light.css

main:
	- mkdir $(BUILDDIR)
	cp -rf $(copyfiles) $(BUILDDIR)
	- cd $(BUILDDIR) && ln -s ../os/resources/themes/antos/fonts/ ./gfonts && ln -s ../os/scripts/ ./gscripts
clean:
	rm -rf $(BUILDDIR)/*  