return {
    "neovim/nvim-lspconfig",
    config = function()
        local lspconfig = require("lspconfig")
        local capabilities = vim.lsp.protocol.make_client_capabilities()
            lspconfig.lua_ls.setup{
                settings = {
                    Lua = {
                        completion = {
                            callSnippet = "Replace",
                        },
                    }}
                }
                lspconfig.tsserver.setup{}
                lspconfig.ruby_lsp.setup{}
                lspconfig.html.setup{}
                lspconfig.cssls.setup{}
                lspconfig.jsonls.setup{}
                lspconfig.clangd.setup{}
                lspconfig.emmet_ls.setup{}
        end
    }
