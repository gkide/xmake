# Local make configuration
-include local.mk

# Do cmake config if needed
# CMAKE_ARGS += ...

# The xmake user-friendly template
include cmake/xmake.mk

# xmake predefined targets starts by 'xmake-*'
PHONY += all
all: xmake-all
	@echo "The real project: all ..."

PHONY += test
test: xmake-test
	@echo "The real project: test ..."

PHONY += install
install: xmake-install
	@echo "The real project: install ..."

PHONY += release
release: xmake-release
	@echo "The real project: release ..."

PHONY += clean
clean: xmake-clean
	@echo "The real project: clean ..."

PHONY += distclean
distclean: xmake-distclean
	@echo "The real project: distclean ..."

PHONY += help
help: xmake-help
	@echo "The real project: help ..."

auto:
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

.PHONY: $(PHONY)
