vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Set colorscheme that supports treesitter
vim.cmd("colorscheme tokyonight")

-- Exit terminal mode with Escape
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { silent = true })

-- Enable filetype plugins and indent
vim.cmd("filetype plugin indent on")

-- Editor options
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.number = true

vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
  pattern = "*",
  command = "silent! write",
})
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    require("persistence").load()
  end,
})
