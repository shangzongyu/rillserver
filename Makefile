PLAT ?= none
PLATS = linux freebsd macosx
.PHONY : none $(PLATS) all clean update3rd proto

none :
	@echo "Please do 'make PLATFORM' where PLATFORM is one of these:"
	@echo "   $(PLATS)"
	@echo "update3rd:   update skynet && server 3rd"
	@echo "proto:       export proto file *.proto to *.pb"

linux : PLAT = linux
macosx : PLAT = macosx
freebsd : PLAT = freebsd

clean:
	cd skynet && $(MAKE) clean
	cd lualib-src && $(MAKE) clean
all:
	cd skynet && $(MAKE) $(PLAT)
	cd lualib-src && $(MAKE) $(PLAT)
	cd proto && sh export.sh
linux macosx freebsd:
	$(MAKE) all PLAT=$(PLAT)

update3rd:
	cd skynet && $(MAKE) update3rd
proto:
	cd proto && sh export.sh
