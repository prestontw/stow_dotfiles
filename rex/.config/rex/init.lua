-- Keep Rex defaults, including cmd+k for the session picker.
-- Forward modified arrows unchanged for Helix syntax-tree navigation.
rex.bind("alt+left", "pane.send_key", { key = "alt+left" })
rex.bind("alt+right", "pane.send_key", { key = "alt+right" })
