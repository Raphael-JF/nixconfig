
require("flash").setup({
  labels = "asdfghjklqwertyuiopzxcvbnm",
  modes = {
    char = {
      enabled = true,
      jump_labels = true,
      keys = {} 
    },
    search = {
      enabled = true,
    },
  },
  jump = {
    autojump = false,
    history = true,
    register = true,
    nohlsearch = true,
  }, 
  label = {
    rainbow = {
      enabled = false,
    },
  },
})
local flash = require("flash")

vim.keymap.set({ "n", "x", "o" }, "f", flash.jump, { desc = "Flash" })
-- vim.keymap.set({ "n", "x", "o" }, "S", flash.treesitter, { desc = "Flash Treesitter" })
