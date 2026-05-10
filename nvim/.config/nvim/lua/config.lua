_G.Config = {
  lsp = {},
  mason = {},
  conform = {},
  lint = {},
  whichkey = {},
}

function _G.Config.add(spec)
  local merge = require("merge")
  merge(_G.Config, spec)
end