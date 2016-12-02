PREFIX = $(HOME)/local/lua

LIBS = luasocket cjson luaunit lemock

UNAME_S = $(shell uname -s)
ifeq ($(UNAME_S),Linux)
 PLAT = linux
else ifeq ($(UNAME_S),Darwin)
 PLAT = macosx
 LDFLAGS = -bundle -undefined dynamic_lookup
else
 PLAT = posix
endif

luasocket_VARS = LUAV=5.3 LUAINC=$(PREFIX)/include prefix=$(PREFIX)
cjson_VARS = LUA_VERSION=5.3 PREFIX=$(PREFIX) CFLAGS='-O3 -Wall -DNDEBUG' \
    $(if $(LDFLAGS),CJSON_LDFLAGS='$(LDFLAGS)')

help:
	@echo "Use this makefile to install lua libs locally:"
	@echo
	@echo " make install"
	@echo
	@echo "Make sure you first installed lua. You can change PREFIX,"
	@echo "current value is $(PREFIX)."

all: $(LIBS:%=%.all)
install: $(LIBS:%=%.install)
clean: $(LIBS:%=%.clean)

luasocket.all:
	$(MAKE) $(luasocket_VARS) -C luasocket $(PLAT)

luasocket.install: luasocket.all
	$(MAKE) $(luasocket_VARS) -C luasocket install

luasocket.%:
	$(MAKE) $(luasocket_VARS) -C luasocket $*

cjson.%:
	$(MAKE) $(cjson_VARS) -C cjson $*

luaunit.all:
luaunit.clean:
luaunit.install:
	install -d $(PREFIX)/share/lua/5.3
	install -m 644 luaunit/luaunit.lua $(PREFIX)/share/lua/5.3

lemock.all:
lemock.clean:
lemock.install:
	install -d $(PREFIX)/share/lua/5.3
	install -m 644 lemock/build/lemock.lua $(PREFIX)/share/lua/5.3
