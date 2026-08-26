local servers = {
    clangd = "clangd",
    pyright = "pyright",
    nil_ls = "nil",
    bashls = "bash-language-server",
    texlab = "texlab",
    html = "vscode-html-language-server",
    cssls = "vscode-css-language-server",
    ts_ls = "typescript-language-server",
}

for server, executable in pairs(servers) do
    if vim.fn.executable(executable) == 1 then
        vim.lsp.enable(server)
    end
end


vim.diagnostic.config({
  virtual_lines = true,
  virtual_text = false,
})
