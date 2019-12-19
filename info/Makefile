copyfiles =  style.css router.lua models views controllers robot.txt

main:
	- mkdir $(BUILDDIR)
	cp -rf $(copyfiles) $(BUILDDIR)
	- cd $(BUILDDIR) && ln -s ../grs ./rst