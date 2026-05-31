vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Set colorscheme that supports treesitter
vim.cmd("colorscheme kanagawa")

-- Exit terminal mode with Escape
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { silent = true })

-- Enable filetype plugins and indent
vim.cmd("filetype plugin indent on")

-- Editor options
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.number = true
vim.opt.clipboard = "unnamedplus"

-- Tab configuration
vim.opt.showtabline = 2  -- Always show tabline

local function tab_label(tabpage)
  local window = vim.fn.tabpagewinnr(tabpage)
  local buffer = vim.fn.tabpagebuflist(tabpage)[window]
  local buffer_name = vim.api.nvim_buf_get_name(buffer)

  if buffer_name == "" then
    return "[No Name]"
  end

  return vim.fn.fnamemodify(buffer_name, ":.")
end

function _G.TabLine()
  local tabline = {}
  local current_tab = vim.fn.tabpagenr()
  local tab_count = vim.fn.tabpagenr("$")

  for tabpage = 1, tab_count do
    local selected = tabpage == current_tab and "%#TabLineSel#" or "%#TabLine#"
    table.insert(tabline, selected)
    table.insert(tabline, "%" .. tabpage .. "T")
    table.insert(tabline, " " .. tab_label(tabpage) .. " ")
  end

  table.insert(tabline, "%#TabLineFill#%T")
  return table.concat(tabline)
end

vim.opt.tabline = "%!v:lua.TabLine()"

-- Configure clipboard for Wayland using wl-clipboardj
-- vim.g.clipboard = {
--   name = "wl-clipboard",
--   copy = {
--     ["+"] = "wl-copy --foreground --type text/plain",
--     ["*"] = "wl-copy --primary --foreground --type text/plain",
--   },
--   paste = {
--     ["+"] = "wl-paste --no-newline",
--     ["*"] = "wl-paste --primary --no-newline",
--   },
-- }

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



-- Tab navigation keymaps
vim.keymap.set('n', '<C-t>', ':tabnew<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<Tab>', ':tabnext<CR>', { silent = true })
vim.keymap.set('n', '<S-Tab>', ':tabprevious<CR>', { silent = true })
vim.keymap.set('n', '<C-q>', ':tabclose<CR>', { noremap = true, silent = true })

-- Source - https://stackoverflow.com/a/74584098
-- Posted by Brotify Force, modified by community. See post 'Timeline' for change history
-- Retrieved 2026-05-26, License - CC BY-SA 4.0

vim.api.nvim_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { noremap = true, silent = true })


-- doing it the hard way
vim.keymap.set('', '<Up>', '<Nop>', { noremap = true, silent = true })
vim.keymap.set('', '<Down>', '<Nop>', { noremap = true, silent = true })
vim.keymap.set('', '<Left>', '<Nop>', { noremap = true, silent = true })
vim.keymap.set('', '<Right>', '<Nop>', { noremap = true, silent = true })