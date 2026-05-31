local cmp_nvim_lsp = require('cmp_nvim_lsp')

local capabilities = cmp_nvim_lsp.default_capabilities()

vim.lsp.config('clangd', {
    capabilities = capabilities,
    cmd = {
        "clangd",
        "--background-index",
        "--compile-commands-dir=.",
        "--query-driver=/home/raph/.platformio/packages/toolchain-*/bin/*",
    },
})

vim.lsp.config('nil_ls', {
    capabilities = capabilities,
})

vim.lsp.enable({ 'clangd', 'nil_ls' })