copyfiles = katex  font-awesome.css fonts images sendmail.lua subscribe.lua subscribe.html  main.js ubuntu-regular.css mainsite.css sendto.html hermit-light.css hljs

main:
	- mkdir $(BUILDDIR)
	cp -rvf $(copyfiles) $(BUILDDIR)
	- cd $(BUILDDIR) && ln -s ../os/resources ./resources && ln -s ../os/scripts/ ./gscripts  