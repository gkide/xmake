XmakeDownloadUrl := https://github.com/gkide/xmake/releases/download

# It must be set to the repo tag values
XmakeVersion ?= v1.2.0

# tar/unzip tools for decompress the xmake tarball
TAR ?= $(shell (command -v tar))
XmakeTarball := xmake-$(XmakeVersion).tar.gz
UNTGZ := $(TAR) -xvf $(XmakeTarball)

ifeq ($(TAR),)
    UNTGZ :=
    UNZIP ?= $(shell (command -v unzip))
    ifneq ($(UNZIP),)
        XmakeTarball := xmake-$(XmakeVersion).zip
        UNTGZ := $(UNZIP) $(XmakeTarball)
    endif
endif

# curl/wget tools for download the xmake tarball
WGET ?= $(shell (command -v wget))
FETCH := $(WGET) -O $(XmakeTarball)

ifeq ($(WGET),)
    CURL ?= $(shell (command -v curl))
    ifeq ($(CURL),)
        $(error do NOT found 'curl' and 'wget', xmake init STOP.)
    endif
    FETCH := $(CURL) -L -o $(XmakeTarball)
endif

# check if xmake is inited or not
XmakeInit := cmake/xmake.cmake
XmakeInit := $(shell if [ -f $(XmakeInit) ]; then echo "Done"; else echo ""; fi;)

# The very first time building need to init xmake
ifeq ($(XmakeInit),)
PHONY += xmake-init
xmake-init:
ifeq ($(UNTGZ),)
	@echo "do NOT found 'tar' and 'unzip', xmake init STOP"
endif
	CMAKE="$(PWD)/cmake"; mkdir -p $${CMAKE} && cd $${CMAKE} && $(FETCH) \
	$(XmakeDownloadUrl)/$(XmakeVersion)/$(XmakeTarball) && $(UNTGZ) && \
	mv xmake-$(XmakeVersion)/cmake/* ./ && rm -rf xmake-$(XmakeVersion)*
	@echo "*********************************************************"
	@echo "* xmake init done, run make again to build the project. *"
	@echo "*********************************************************"
endif

# The user-friendly makefile template
-include cmake/xmake/xmake.mk
