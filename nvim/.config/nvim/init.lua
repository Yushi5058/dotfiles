require("config.options")   -- options first so timeoutlen etc. are set before plugins
require("config.lazy")      -- bootstrap lazy + load plugins
require("config.keymaps")
require("config.autocmds")
