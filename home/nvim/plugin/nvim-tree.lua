require("nvim-tree").setup({
  view = {
    width = 40,
    side = "left",
  },
  renderer = {
    icons = {
      show = {
        file = true,
        folder = true,
        folder_arrow = true,
        git = true,
      },
    },
  },
  filters = {
    dotfiles = false,
  },
  on_attach = function(bufnr)
    local api = require("nvim-tree.api")
    local keymap = vim.keymap.set

    keymap("n", "E", api.tree.expand_all, { buffer = bufnr })
    keymap("n", "W", api.tree.collapse_all, { buffer = bufnr })
  end,
})

-- Auto-open nvim-tree when starting vim with no arguments
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if vim.fn.argc() == 0 then
      require("nvim-tree.api").tree.open()
    end
  end,
})

-- Toggle nvim-tree with Ctrl+B
vim.keymap.set("n", "<C-b>", function()
  require("nvim-tree.api").tree.toggle()
end, { noremap = true, silent = true })
