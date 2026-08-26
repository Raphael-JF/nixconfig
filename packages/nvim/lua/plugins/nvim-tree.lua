--------------------- NVIM-TREE -------------------
require("nvim-tree").setup({
  view = {
    width = 40,
    side = "left",
    preserve_window_proportions = true,
  },
  update_focused_file = {
    enable = true,
    update_root = false,
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
  actions = {
    open_file = {
        quit_on_open = false,
        resize_window = true,
    },
  },
  on_attach = function(bufnr)
    local api = require("nvim-tree.api")
    local keymap = vim.keymap.set


    -- Open file
    keymap("n", "<CR>", api.node.open.edit, { buffer = bufnr, noremap = true, silent = true })

    -- Create
    keymap("n", "<C-n>", api.fs.create, { buffer = bufnr, noremap = true, silent = true })

    -- Delete
    keymap("n", "<Del>", api.fs.remove, { buffer = bufnr, noremap = true, silent = true })

    -- Rename
    keymap("n", "<F2>", api.fs.rename, { buffer = bufnr, noremap = true, silent = true })

    -- Copy
    keymap("n", "y", api.fs.copy.node, { buffer = bufnr, noremap = true, silent = true })

    -- Cut
    keymap("n", "x", api.fs.cut, { buffer = bufnr, noremap = true, silent = true })

    -- Paste
    keymap("n", "p", api.fs.paste, { buffer = bufnr, noremap = true, silent = true })
  end,
})

-- Toggle nvim-tree with Ctrl+B
vim.keymap.set("n", "<C-b>", function()
  require("nvim-tree.api").tree.toggle()
end, { noremap = true, silent = true })

-- Close current buffer
vim.keymap.set("n", "<C-q>", "<cmd>bdelete<CR>", {
  noremap = true,
  silent = true,
})
