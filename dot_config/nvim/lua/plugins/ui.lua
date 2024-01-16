return {
  -- animate cursor
  {
    "echasnovski/mini.animate",
    event = "VeryLazy",
    opts = function(_, opts)
      opts.scroll = {
        enable = false,
      }
    end,
  },
  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    opts = function(_, opts)
      local logo = [[
██╗   ██╗██╗   ██╗███████╗██╗  ██╗██╗
╚██╗ ██╔╝██║   ██║██╔════╝██║  ██║██║
 ╚████╔╝ ██║   ██║███████╗███████║██║
  ╚██╔╝  ██║   ██║╚════██║██╔══██║██║
   ██║   ╚██████╔╝███████║██║  ██║██║
   ╚═╝    ╚═════╝ ╚══════╝╚═╝  ╚═╝╚═╝

]]
      logo = string.rep("\n", 8) .. logo .. "\n\n"
      opts.config.header = vim.split(logo, "\n")
    end,
  },
}, {
  "rcarriga/nvim-notify",
  opts = {
    timeout = 5000,
  },
}, {
  "folke/zen-mode.nvim",
  cmd = "ZenMode",
  opts = {
    plugins = {
      gitsigns = true,
      tmux = true,
      kitty = { enabled = false, font = "+2" },
    },
  },
  keys = { { "<leader>z", "<cmd>ZenMode<cr>", desc = "Zen Mode" } },
}, {
  "gelguy/wilder.nvim",
  config = function()
    local wilder = require("wilder")
    wilder.setup({ modes = { ":", "/", "?" } })
  end,
}
