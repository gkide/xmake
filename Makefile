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

# if enable ctest, cmake will auto define 'test' target
PHONY += demo-ctest
demo-ctest:
	$(Q)rm -rf $(BUILD_DIR)/CMakeCache.txt # clean cmake cache
	$(Q)cd $(BUILD_DIR) && $(CMAKE_PROG) -G $(GENERATOR) $(CMAKE_ARGS) -DDEMO_RUN_CTEST=ON
	$(XMAKE) -C $(BUILD_DIR) test

PHONY += demo-gtest
demo-gtest:
	$(Q)rm -rf $(BUILD_DIR)/CMakeCache.txt # clean cmake cache
	$(Q)cd $(BUILD_DIR) && $(CMAKE_PROG) -G $(GENERATOR) $(CMAKE_ARGS) -DDEMO_RUN_GTEST=ON
	$(XMAKE) -C $(BUILD_DIR) gtest
	$(Q)$(BUILD_DIR)/$(BUILD_TYPE)/bin/gtest

PHONY += demo-qt5
demo-qt5:
	$(Q)rm -rf $(BUILD_DIR)/CMakeCache.txt # clean cmake cache
	$(Q)cd $(BUILD_DIR) && $(CMAKE_PROG) -G $(GENERATOR) $(CMAKE_ARGS) -DDEMO_RUN_QT5=ON
	$(XMAKE) -C $(BUILD_DIR) qt5app
	@echo "***************************************************************************************"
	@echo "***************************************************************************************"
	@echo "* modify local.mk, given static install Qt5 path to test the Qt5 static build support *"
	@echo "***************************************************************************************"
	@echo "***************************************************************************************"

PHONY += demo-ccr
demo-ccr:
	@echo "**********************************************"
	@echo "**********************************************"
	@echo "* code coverage need lcov/html, gcovr to run *"
	@echo "**********************************************"
	@echo "**********************************************"
	$(Q)cd $(BUILD_DIR) && $(CMAKE_PROG) -G $(GENERATOR) $(CMAKE_ARGS) -DDEMO_RUN_CTEST=ON
	$(XMAKE) -C $(BUILD_DIR) # code coverage scan the ctest source code
	$(XMAKE) -C $(BUILD_DIR) ccr_html_report
	$(XMAKE) -C $(BUILD_DIR) gcovr-xml
	$(XMAKE) -C $(BUILD_DIR) gcovr-html
	$(XMAKE) -C $(BUILD_DIR) gcovr-text
	$(XMAKE) -C $(BUILD_DIR) lcov-html

PHONY += demo-hostinfo
demo-hostinfo:
	$(Q)cd $(BUILD_DIR) && $(CMAKE_PROG) -G $(GENERATOR) $(CMAKE_ARGS)
	$(XMAKE) -C $(BUILD_DIR) hostinfo
	$(Q)$(BUILD_DIR)/$(BUILD_TYPE)/bin/hostinfo

# XmakeInstallHelper test demos

PHONY += demo-xihd1
demo-xihd1:
	$(Q)rm -rf $(BUILD_DIR)/CMakeCache.txt # clean cmake cache
	$(Q)cd $(BUILD_DIR) && $(CMAKE_PROG) -G $(GENERATOR) $(CMAKE_ARGS) -DDEMO_RUN_XIHD1=ON
	$(XMAKE) -C $(BUILD_DIR) install

PHONY += demo-xihd2
demo-xihd2:
	$(Q)rm -rf $(BUILD_DIR)/CMakeCache.txt # clean cmake cache
	$(Q)cd $(BUILD_DIR) && $(CMAKE_PROG) -G $(GENERATOR) $(CMAKE_ARGS) -DDEMO_RUN_XIHD2=ON
	$(XMAKE) -C $(BUILD_DIR) install

PHONY += demo-xihd3
demo-xihd3:
	$(Q)rm -rf $(BUILD_DIR)/CMakeCache.txt # clean cmake cache
	$(Q)cd $(BUILD_DIR) && $(CMAKE_PROG) -G $(GENERATOR) $(CMAKE_ARGS) -DDEMO_RUN_XIHD3=ON
	$(XMAKE) -C $(BUILD_DIR) install

PHONY += demo-all
demo-all:
	$(Q)rm -rf $(BUILD_DIR)/CMakeCache.txt # clean cmake cache
	$(Q)cd $(BUILD_DIR) && $(CMAKE_PROG) -G $(GENERATOR) $(CMAKE_ARGS) \
	-DDEMO_RUN_CTEST=ON -DDEMO_RUN_GTEST=ON -DDEMO_RUN_QT5=ON \
	-DDEMO_RUN_XIHD1=ON -DDEMO_RUN_XIHD2=ON -DDEMO_RUN_XIHD3=ON
	$(XMAKE) -C $(BUILD_DIR)

.PHONY: $(PHONY)
