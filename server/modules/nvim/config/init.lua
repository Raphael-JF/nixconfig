vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Set colorscheme that supports treesitter
vim.cmd("colorscheme kanagawa")

-- Exit terminal modewith Escape
-- vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { silent = true })

-- Enable filetype plugins and indent
vim.cmd("filetype plugin indent on")

-- Editor options
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.number = true
vim.opt.clipboard = "unnamedplus"

-- Tab configuration
vim.opt.showtabline = 2  -- Always show tabline

-- Scroll configuration
vim.opt.scrolloff = 5

-- Commenting keymaps
vim.keymap.set('v', '<C-">', "gc", { desc = 'Comment selection', remap = true })
vim.keymap.set('v', '<C-S-">', "gc", { desc = 'Comment selection', remap = true })
vim.keymap.set('n', '<C-">', "gcc", { desc = 'Comment line', remap = true })
vim.keymap.set('n', '<C-S-">', "gcc", { desc = 'Comment line', remap = true })




vim.keymap.set('n', '<leader>wk', function()
  print("Prochaine touche pressée:")
  local key = vim.fn.getcharstr()
  local map = vim.fn.maparg(key, 'n', false, true)
  if vim.tbl_isempty(map) then
    print('Pas de mapping pour: ' .. vim.fn.keytrans(key))
  else
    print(vim.inspect(map))
  end
end, { desc = 'Inspecter la prochaine touche pressée' })


-- copy all
vim.keymap.set('n', '<C-a>y', ':%y<CR>', { desc = 'Yank all' })

-- delete all
vim.keymap.set('n', '<C-a>d', ':%d<CR>', { desc = 'Delete all' })

-- select all
vim.keymap.set('n', '<C-a>a', 'ggVG', { desc = 'Select all' })

-- auto save on insert leave and text changed
vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
  pattern = "*",
  command = "silent! write",
})



-- LSP diagnostics configuration
vim.diagnostic.config({
  virtual_text = true,   -- affiche les erreurs à droite de la ligne
  signs = true,
  underline = true,
  update_in_insert = false,
  })

vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Aller à la définition" }) 
vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Voir les références" }) 
vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Voir l'implémentation" }) 
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Afficher la documentation (hover)" })-- doing it the hard way 

vim.keymap.set('', '<Up>', '<Nop>', { noremap = true, silent = true })
vim.keymap.set('', '<Down>', '<Nop>', { noremap = true, silent = true })
vim.keymap.set('', '<Left>', '<Nop>', { noremap = true, silent = true })
vim.keymap.set('', '<Right>', '<Nop>', { noremap = true, silent = true })

-- removing the J thing
vim.keymap.set("n", "J", "<Nop>")
vim.keymap.set("n", "K", "<Nop>")

-- easy indenting
vim.keymap.set("v", "<Tab>", ">gv", { desc = "Indent and keep selection" })
vim.keymap.set("v", "<S-Tab>", "<gv", { desc = "Unindent and keep selection" })

vim.opt.number = true
vim.opt.relativenumber = true


-------------- imports -----------------
dofile("config/plugins/sidekick.lua")
dofile("config/plugins/lsp.lua")
dofile("config/plugins/treesitter.lua")
dofile("config/plugins/lualine.lua")
dofile("config/plugins/nvim-tree.lua")
dofile("config/plugins/bufferline.lua")
dofile("config/plugins/snacks.lua")
dofile("config/plugins/visual-multi.lua")
dofile("config/plugins/flash.lua")
