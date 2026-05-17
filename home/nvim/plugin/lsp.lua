local lspconfig = require('lspconfig')
local cmp_nvim_lsp = require('cmp_nvim_lsp')

local capabilities = cmp_nvim_lsp.default_capabilities()

local servers = {
  clangd = {},
  nil_ls = {},
}

for server_name, server_config in pairs(servers) do
  server_config.capabilities = capabilities
  lspconfig[server_name].setup(server_config)
end
