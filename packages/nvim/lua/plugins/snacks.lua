
require("snacks").setup({
  -- Recherche fuzzy (remplace Telescope pour beaucoup d'usages)
  picker = {
    enabled = true,
  },

  -- Notifications propres
  notifier = {
    enabled = true,
    timeout = 3000,
    top_down = false,
  },

  -- Remplace vim.ui.input()
  input = {
    enabled = true,
  },

  -- Terminal flottant
  terminal = {
    enabled = true,
  },

  -- Explorateur de fichiers (optionnel si tu gardes nvim-tree)
  explorer = {
    enabled = false,
  },

  -- Guides d'indentation
  indent = {
    enabled = true,
  },

  -- Animations
  animate = {
    enabled = true,
  },

  -- Dashboard au démarrage
  dashboard = {
    enabled = true,
    sections = {
      { section = "header" },
      { section = "keys", gap = 1 },
    },
  },

  -- Git browse (ouvre les liens github)
  gitbrowse = {
    enabled = true,
  },
})

local keymap = vim.keymap.set

keymap("n", "<leader>ii", function() Snacks.image.hover() end, { desc = "Preview image/math" })
keymap("n", "<C-p>", function()
  Snacks.picker.files()
end, { desc = "Find files" })

keymap("n", "<leader>fg", function()
  Snacks.picker.grep()
end, { desc = "Live grep" })

keymap("n", "<leader>fb", function()
  Snacks.picker.buffers()
end, { desc = "Buffers" })

keymap("n", "<leader>fh", function()
  Snacks.picker.help()
end, { desc = "Help" })

keymap("n", "<leader>tt", function()
  Snacks.terminal()
end, { desc = "Terminal" })

keymap("n", "<leader>nh", function()
  Snacks.notifier.show_history()
end, { desc = "Notification history" })


------------ grug-far --------------
-- Ouvre grug-far avec Ctrl-F, depuis n'importe quel buffer
vim.keymap.set('n', '<C-f>', function()
    require('grug-far').open()
end, { desc = 'Open grug-far' })

-- Dans le buffer grug-far, Ctrl-F ferme l'instance courante
vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('grug-far-keybindings', { clear = true }),
    pattern = { 'grug-far' },
    callback = function()
        vim.keymap.set('n', '<C-f>', function()
            local inst = require('grug-far').get_instance(0)
            if inst then
                inst:close()
            end
        end, { buffer = true })
    end,
})


