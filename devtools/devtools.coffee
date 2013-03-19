# the "Elements" devtools panel (an `ElementsPanel` instance)
elementsPanel = chrome.devtools.panels.elements


# a sidebar pane with custom HTML and JavaScript
elementsPanel.createSidebarPane "HTML Sidebar",
  (sidebar) ->
    sidebar.setPage("sidebar.html")


# a sidebar pane with a tree control, populated by an expression
# evaluated in the context of the inspected window
elementsPanel.createSidebarPane "Expression Sidebar",
  (sidebar) ->
    sidebar.setExpression("""(function () {
      return {
        __proto__: null,
        url: window.location.toString()
      };
    })()""")


# a sidebar pane with a tree control, populated by a JSON-ish object
# evaluated in this (the caller's) context
elementsPanel.createSidebarPane "Object Sidebar",
  (sidebar) ->
    # **NOTE:** `timesShown` resets whenever devtools window is closed
    timesShown = 0

    updateSidebar = () ->
      timesShown += 1
      sidebar.setObject
        name: "example"
        timesShown: timesShown
        description: "an example of something"
        values: [
          { red: 0, green: 1, blue: 2 }
          { red: -1, green: 0, blue: 1 }
        ]

    # force initial update
    updateSidebar()

    # update object whenever "Elements" panel is re-visited
    sidebar.onShown.addListener ->
      updateSidebar()
