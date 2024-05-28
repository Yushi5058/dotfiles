return
	{ -- This plugin
		"Zeioth/compiler.nvim",
		cmd = { "CompilerOpen", "CompilerToggleResults", "CompilerRedo" },
		dependencies = { "stevearc/overseer.nvim" },
		opts = {},
	},
	{ -- The task runner we use
		"stevearc/overseer.nvim",
		cmd = { "CompilerOpen", "CompilerToggleResults", "CompilerRedo" },
		opts = {
			task_list = {
				direction = "bottom",
				min_height = 25,
				max_height = 25,
				default_detail = 1
			},
		},
		config = function()
			-- Open compiler
			vim.keymap.set('n', '<F6>', "<cmd>CompilerOpen<cr>", { noremap = true, silent = true })

			-- Redo last selected option
			vim.keymap.set('n', '<S-F6>',
				"<cmd>CompilerStop<cr>" -- (Optional, to dispose all tasks before redo)
				.. "<cmd>CompilerRedo<cr>",
				{ noremap = true, silent = true })

			-- Toggle compiler results
			vim.keymap.set('n', '<S-F7>', "<cmd>CompilerToggleResults<cr>", { noremap = true, silent = true })
		end
	}
