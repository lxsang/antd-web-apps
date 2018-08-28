BUILDDIR = ../build/info

copyfiles =  index.ls style.css router.lua models views controllers logs robot.txt

main:
	- mkdir $(BUILDDIR)
	- cp -rf $(copyfiles) $(BUILDDIR)
	- cd $(BUILDDIR) && ln -s ../grs ./rst
clean:
	rm -rf $(BUILDDIR)/*  