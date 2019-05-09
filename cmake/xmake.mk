# If it is true the result will be 1
isTrue = $(strip $(filter-out 1 ON On on TRUE True true,$1))1
# If it is false the result will be 1
isFalse = $(strip $(filter-out 0 OFF Off off FALSE False false,$1))1
# If it contains spaces the result will be 1
hasSpaces = $(if $(subst 1,,$(words [$1])),1,)
# If it contains colons the result will be 1
hasColons = $(call hasSpaces,$(subst :, ,$1))

# Project source tree, should not contain spaces or colons
# SOURCE_DIR := $(shell pwd)
SOURCE_DIR := $(CURDIR)

ifeq ($(call hasSpaces,$(SOURCE_DIR)),1)
    $(error Project path can NOT contain spaces: "$(SOURCE_DIR)")
endif
ifeq ($(call hasColons,$(SOURCE_DIR)),1)
    $(error Project path can NOT contain colons: "$(SOURCE_DIR)")
endif

# Beautify Output
# Use 'make V=1' to see the full commands
#
# If IS_VERBOSE equals 0 then the commands will be hidden.
# If IS_VERBOSE equals 1 then the commands will be displayed.
IS_VERBOSE := 0
ifeq ("$(origin V)", "command line")
    IS_VERBOSE := $(V)
endif

ifneq ($(VERBOSE),)
    IS_VERBOSE := 1
endif

# Prefix commands with $(Q), that's useful for
# commands that shall be hidden in non-verbose mode.
#
#     $(Q)ln $@ :<
ifeq ($(IS_VERBOSE), 1)
    Q :=
else
    Q := @
endif

# Do not print "Entering directory ..."
MAKEFLAGS += --no-print-directory

BUILD_TYPE ?= Debug
CMAKE_PROG ?= $(shell (command -v cmake3 || echo cmake))

ifeq ($(CMAKE_ARGS),)
    CMAKE_ARGS := -DCMAKE_BUILD_TYPE=$(BUILD_TYPE)
else
    CMAKE_ARGS += -DCMAKE_BUILD_TYPE=$(BUILD_TYPE)
endif

ifneq ($(strip $(shell (command -v ninja))),)
    GENERATOR ?= 'Ninja'
    BUILD_CMD ?= $(shell (command -v ninja))
    ifeq ($(IS_VERBOSE), 1)
        # Only need to handle VERBOSE for Ninja,
        # Make will inherit the VERBOSE variable
        BUILD_CMD += -v
    endif
endif

# The build tool: make or ninja
BUILD_CMD ?= $(MAKE)
GENERATOR ?= 'Unix Makefiles'

ifeq ($(GENERATOR), 'Unix Makefiles')
    BUILD_CMD := $(MAKE)
endif

ifeq ($(GENERATOR), Ninja)
    ifeq ($(shell $(CMAKE_PROG) --help 2>/dev/null | grep Ninja),)
        # User's version of CMake doesn't support Ninja
        BUILD_CMD := $(MAKE)
        GENERATOR := 'Unix Makefiles'
    endif
endif

XMAKE := $(Q)$(BUILD_CMD)

# The deps download/build/install root directory
DEPS_ROOT_DIR ?= $(SOURCE_DIR)/.deps
ifeq ($(call hasSpaces,$(DEPS_ROOT_DIR)),1)
    $(error Deps root path can NOT contain spaces: "$(DEPS_ROOT_DIR)")
endif
ifeq ($(call hasColons,$(DEPS_ROOT_DIR)),1)
    $(error Deps root path can NOT contain colons: "$(DEPS_ROOT_DIR)")
endif

# Creat it and make sure to get the full path
OUTPUT := $(shell mkdir -p $(DEPS_ROOT_DIR) && cd $(DEPS_ROOT_DIR) && pwd)
$(if $(OUTPUT),, $(error Failed to create directory: "$(DEPS_ROOT_DIR)"))
DEPS_ROOT_DIR := $(OUTPUT)

# The building directory
BUILD_DIR ?= $(SOURCE_DIR)/build
ifeq ("$(origin O)", "command line")
    BUILD_DIR := $(O)
endif

ifeq ($(call hasSpaces,$(BUILD_DIR)),1)
    $(error Build path can NOT contain spaces: "$(BUILD_DIR)")
endif
ifeq ($(call hasColons,$(BUILD_DIR)),1)
    $(error Build path can NOT contain colons: "$(BUILD_DIR)")
endif

# Creat it and make sure to get the full path
OUTPUT := $(shell mkdir -p $(BUILD_DIR) && cd $(BUILD_DIR) && pwd)
$(if $(OUTPUT),, $(error Failed to create directory: "$(BUILD_DIR)"))
BUILD_DIR := $(OUTPUT)

# The install prefix
# - if not full path, evaluated to the current build directory
# - if not set, default value is '/opt/${PROJECT_NAME}-v${PROJECT_VERSION}'
#
# '$ make DESTDIR=/prefix/ ... ', works for only unix like systems of both.
ifeq ("$(origin I)", "command line")
    INSTALL_PREFIX := $(I)
    ifeq ($(call hasSpaces,$(INSTALL_PREFIX)),1)
        $(error Install path can NOT contain spaces: "$(INSTALL_PREFIX)")
    endif
    ifeq ($(call hasColons,$(INSTALL_PREFIX)),1)
        $(error Install path can NOT contain colons: "$(INSTALL_PREFIX)")
    endif

    # Creat it and make sure to get the full path
    OUTPUT := $(shell mkdir -p $(INSTALL_PREFIX) && cd $(INSTALL_PREFIX) && pwd)
    $(if $(OUTPUT),, $(error Failed to create directory: "$(INSTALL_PREFIX)"))
    CMAKE_ARGS += -DCMAKE_INSTALL_PREFIX=$(OUTPUT)
endif

# Do not show cmake warnings for none 'Dev/Debug' build
ifeq ($(filter Dev Debug Coverage,$(BUILD_TYPE)),)
    CMAKE_ARGS += -Wno-dev
endif

ifeq ($(IS_VERBOSE), 1)
    CMAKE_ARGS += -DCMAKE_VERBOSE_MAKEFILE=ON
    CMAKE_ARGS += -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
endif

DEPS_BUILD_TYPE ?= Release
CMAKE_ARGS += -DDEPS_ROOT_DIR=$(DEPS_ROOT_DIR)
CMAKE_ARGS += -DDEPS_BUILD_TYPE=$(DEPS_BUILD_TYPE)

ifneq ($(GIT_PROG),)
    CMAKE_ARGS += -DGIT_PROG=$(GIT_PROG)
else
    ifneq ($(strip $(shell (command -v git))),)
        CMAKE_ARGS += -DGIT_PROG=$(shell (command -v git))
    endif
endif

ifneq ($(MAKE_PROG),)
    CMAKE_ARGS += -DMAKE_PROG=$(MAKE_PROG)
else
    ifneq ($(strip $(shell (command -v make))),)
        CMAKE_ARGS += -DMAKE_PROG=$(shell (command -v make))
    endif
endif

ifneq ($(EXTRA_CMAKE_ARGS),)
    CMAKE_ARGS += $(EXTRA_CMAKE_ARGS)
endif

CMAKE_ARGS += $(SOURCE_DIR)

#######################################################
# Import Common Utils
#######################################################
# isTrue, isFalse, hasSpaces, hasColons

#######################################################
# Auto Set Read-only Variables
#######################################################
#
# - XMAKE           make or ninja with flags
# - SOURCE_DIR      project source directory

#######################################################
# User Configurable Variables
#######################################################
#
# - DEPS_BUILD_TYPE     Release, ...
# - DEPS_ROOT_DIR       $(SOURCE_DIR)/.deps
#
# - BUILD_TYPE          Debug, ...
# - BUILD_DIR           $(SOURCE_DIR)/build
#
# The available values for DEPS_BUILD_TYPE/BUILD_TYPE
# - Dev, Debug, Release, MinSizeRel, RelWithDebInfo
#
# ------------------
# cmake, make, ninja, git
# ------------------
# - BUILD_CMD     auto detected if not set
# - CMAKE_PROG    auto detected if not set
# - GENERATOR     'Ninja' or 'Unix Makefiles'
# - CMAKE_ARGS    can be set with extra args
#
# - GIT_PROG      full path of git programme
# - MAKE_PROG     full path of make programme

#######################################################
# Auto Detect System Common Development Tools
#######################################################

##########################
# Removed debug sections #
##########################
STRIP_ARGS ?= --strip-all
ifeq ($(STRIP_PROG),)
    ifneq ($(strip $(shell (command -v strip))),)
    # usage $(STRIP_PROG) $(STRIP_ARGS) ... ELF
        STRIP_PROG := $(Q)$(shell (command -v strip))
    endif
endif

#########################################
# Save Removed debug sections into FILE #
#########################################
EUSTRIP_ARGS ?=
ifeq ($(EUSTRIP_PROG),)
    ifneq ($(strip $(shell (command -v eu-strip))),)
    # usage $(EUSTRIP_PROG) $(EUSTRIP_ARGS) ... ELF -f FILE
        EUSTRIP_PROG := $(Q)$(shell (command -v eu-strip))
    endif
endif

###################################
# Static C/C++ code analysis tool #
###################################
CPPCHECK_ARGS ?=
ifeq ($(CPPCHECK_PROG),)
    ifneq ($(strip $(shell (command -v cppcheck))),)
        CPPCHECK_PROG := $(Q)$(shell (command -v cppcheck))
        # cppcheck-v1.8x has --project=..., cppcheck-v1.7x does not
        ifeq (1.8, $(shell cppcheck --version 2>/dev/null | cut -b 10-12))
        # usage $(CPPCHECK18_PROG) $(CPPCHECK_ARGS) --project=build/compile_commands.json
            CPPCHECK18_PROG := $(CPPCHECK_PROG)
        endif
        ifeq (1.7, $(shell cppcheck --version 2>/dev/null | cut -b 10-12))
        # usage $(CPPCHECK17_PROG) $(CPPCHECK_ARGS) source
            CPPCHECK17_PROG := $(CPPCHECK_PROG)
        endif
    endif
endif

##########################################
# Standard Documentation Generating Tool #
##########################################
DOXYGEN_ARGS ?=
ifeq ($(DOXYGEN_PROG),)
    ifneq ($(strip $(shell (command -v doxygen))),)
        DOXYGEN_PROG := $(Q)$(shell (command -v doxygen))
        CMAKE_ARGS += -DDOXYGEN_PROG=$(shell (command -v doxygen))
    endif
else
    CMAKE_ARGS += -DDOXYGEN_PROG=$(DOXYGEN_PROG)
    DOXYGEN_PROG := $(Q)$(DOXYGEN_PROG)
endif

###########################
# xmake predefined target #
###########################
PHONY += xmake-all
xmake-all: | xmake-ran-top-cmake
	$(XMAKE) -C $(BUILD_DIR)

PHONY += xmake-ran-top-cmake
xmake-ran-top-cmake:
	$(Q)cd $(BUILD_DIR) && $(CMAKE_PROG) -G $(GENERATOR) $(CMAKE_ARGS)

PHONY += xmake-test
xmake-test: | xmake-ran-top-cmake
ifeq ($(filter-out Dev Debug Coverage,$(BUILD_TYPE)),)
	$(XMAKE) -C $(BUILD_DIR) xtest
	$(Q)$(BUILD_DIR)/$(BUILD_TYPE)/bin/xtest
endif

PHONY += xmake-install
xmake-install: | xmake-all
	$(XMAKE) -C $(BUILD_DIR) install

PHONY += xmake-doxygen
xmake-doxygen: | xmake-ran-top-cmake
	$(XMAKE) -C $(BUILD_DIR) doxygen

PHONY += xmake-release
xmake-release:
ifneq (,$(wildcard scripts/release))
	@scripts/release
endif

# Use cpack for source/binary packing
# https://cmake.org/cmake/help/latest/module/CPack.html
PHONY += xmake-pkg-binary
xmake-pkg-binary: | xmake-ran-top-cmake
	$(XMAKE) -C $(BUILD_DIR) package
PHONY += xmake-pkg-source
xmake-pkg-source: | xmake-ran-top-cmake
	$(XMAKE) -C $(BUILD_DIR) package_source

PHONY += xmake-clean
xmake-clean:
	$(Q)rm -rf $(BUILD_DIR)

PHONY += xmake-distclean
xmake-distclean: xmake-clean
	$(Q)rm -rf $(DEPS_ROOT_DIR)

PHONY += xmake-auto-progs
xmake-auto-progs:
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

PHONY += xmake-help
xmake-help:
	@echo "-------------------------------------------------------------------------"
	@echo "$$ make V=1 ...      verbose of make & cmake, default is silent."
	@echo "$$ make O=path ...   build directory abs-path, default is 'build'."
	@echo "$$ make I=path ...   install directory abs-path, default is 'build/usr'."
	@echo "-------------------------------------------------------------------------"
	@echo "The <target> of the xmake Makefile are as following:"
	@echo "    all              build the project."
	@echo "    test             run project tests."
	@echo "    doxygen          generate doxygen mannual."
	@echo "    clean            clean the build directory."
	@echo "    distclean        remove all generated files."
	@echo "    install          install all the targets."
	@echo "    release          do project release."
	@echo "    pkg-binary       build binary release package."
	@echo "    pkg-source       build source release package."
	@echo "-------------------------------------------------------------------------"
#	@echo "See 'docs/local.mk' for much more setting details."
#
#	@echo "*********************************************************"
#	@echo "* For much more details: https://github.com/gkide/xmake *"
#	@echo "*********************************************************"

.PHONY: $(PHONY)
