# The local configurations
-include local.mk

# The xmake init script
# *********************************************************
# * For much more details: https://github.com/gkide/xmake *
# *********************************************************
include cmake/xmake.init.mk

################################
# xmake Makefile Usage Example #
################################
PHONY += all
all: | ran-top-cmake
	$(XMAKE) -C $(BUILD_DIR) all

PHONY += ran-top-cmake
ran-top-cmake:
	$(Q)cd $(BUILD_DIR) && $(CMAKE_PROG) -G $(GENERATOR) $(CMAKE_ARGS)

PHONY += ran-top-cmake-force
ran-top-cmake-force:
	@rm -rf $(BUILD_DIR)/CMakeCache.txt # force remove old ones anyway
	$(Q)cd $(BUILD_DIR) && $(CMAKE_PROG) -G $(GENERATOR) $(CMAKE_ARGS)

PHONY += install
install: | all
	$(XMAKE) -C $(BUILD_DIR) install

PHONY += doxygen
doxygen: | ran-top-cmake
ifneq ($(Q)$(DOXYGEN_PROG),)
	$(XMAKE) -C $(BUILD_DIR) doxygen
endif

PHONY += release
release:
ifneq (,$(wildcard scripts/release))
	@scripts/release
endif

# Use cpack for source/binary packing
# https://cmake.org/cmake/help/latest/module/CPack.html
PHONY += pkg-binary
pkg-binary: | ran-top-cmake
ifeq ($(filter Dev Coverage,$(BUILD_TYPE)),)
	$(XMAKE) -C $(BUILD_DIR) package
else
	@echo "#################################################"
	@echo "# SKIP Binary Packaging for Dev/Coverage Build! #"
	@echo "#################################################"
endif

# https://docs.appimage.org/index.html
PHONY += pkg-appimage
pkg-appimage: | install
ifeq ($(filter Dev Coverage,$(BUILD_TYPE)),)
	$(XMAKE) -C $(BUILD_DIR) pkg-appimage
else
	@echo "###################################################"
	@echo "# SKIP AppImage Packaging for Dev/Coverage Build! #"
	@echo "###################################################"
endif

PHONY += pkg-source
pkg-source: | ran-top-cmake
ifeq ($(filter Dev Coverage,$(BUILD_TYPE)),)
	$(XMAKE) -C $(BUILD_DIR) pkg-source
else
	@echo "#################################################"
	@echo "# SKIP Source Packaging for Dev/Coverage Build! #"
	@echo "#################################################"
endif

PHONY += clean
clean:
	$(Q)rm -rf $(BUILD_DIR)

PHONY += distclean
distclean: clean
	$(Q)rm -rf $(DEPS_ROOT_DIR)

PHONY += test
test:
	$(XMAKE) -C $(BUILD_DIR) test

PHONY += xmake-found-tools
xmake-found-tools:
	@echo "STRIP_PROG=$(STRIP_PROG)"
	@echo "STRIP_ARGS=$(STRIP_ARGS)"
	@echo ""
	@echo "EUSTRIP_PROG=$(EUSTRIP_PROG)"
	@echo "EUSTRIP_ARGS=$(EUSTRIP_ARGS)"
	@echo ""
	@echo "DOXYGEN_PROG=$(DOXYGEN_PROG)"
	@echo "DOXYGEN_ARGS=$(DOXYGEN_ARGS)"
	@echo ""
	@echo "CPPCHECK_PROG=$(CPPCHECK_PROG)"
	@echo "CPPCHECK_ARGS=$(CPPCHECK_ARGS)"
	@echo "CPPCHECK17_PROG=$(CPPCHECK17_PROG)"
	@echo "CPPCHECK18_PROG=$(CPPCHECK18_PROG)"

PHONY += help
help:
	@echo "-------------------------------------------------------------------------"
	@echo "$$ make V=1 ...      verbose of make & cmake, default is silent."
	@echo "$$ make O=path ...   build directory abs-path, default is 'build'."
	@echo "$$ make I=path ...   for set install prefix directory of abs-path."
	@echo "-------------------------------------------------------------------------"
	@echo "The <target> of the xmake Makefile are as following:"
	@echo "    all              build the project."
	@echo "    clean            clean the build directory."
	@echo "    distclean        remove all generated files."
	@echo "    install          install all the targets."
	@echo "    release          do project release."
	@echo "    doxygen          generate doxygen mannual."
	@echo "    pkg-binary       build binary release package."
	@echo "    pkg-appimage     build AppImage release package."
	@echo "    pkg-source       build source release package."
	@echo "-------------------------------------------------------------------------"
	@echo "See 'docs/local.mk' for much more setting details."

.PHONY: $(PHONY)
