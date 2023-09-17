###############################################################################
# Copyright(C)   machine studio                                                #
# Author:        donney                                                       #
# Email:         donney_luck@sina.cn                                          #
# Date:          2022-02-18                                                   #
# Description:   make server&proto&lib                                        #
# Modification:  null                                                         #
###############################################################################

PLAT ?= none
PLATS = linux freebsd macosx
.PHONY : none $(PLATS) all clean update3rd proto publish

COLOR_RED=\033[31m
COLOR_GREEN=\033[32m
COLOR_RESET=\033[0m

none :
	@echo -e "$(COLOR_RED) Please do 'make PLATFORM' where PLATFORM is one of these:$(COLOR_RESET)"
	@echo -e "$(COLOR_GREEN) $(PLATS):  build skynet & clib & proto $(COLOR_RESET)"
	@echo -e "$(COLOR_GREEN) update3rd:   update skynet 3rd $(COLOR_RESET)"
	@echo -e "$(COLOR_GREEN) proto:       export proto file *.proto to *.pb $(COLOR_RESET)"
	@echo -e "$(COLOR_GREEN) clean:       clean up $(COLOR_RESET)"
	@echo -e "$(COLOR_GREEN) pack:        pack server $(COLOR_RESET)"
	@echo -e "$(COLOR_GREEN) publish:     publish server$(COLOR_RESET)"

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
	cd storage && sh export.sh

pack:
	cd release && sh pack.sh

publish:

