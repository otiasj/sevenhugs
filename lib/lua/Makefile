PREFIX = $(HOME)/local/lua

VARS = INSTALL_TOP=$(PREFIX) MYCFLAGS='-DLUA_ROOT=\"$(PREFIX)/\"'
UNAME_S = $(shell uname -s)
ifeq ($(UNAME_S),Linux)
 PLAT = linux
else ifeq ($(UNAME_S),Darwin)
 PLAT = macosx
else
 PLAT = posix
endif

help:
	@echo "Use this makefile to install lua locally:"
	@echo
	@echo " make install"
	@echo
	@echo "You can change PREFIX, current value is $(PREFIX)."

all:
	$(MAKE) $(VARS) -C lua $(PLAT)

install: all
	$(MAKE) $(VARS) -C lua $@

%:
	$(MAKE) $(VARS) -C lua $@
