# The Local configuration
# - Do cmake config if needed
# - CMAKE_ARGS += ...
# - EXTRA_CMAKE_ARGS += ...
-include local.mk

# The xmake user-friendly template
include cmake/xmake/xmake.mk

# xmake predefined targets starts by 'xmake-*'
PHONY += all
all: xmake-all

PHONY += install
install: xmake-install

PHONY += clean
clean: xmake-clean

PHONY += distclean
distclean: xmake-distclean

PHONY += doxygen
doxygen: | xmake-doxygen

PHONY += release
release: xmake-release

PHONY += pkg-binary
pkg-binary: xmake-pkg-binary

PHONY += pkg-source
pkg-source: xmake-pkg-source

PHONY += help
help: xmake-help
	@echo "See 'docs/local.mk' for much more setting details."
#	@echo "Add more make file help docs here."

# This is just for debug print found utils
PHONY += xmake-auto-progs
auto-progs: xmake-auto-progs

######################################
# The following are xmake user space #
######################################

# ctest auto target is 'test'
PHONY += ctest
ctest: | all
	$(XMAKE) -C $(BUILD_DIR) test

PHONY += xtest
xtest: | all
	$(XMAKE) -C $(BUILD_DIR) xtest
	$(Q)$(BUILD_DIR)/$(BUILD_TYPE)/bin/xtest

.PHONY: $(PHONY)
