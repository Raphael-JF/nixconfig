require("nvim-tree").setup({
  view = {
    width = 40,
    side = "left",
    preserve_window_proportions = true,
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
    },
  },
  on_attach = function(bufnr)
    local api = require("nvim-tree.api")
    local keymap = vim.keymap.set

    -- Navigation and expand/collapse
    keymap("n", "E", api.tree.expand_all, { buffer = bufnr, noremap = true, silent = true })
    keymap("n", "W", api.tree.collapse_all, { buffer = bufnr, noremap = true, silent = true })
    keymap("n", "<Right>", api.node.open.edit, { buffer = bufnr, noremap = true, silent = true })
    keymap("n", "<Left>", api.node.navigate.parent_close, { buffer = bufnr, noremap = true, silent = true })

    -- Open file
    keymap("n", "<CR>", api.node.open.edit, { buffer = bufnr, noremap = true, silent = true })

    -- Create
    keymap("n", "a", api.fs.create, { buffer = bufnr, noremap = true, silent = true })

    -- Create folder
    keymap("n", "d", function()
      api.fs.create(vim.fn.input("Folder name: ") .. "/")
    end, { buffer = bufnr, noremap = true, silent = true })

    -- Delete
    keymap("n", "<Del>", api.fs.remove, { buffer = bufnr, noremap = true, silent = true })

    -- Rename
    keymap("n", "r", api.fs.rename, { buffer = bufnr, noremap = true, silent = true })

    -- Copy
    keymap("n", "c", api.fs.copy.node, { buffer = bufnr, noremap = true, silent = true })

    -- Cut
    keymap("n", "x", api.fs.cut, { buffer = bufnr, noremap = true, silent = true })

    -- Paste
    keymap("n", "v", api.fs.paste, { buffer = bufnr, noremap = true, silent = true })
  end,
})

-- Toggle nvim-tree with Ctrl+B
vim.keymap.set("n", "<C-b>", function()
  require("nvim-tree.api").tree.toggle()
end, { noremap = true, silent = true })
