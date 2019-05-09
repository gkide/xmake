# Local make configuration
-include local.mk

# Do cmake config if needed
# CMAKE_ARGS += ...
# EXTRA_CMAKE_ARGS += ...

# The xmake user-friendly template
include cmake/xmake.mk

# xmake predefined targets starts by 'xmake-*'
PHONY += all
all: xmake-all

PHONY += ctest
ctest: xmake-ctest

PHONY += xtest
xtest: xmake-xtest

PHONY += install
install: xmake-install

PHONY += release
release: xmake-release

PHONY += pkg-binary
pkg-binary: xmake-pkg-binary

PHONY += pkg-source
pkg-source: xmake-pkg-source

PHONY += clean
clean: xmake-clean

PHONY += distclean
distclean: xmake-distclean

PHONY += xmake-auto-progs
auto-progs: xmake-auto-progs

PHONY += help
help: xmake-help
	@echo "See 'docs/local.mk' for much more setting details."

.PHONY: $(PHONY)
