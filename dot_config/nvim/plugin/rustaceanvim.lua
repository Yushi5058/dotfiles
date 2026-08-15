vim.pack.add({
  {
    src = "https://github.com/mrcjkb/rustaceanvim",
    version = vim.version.range("^9"),
  },
})

local function setup_rustaceanvim()
  vim.g.rustaceanvim = {
    tools = {
      test_executor = "background",
    },
    server = {
      default_settings = {
        ["rust-analyzer"] = {
          checkOnSave = true,
          cargo = {
            buildScripts = { enable = true, rebuildOnChange = true },
          },
        },
      },
    },
  }
  vim.cmd("packadd rustaceanvim")
end

local has_rustaceanvim, _ = pcall(require, "rustaceanvim")
if has_rustaceanvim then
  setup_rustaceanvim()
else
  vim.api.nvim_create_autocmd("PackChanged", {
    callback = function(ev)
      if ev.data and ev.data.spec and ev.data.spec.name == "rustaceanvim" then
        vim.defer_fn(setup_rustaceanvim, 100)
      end
    end,
  })
end