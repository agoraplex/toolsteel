# generate icons from SVG files
# ----------------------------------------------------------------------
# Expects:
# - BUILDDIR     : the base output directory
# - ICONDIR      : the base icon source directory
#
# Provides:
# - ICON_TARGETS : a list of target icon filenames
# ----------------------------------------------------------------------

# icon defaults
ICON_BGCOLOR := none

# tools
INKSCAPE := inkscape
INKSCAPE_ARGS = -b $(ICON_BGCOLOR) -D -z

# icon basenames and sizes (one size var per basename)
ICON_NAMES := icon
ICON_SIZES_icon := 16 19 38 48 128


# template to create a single icon size from the SVG source
# expects: (1:source.svg, 2:target.png, 3:size)
define ICON_RULE_template =
ICON_TARGETS += $(BUILDDIR)/$(ICONDIR)/$(2)
$(BUILDDIR)/$(ICONDIR)/$(2): $(ICONDIR)/$(1)
	@mkdir -p $$(dir $$@)
	$$(INKSCAPE) $$(INKSCAPE_ARGS) -h $(3) -e $$@ $$<
endef

# wrapper to generate icon rule from template
icon_rule = $(call ICON_RULE_template,$(name).svg,$(name)$(size).png,$(size))

# generate rules and target list for each (icon, size) pair
ICON_TARGETS :=
$(foreach name,$(ICON_NAMES), \
  $(foreach size,$(ICON_SIZES_$(name)), \
    $(eval $(icon_rule))))
