BUILDDIR = ./build
projs = grs info blog apps os
copyfiles =  index.ls mimes.json
main:  copy
	for f in $(projs); do  make -C  "$${f}" ; done

copy:
	cp -rf $(copyfiles) $(BUILDDIR)
	cp -r silk $(BUILDDIR)

clean:
	-for f in $(projs); do rm -r $(BUILDDIR)/"$${f}"; done
	-rm -r $(BUILDDIR)/silk