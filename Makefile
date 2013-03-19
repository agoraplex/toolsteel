# don't let included files don't accidentally change the default goal.
.DEFAULT_GOAL := all

BASEDIR  := $(CURDIR)
BUILDDIR := build
ICONDIR  := icons

# helpers for the gnarlier rules (`icons`, etc.)
include rules.mk

COFFEE := coffee
COFFEE_FLAGS = --compile --map

LESSC := lessc


# jq: JSON stream processor (see http://stedolan.github.com/jq )
JQ := jq
json_merge = @cat $(1) | $(JQ) -s add > $(2)


# example webpage for extensions to inspect
# ----------------------------------------------------------------------
INSPECTED_DIR   = $(BUILDDIR)
INSPECTED_PARTS = inspected.html inspected.js inspected.css
INSPECTED = $(addprefix $(BUILDDIR)/,$(INSPECTED_PARTS))

# HTML is a straight copy
$(BUILDDIR)/%.html : $(BASEDIR)/%.html
	@mkdir -p $(dir $@)
	@cp -f $< $@

# JavaScript comes from CoffeeScript
$(BUILDDIR)/%.js : $(BASEDIR)/%.coffee
	@mkdir -p $(dir $@)
	$(COFFEE) $(COFFEE_FLAGS) --output $(dir $@) $^

# CSS comes from less
$(BUILDDIR)/%.css : $(BASEDIR)/%.less
	@mkdir -p $(dir $@)
	$(LESSC) $< $@

.PHONY: inspected
inspected: $(INSPECTED)
# ----------------------------------------------------------------------


# ======================
# extension feature sets
# ======================

MANIFEST := manifest.json

# devtools : an extension with a panel and elements sidebar pane
# ----------------------------------------------------------------------
DEVTOOLS_DIR = devtools
DEVTOOLS_BUILDDIR = $(BUILDDIR)/$(DEVTOOLS_DIR)
DEVTOOLS_PARTS = devtools panel sidebar

# HTML is a straight copy
DEVTOOLS_HTML = $(addsuffix .html,$(DEVTOOLS_PARTS))
$(DEVTOOLS_BUILDDIR)/%.html : $(DEVTOOLS_DIR)/%.html
	@mkdir -p $(dir $@)
	@cp -f $< $@

# JavaScript comes from CoffeeScript
DEVTOOLS_COFFEE = $(addsuffix .coffee,$(DEVTOOLS_PARTS))
$(DEVTOOLS_BUILDDIR)/%.js : $(DEVTOOLS_DIR)/%.coffee
	@mkdir -p $(dir $@)
	$(COFFEE) $(COFFEE_FLAGS) --output $(dir $@) $^

# the extension manifest is a synthesis of several partials
DEVTOOLS_MANIFESTS = $(MANIFEST) $(DEVTOOLS_DIR)/devtools.json
$(DEVTOOLS_BUILDDIR)/$(MANIFEST) : $(DEVTOOLS_MANIFESTS)
	$(call json_merge,$^,$@)

# the icons are shared, but we copy them into the extension dir
DEVTOOLS_ICONDIR = $(DEVTOOLS_BUILDDIR)/$(ICONDIR)
DEVTOOLS_ICONS = $(addprefix $(DEVTOOLS_ICONDIR)/, \
                   $(notdir $(ICON_TARGETS)))
$(DEVTOOLS_ICONS): $(ICON_TARGETS)
	@mkdir -p $(DEVTOOLS_ICONDIR)
	@cp -f $(ICON_TARGETS) $(DEVTOOLS_ICONDIR)

# the accumulated devtools targets
DEVTOOLS = $(DEVTOOLS_ICONS) \
           $(addprefix $(DEVTOOLS_BUILDDIR)/, \
                       $(DEVTOOLS_HTML) \
                       $(DEVTOOLS_COFFEE:.coffee=.js) \
                       $(MANIFEST))

.PHONY: devtools
devtools: $(DEVTOOLS)
# ----------------------------------------------------------------------


.PHONY: all
all: icons devtools inspected

.PHONY: icons
icons: $(ICON_TARGETS)

.PHONY: clean
clean:
	@rm -rf $(BUILDDIR)
	find -type d -name .git -prune \
     -or -type f \
         \( -name '*~' -or -name '#*' \) \
         -print0 | xargs -0 rm -f
