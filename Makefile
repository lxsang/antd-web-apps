BUILDDIR = ./build
projs = grs info
copyfiles =  index.html
main: copy
	for f in $(projs); do  make -C  "$${f}" ; done

copy:
	cp -rf $(copyfiles) $(BUILDDIR)

clean:
	for f in $(projs); do rm -r $(BUILDDIR)/"$${f}"; done