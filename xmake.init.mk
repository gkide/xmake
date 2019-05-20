xmakeDownloadUrl := https://github.com/gkide/xmake/releases/download
# The xmake version to downloaded, git tag version string
xmakeVersion ?= v1.0.0-rc

# tar/unzip tools for decompress the xmake tarball
TAR ?= $(shell (command -v tar))
xmakeTarball := xmake-$(xmakeVersion).tar.gz
UNTGZ := $(TAR) -xvf $(xmakeTarball)
ifeq ($(TAR),)
    UNZIP ?= $(shell (command -v unzip))
    ifeq ($(UNZIP),)
        $(error do NOT found 'tar' and 'unzip', xmake init STOP.)
    endif
    xmakeTarball := xmake-$(xmakeVersion).zip
    UNTGZ := $(UNZIP) $(xmakeTarball)
endif

# curl/wget tools for download the xmake tarball
WGET ?= $(shell (command -v wget))
FETCH := $(WGET) -O $(xmakeTarball)
ifeq ($(WGET),)
    CURL ?= $(shell (command -v curl))
    ifeq ($(CURL),)
        $(error do NOT found 'curl' and 'wget', xmake init STOP.)
    endif
    FETCH := $(CURL) -L -o $(xmakeTarball)
endif

# check if xmake is inited or not
xmakeInit := cmake/xmake.cmake
xmakeInit := $(shell if [ -f $(xmakeInit) ]; then echo "true"; else echo ""; fi;)

# The target to init xmake
PHONY += xmake-init
xmake-init:
ifeq ($(xmakeInit),)
	CMAKE="$(PWD)/cmake"; mkdir -p $${CMAKE} && cd $${CMAKE} && $(FETCH) \
	$(xmakeDownloadUrl)/$(xmakeVersion)/$(xmakeTarball) && $(UNTGZ) && \
	mv xmake-$(xmakeVersion)/cmake/* ./ && rm -rf xmake-$(xmakeVersion)*
endif

ifneq ($(xmakeInit),)
    # https://www.gnu.org/software/make/manual/make.html
    # xmake already inited, do not make it as the default goal
    ifeq ($(.DEFAULT_GOAL), xmake-init)
        .DEFAULT_GOAL :=
    endif
endif

# The xmake user-friendly template
-include cmake/xmake/xmake.mk
