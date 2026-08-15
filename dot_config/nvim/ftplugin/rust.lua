local map = vim.keymap.set
local buf = { buffer = true, silent = true }

-- Grouped code actions (rust-analyzer grouping support)
map("n", "<leader>a", function() vim.cmd.RustLsp("codeAction") end, vim.tbl_extend("force", buf, { desc = "Code actions" }))

-- Hover actions (run command twice to enter the window, or set auto_focus)
map("n", "K", function() vim.cmd.RustLsp({ "hover", "actions" }) end, vim.tbl_extend("force", buf, { desc = "Hover actions" }))

-- Cargo run / test prompt from rust-analyzer
map("n", "<leader>rr", function() vim.cmd.RustLsp("runnables") end, vim.tbl_extend("force", buf, { desc = "Rust: runnables" }))
map("n", "<leader>rt", function() vim.cmd.RustLsp("testables") end, vim.tbl_extend("force", buf, { desc = "Rust: testables" }))

-- Explain error code / render diagnostic under cursor
map("n", "<leader>re", function() vim.cmd.RustLsp("explainError") end, vim.tbl_extend("force", buf, { desc = "Rust: explain error" }))
map("n", "<leader>rd", function() vim.cmd.RustLsp("renderDiagnostic") end, vim.tbl_extend("force", buf, { desc = "Rust: render diagnostic" }))

-- Expand macro at cursor (vertical split)
map("n", "<leader>rx", function() vim.cmd.RustLsp({ "expandMacro", "vertical" }) end, vim.tbl_extend("force", buf, { desc = "Rust: expand macro" }))

-- Rebuild procedural macros
map("n", "<leader>rp", function() vim.cmd.RustLsp("rebuildProcMacros") end, vim.tbl_extend("force", buf, { desc = "Rust: rebuild proc macros" }))

-- Open Cargo.toml / docs.rs for symbol under cursor
map("n", "<leader>rc", function() vim.cmd.RustLsp("openCargo") end, vim.tbl_extend("force", buf, { desc = "Rust: open Cargo.toml" }))
map("n", "<leader>ro", function() vim.cmd.RustLsp("openDocs") end, vim.tbl_extend("force", buf, { desc = "Rust: open docs.rs" }))

-- Structural search & replace (whole buffer in normal, selection in visual)
map("n", "<leader>rs", function() vim.cmd.RustLsp({ "ssr" }) end, vim.tbl_extend("force", buf, { desc = "Rust: structural search replace" }))
map("x", "<leader>rs", function() vim.cmd.RustLsp({ "ssr" }) end, vim.tbl_extend("force", buf, { desc = "Rust: SSR selection" }))

-- Move item up/down
map("n", "<leader>rj", function() vim.cmd.RustLsp({ "moveItem", "down" }) end, vim.tbl_extend("force", buf, { desc = "Rust: move item down" }))
map("n", "<leader>rk", function() vim.cmd.RustLsp({ "moveItem", "up" }) end, vim.tbl_extend("force", buf, { desc = "Rust: move item up" }))

-- Related diagnostics / tests navigation
map("n", "<leader>rn", function() vim.cmd.RustLsp("relatedDiagnostics") end, vim.tbl_extend("force", buf, { desc = "Rust: related diagnostics" }))
map("n", "<leader>rtl", function() vim.cmd.RustLsp("relatedTests") end, vim.tbl_extend("force", buf, { desc = "Rust: related tests" }))