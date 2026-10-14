return {
	"GustavEikaas/easy-dotnet.nvim",
	dependencies = { "nvim-lua/plenary.nvim", "folke/which-key.nvim" },
	config = function()
		local dotnet = require("easy-dotnet")
		dotnet.setup({})
-- Custom command / keymap to run `dotnet watch`
    local function dotnet_watch()
      -- Discover projects using easy-dotnet's built-in project finder
      local projects = dotnet.get_environment().projects
      if not projects or #projects == 0 then
        vim.notify("No .csproj files found in solution/workspace", vim.log.levels.WARN)
        return
      end

      -- If only 1 project exists, run it directly; otherwise prompt
      local function run_watch(project_path)
        local cmd = string.format("dotnet watch --project %s run --launch-profile https", vim.fn.fnameescape(project_path))
        vim.cmd("botright split | resize 15 | term " .. cmd)
      end

      if #projects == 1 then
        run_watch(projects[1].path or projects[1])
      else
        vim.ui.select(projects, {
          prompt = "Select project for dotnet watch:",
          format_item = function(item)
            return item.name or item
          end,
        }, function(choice)
          if choice then
            run_watch(choice.path or choice)
          end
        end)
      end

            -- AZERTY-friendly mnemonics + dotnet group
            local wk = require("which-key")
            wk.add({
                { "<leader>d", group = "dotnet" },
                { "<leader>dw", dotnet_watch, desc = "Dotnet Watch (Hot Reload)", mode = "n" },
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
                {
                    "<leader>djr",
                    function()
                        dotnet.run()
                    end,
                    desc = "Run (job)",
                },
                {
                    "<leader>djb",
                    function()
                        dotnet.build()
                    end,
                    desc = "Build (job)",
                },
                {
                    "<leader>djt",
                    function()
                        dotnet.test()
                    end,
                    desc = "Test (job)",
                },
            })
        end,
}
