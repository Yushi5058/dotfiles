return {
  "GustavEikaas/easy-dotnet.nvim",
  dependencies = { "nvim-lua/plenary.nvim", "folke/which-key.nvim" },
  config = function()
    local dotnet = require("easy-dotnet")
    dotnet.setup({})

    -- AZERTY-friendly mnemonics + dotnet group
    local wk = require("which-key")
    wk.add({
      { "<leader>d", group = "dotnet" },
      { "<leader>dr", dotnet.run, desc = "Run project" },
      { "<leader>db", dotnet.build, desc = "Build project" },
      { "<leader>dt", dotnet.test, desc = "Run tests" },
      { "<leader>dp", dotnet.project, desc = "Select project" },
      { "<leader>ds", dotnet.solution, desc = "Select solution" },
      { "<leader>dc", dotnet.clean, desc = "Clean solution/project" },
      { "<leader>du", dotnet.restore, desc = "Restore" },
      { "<leader>da", dotnet.add_package, desc = "Add package" },
      { "<leader>dl", dotnet.list_projects, desc = "List projects" },
      { "<leader>dj", group = "jobs" },
      { "<leader>djr", function() dotnet.run() end, desc = "Run (job)" },
      { "<leader>djb", function() dotnet.build() end, desc = "Build (job)" },
      { "<leader>djt", function() dotnet.test() end, desc = "Test (job)" },
    })
  end,
}
