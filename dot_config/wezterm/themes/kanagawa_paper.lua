
-- Kanagawa Paper Wezterm Colors
-- Upstream: https://github.com/sho-87/kanagawa-paper.nvim/blob/master/extras/wezterm.toml

return {
  colors = {
    ansi = {
      "#0d0c0c",
      "#c4746e",
      "#8a9a7b",
      "#c4b28a",
      "#8ba4b0",
      "#a292a3",
      "#8ea4a2",
      "#C8C093",
    },
    brights = {
      "#a6a69c",
      "#E46876",
      "#87a987",
      "#E6C384",
      "#7FB4CA",
      "#938AA9",
      "#7AA89F",
      "#c5c9c5",
    },
    background = '#1F1F28',
    foreground = '#DCD7BA',
    cursor_bg = '#c8c093',
    cursor_fg = '#1f1f28',
    cursor_border = '#c8c093',
    selection_bg = '#658594',
    selection_fg = '#c8c093',
    scrollbar_thumb = '#393836',
    split = '#8992a7',

    indexed = {
      [16] = '#b6927b',
      [17] = '#ff5d62',
    },
  },
  metadata = {
    name = 'kanagawa-paper',
    origin_url = 'https://github.com/sho-87/kanagawa-paper.nvim/blob/master/extras/wezterm.toml',
  },
}
```

Copiez ce code dans un fichier Lua et utilisez-le pour configurer les couleurs dans Wezterm.
