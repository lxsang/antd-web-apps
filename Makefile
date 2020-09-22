BUILDDIR?=./build
PROJS?=grs info blog os doc ci talk
copyfiles =  index.ls mimes.json
main:  copy
	for f in $(PROJS); do  BUILDDIR=$(BUILDDIR)/"$${f}" make -C  "$${f}" ; done

copy:
	cp -rf $(copyfiles) $(BUILDDIR)
	cp -r silk $(BUILDDIR)

clean:
	-for f in $(PROJS); do rm -r $(BUILDDIR)/"$${f}"; done
	-for f in $(copyfiles); do rm -r $(BUILDDIR)/"$${f}"; done
	-rm -r $(BUILDDIR)/silk