-- lsp.lua

-- Configuration des serveurs LSP
local lspconfig = require('lspconfig')

-- Configuration spécifique pour chaque serveur LSP
local servers = {
  html = {},
  cssls = {},
  tsserver = {},
  bashls = {},
  solargraph = {},
  vuels = {},
  rubocop = {},
  eslint = {},
  tailwindcss = {}, 
}

-- Fonction pour configurer les serveurs LSP
local function setup_servers()
  for server, config in pairs(servers) do
    lspconfig[server].setup(config)
  end
end

-- Configurer les serveurs LSP
setup_servers()
