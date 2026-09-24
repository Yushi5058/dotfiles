return {
  "saecki/crates.nvim",
  event = { "BufRead Cargo.toml" },
  opts = {
    completion = {
      crates = { enabled = true, max_results = 8, min_chars = 3 },
    },
    lsp = { enabled = true, actions = true, completion = true, hover = true },
  },
}