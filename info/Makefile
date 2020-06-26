copyfiles =  style.css router.lua models views controllers robot.txt

main:
	- mkdir -p $(BUILDDIR)
	cp -rvf $(copyfiles) $(BUILDDIR)
	- cd $(BUILDDIR) && ln -s ../grs ./rst