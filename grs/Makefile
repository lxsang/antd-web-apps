BUILDDIR = ../build/grs

copyfiles =  font-awesome.css fonts images sendmail.lua showdown.min.js main.js ubuntu-regular.css mainsite.css sendto.html hermit-light.css hljs

main:
	- mkdir $(BUILDDIR)
	cp -rf $(copyfiles) $(BUILDDIR)
	- cd $(BUILDDIR) && ln -s ../os/resources ./resources && ln -s ../os/scripts/ ./gscripts 
clean:
	rm -rf $(BUILDDIR)/*  