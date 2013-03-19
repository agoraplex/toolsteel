.DEFAULT_GOAL := all

BUILDDIR := build
ICONDIR  := icons

# helpers for the gnarlier rules (`icons`, etc.)
include rules.mk


.PHONY: all
all: icons

.PHONY: icons
icons: $(ICON_TARGETS)

.PHONY: clean
clean:
	@rm -rf $(BUILDDIR)
	find -type d -name .git -prune \
     -or -type f \
         \( -name '*~' -or -name '#*' \) \
         -print0 | xargs -0 rm -f
