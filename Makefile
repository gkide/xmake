# Local make configuration
-include local.mk
# The xmake user-friendly template
include cmake/xmake.mk

# xmake predefined targets starts by 'xmake-*'
PHONY += all
all: xmake-all
	@echo "The real project all ..."

PHONY += test
test: xmake-test
	@echo "The real project test ..."

PHONY += install
install: xmake-install
	@echo "The real project helps ..."

PHONY += release
release: xmake-release
	@echo "The real project release ..."

PHONY += clean
clean: xmake-clean
	@echo "The real project clean ..."

PHONY += distclean
distclean: xmake-distclean
	@echo "The real project distclean ..."

PHONY += help
help: xmake-help
	@echo "The real project helps ..."

.PHONY: $(PHONY)
