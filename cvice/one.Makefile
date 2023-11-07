# Makefile for building Lua from one.c

# == CHANGE THE SETTINGS BELOW TO SUIT YOUR ENVIRONMENT =======================

# Your platform. See PLATS for possible values.
PLAT= guess

CC= gcc -std=gnu99
CFLAGS= -O0 -Wall -Wextra -DLUA_COMPAT_5_3 $(SYSCFLAGS) $(MYCFLAGS)
LDFLAGS= $(SYSLDFLAGS) $(MYLDFLAGS)
LIBS= -lm $(SYSLIBS) $(MYLIBS)

AR= ar rcu
RANLIB= ranlib
RM= rm -f
UNAME= uname

# YKFIXME: LYK_DEBUG is a debug flag for the Yk integration. Once YkLua is stable we can remove it.
MYCFLAGS=-DLYK_DEBUG
MYLDFLAGS=
MYLIBS=
MYOBJS=

# Flags for enabling the Yk JIT.
#
# The user is expected to have:
#  - put `yk-config` in the `PATH`
#  - set `YK_BUILD_TYPE` to either `debug` or `release`.
YK_CFLAGS=	-DUSE_YK \
		-DLUA_USE_JUMPTABLE=0 \
		`yk-config ${YK_BUILD_TYPE} --cflags --cppflags`
YK_LDFLAGS=	`yk-config ${YK_BUILD_TYPE} --ldflags`
YK_LIBS=	`yk-config ${YK_BUILD_TYPE} --libs`

# If $(YK_BUILD_TYPE) is set then build with Yk JIT support.
ifneq ($(strip $(YK_BUILD_TYPE)),)
CC=		`yk-config ${YK_BUILD_TYPE} --cc`
AR=		`yk-config ${YK_BUILD_TYPE} --ar` rcu
RANLIB=		`yk-config ${YK_BUILD_TYPE} --ranlib`
MYCFLAGS +=	$(YK_CFLAGS)
MYLDFLAGS +=	$(YK_LDFLAGS)
MYLIBS +=	$(YK_LIBS)
endif

# Special flags for compiler modules; -Os reduces code size.
CMCFLAGS= 

# == END OF USER SETTINGS -- NO NEED TO CHANGE ANYTHING BELOW THIS LINE =======

PLATS= guess aix bsd freebsd generic linux linux-readline macosx mingw posix solaris

LUA_T=	lua
LUA_O=	one.o
ONE_LUA_C= onelua.c

ONE_LUA_T=	onelua
ONE_LUA_O=	onelua.o

# Targets start here.
default: $(PLAT) $(ONE_LUA_C) $(ONE_LUA_T)

all: $(LUA_T) $(ONE_LUA_T)

$(ONE_LUA_T): $(ONE_LUA_O)
	$(CC) -o $@ $(LDFLAGS) $(ONE_LUA_O) $(LIBS)

$(ONE_LUA_O): $(ONE_LUA_C)
	$(CC) -c $(CFLAGS) -o $@ $(ONE_LUA_C)

$(LUA_T): $(LUA_O)
	$(CC) -o $@ $(LDFLAGS) $(LUA_O) $(LIBS)

$(LUA_O): $(ONE_LUA_C)  # Changed dependency to .i file
	$(CC) -c $(CFLAGS) -o $@ $(ONE_LUA_C)

$(ONE_LUA_C): one.c   # New target for preprocessing
	$(CC) $(CFLAGS) -E one.c -o $(ONE_LUA_C)

clean:
	$(RM) $(LUA_T) $(LUA_O) $(ONE_LUA_C) $(ONE_LUA_T) $(ONE_LUA_O)

echo:
	@echo "PLAT= $(PLAT)"
	@echo "CC= $(CC)"
	@echo "CFLAGS= $(CFLAGS)"
	@echo "LDFLAGS= $(LDFLAGS)"
	@echo "LIBS= $(LIBS)"

# Convenience targets for popular platforms.
ALL= all

help:
	@echo "Do 'make PLATFORM' where PLATFORM is one of these:"
	@echo "   $(PLATS)"

guess:
	@echo Guessing `$(UNAME)`
	@$(MAKE) `$(UNAME)`

aix:
	$(MAKE) $(ALL) CC="xlc" CFLAGS="-O2 -DLUA_USE_POSIX -DLUA_USE_DLOPEN" LIBS="-ldl"

bsd:
	$(MAKE) $(ALL) CFLAGS="-O2 -DLUA_USE_POSIX -DLUA_USE_DLOPEN"

freebsd:
	$(MAKE) $(ALL) CFLAGS="-O2 -DLUA_USE_LINUX -DLUA_USE_READLINE -I/usr/include/edit" LIBS="-lreadline"

generic: $(ALL)

Linux linux:	linux-noreadline

linux-noreadline:
	$(MAKE) $(ALL) SYSCFLAGS="-DLUA_USE_LINUX" SYSLIBS="-Wl,-E -ldl"

linux-readline:
	$(MAKE) $(ALL) SYSCFLAGS="-DLUA_USE_LINUX -DLUA_USE_READLINE" SYSLIBS="-Wl,-E -ldl -lreadline"

macosx:
	$(MAKE) $(ALL) CFLAGS="-O2 -DLUA_USE_MACOSX -DLUA_USE_READLINE" LIBS="-lreadline"

mingw:
	$(MAKE) $(ALL) CFLAGS="-O2 -DLUA_USE_WINDOWS"

posix:
	$(MAKE) $(ALL) CFLAGS="-O2 -DLUA_USE_POSIX"

solaris:
	$(MAKE) $(ALL) CFLAGS="-O2 -DLUA_USE_POSIX -DLUA_USE_DLOPEN -D_REENTRANT" LIBS="-ldl"

.PHONY: all $(PLATS) help clean default

